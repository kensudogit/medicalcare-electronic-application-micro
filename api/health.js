/**
 * ヘルスチェックAPI関数
 * システム全体の状態と各マイクロサービスの稼働状況を確認
 * バックエンドが利用可能な場合はプロキシ、利用不可の場合はローカルステータスを返す
 */
import { setCorsHeaders, proxyToBackend, createErrorResponse, createSuccessResponse } from './utils.js';

export default async function handler(req, res) {
  // CORSヘッダーを設定
  setCorsHeaders(res);

  // プリフライトリクエスト（OPTIONS）の処理
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // GETリクエストの処理（ヘルスチェック）
  if (req.method === 'GET') {
    // バックエンドにプロキシを試行
    try {
      const backendResponse = await proxyToBackend(req, '/health');
      if (backendResponse) {
        return res.status(200).json(backendResponse);
      }
    } catch (error) {
      // バックエンドが利用できない場合はローカルステータスを返す
      console.warn('Backend unavailable, returning local status:', error.message);
    }

    // ローカルシステムの健康状態を構築
    const healthStatus = {
      status: 'UP', // システム状態：稼働中
      timestamp: new Date().toISOString(), // 現在時刻
      service: 'Medical Care API Gateway (Vercel)', // サービス名
      version: '1.0.0', // バージョン
      environment: process.env.NODE_ENV || 'development', // 環境（本番/開発）
      uptime: process.uptime(), // 稼働時間
      memory: process.memoryUsage(), // メモリ使用量
      backend: {
        connected: false, // バックエンド接続状態
        url: process.env.API_GATEWAY_URL || process.env.RAILWAY_API_GATEWAY_URL || 'Not configured'
      },
      services: { // 各マイクロサービスの状態
        'user-service': 'MOCK', // ユーザーサービス：モックデータ
        'application-service': 'MOCK', // 申請サービス：モックデータ
        'notification-service': 'MOCK', // 通知サービス：モックデータ
        'file-service': 'MOCK', // ファイルサービス：モックデータ
        'audit-service': 'MOCK' // 監査サービス：モックデータ
      }
    };

    // 健康状態をJSON形式で返却
    res.status(200).json(healthStatus);
  } else {
    // 許可されていないHTTPメソッドの場合
    res.status(405).json(createErrorResponse(405, 'Method not allowed'));
  }
}
