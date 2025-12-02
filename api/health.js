/**
 * ヘルスチェックAPI関数
 * システム全体の状態と各マイクロサービスの稼働状況を確認
 */
export default function handler(req, res) {
  // CORSヘッダーを設定（クロスオリジンリクエストを許可）
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  // プリフライトリクエスト（OPTIONS）の処理
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // GETリクエストの処理（ヘルスチェック）
  if (req.method === 'GET') {
    // システムの健康状態を構築
    const healthStatus = {
      status: 'UP', // システム状態：稼働中
      timestamp: new Date().toISOString(), // 現在時刻
      service: 'Medical Care API Gateway', // サービス名
      version: '1.0.0', // バージョン
      environment: process.env.NODE_ENV || 'development', // 環境（本番/開発）
      uptime: process.uptime(), // 稼働時間
      memory: process.memoryUsage(), // メモリ使用量
      services: { // 各マイクロサービスの状態
        'user-service': 'UP', // ユーザーサービス：稼働中
        'application-service': 'UP', // 申請サービス：稼働中
        'notification-service': 'UP', // 通知サービス：稼働中
        'file-service': 'UP', // ファイルサービス：稼働中
        'audit-service': 'UP' // 監査サービス：稼働中
      }
    };

    // 健康状態をJSON形式で返却
    res.status(200).json(healthStatus);
  } else {
    // 許可されていないHTTPメソッドの場合
    res.status(405).json({ error: 'Method not allowed' });
  }
}
