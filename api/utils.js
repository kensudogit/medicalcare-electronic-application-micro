/**
 * APIユーティリティ関数
 * バックエンド接続とエラーハンドリング
 */

/**
 * バックエンドURLを取得
 */
export function getBackendUrl() {
  return process.env.API_GATEWAY_URL || process.env.RAILWAY_API_GATEWAY_URL || null;
}

/**
 * バックエンドにリクエストをプロキシ
 */
export async function proxyToBackend(req, endpoint, options = {}) {
  const backendUrl = getBackendUrl();
  
  // バックエンドURLが設定されていない場合はnullを返す（モックデータを使用）
  if (!backendUrl) {
    return null;
  }

  try {
    const url = `${backendUrl}${endpoint}`;
    const method = req.method || 'GET';
    const headers = {
      'Content-Type': 'application/json',
      ...options.headers,
    };

    // リクエストボディを取得
    let body = null;
    if (req.body && (method === 'POST' || method === 'PUT' || method === 'PATCH')) {
      body = JSON.stringify(req.body);
    }

    // タイムアウト設定（10秒）
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 10000);

    const response = await fetch(url, {
      method,
      headers,
      body,
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (!response.ok) {
      throw new Error(`Backend responded with status ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Backend proxy error:', error.message);
    
    // タイムアウトエラー
    if (error.name === 'AbortError') {
      throw new Error('Request timeout: Backend server did not respond in time');
    }
    
    // ネットワークエラー
    if (error.message.includes('fetch')) {
      throw new Error('Network error: Unable to connect to backend server');
    }
    
    throw error;
  }
}

/**
 * エラーレスポンスを生成
 */
export function createErrorResponse(statusCode, message, error = null) {
  return {
    success: false,
    error: message,
    message: error?.message || message,
    timestamp: new Date().toISOString(),
    ...(process.env.NODE_ENV === 'development' && error && { stack: error.stack }),
  };
}

/**
 * 成功レスポンスを生成
 */
export function createSuccessResponse(data, message = null) {
  return {
    success: true,
    data,
    ...(message && { message }),
    timestamp: new Date().toISOString(),
  };
}

/**
 * CORSヘッダーを設定
 */
export function setCorsHeaders(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
  res.setHeader('Access-Control-Max-Age', '86400');
}

