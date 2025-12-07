/**
 * 監査ログAPI関数
 * システム内のすべてのアクションの監査ログを記録・取得
 * バックエンドが利用可能な場合はプロキシ、利用不可の場合はモックデータを返す
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

  // バックエンドにプロキシを試行
  try {
    const backendResponse = await proxyToBackend(req, '/api/audit');
    if (backendResponse) {
      return res.status(200).json(backendResponse);
    }
  } catch (error) {
    // バックエンドが利用できない場合はモックデータを使用
    console.warn('Backend unavailable, using mock data:', error.message);
  }

  // HTTPメソッドに基づいて処理を分岐
  switch (req.method) {
    case 'GET':
      // デモンストレーション用のモック監査ログデータ
      const auditLogs = [
        {
          id: 1, // 監査ログID
          userId: 1, // ユーザーID
          username: 'john.doe', // ユーザー名
          action: 'USER_LOGIN', // アクション：ユーザーログイン
          resource: 'AUTHENTICATION', // リソース：認証
          resourceId: null, // リソースID：該当なし
          details: 'User logged in successfully', // 詳細：ログイン成功
          timestamp: '2024-01-20T15:30:00Z', // タイムスタンプ
          ipAddress: '192.168.1.100', // IPアドレス
          userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36' // ユーザーエージェント
        },
        {
          id: 2, // 監査ログID
          userId: 2, // ユーザーID
          username: 'jane.smith', // ユーザー名
          action: 'APPLICATION_SUBMIT', // アクション：申請提出
          resource: 'MEDICAL_APPLICATION', // リソース：医療申請
          resourceId: 123, // リソースID：申請ID
          details: 'Medical certificate application submitted', // 詳細：医療証明書申請提出
          timestamp: '2024-01-20T14:45:00Z', // タイムスタンプ
          ipAddress: '192.168.1.101', // IPアドレス
          userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36' // ユーザーエージェント
        }
      ];

      // 監査ログ一覧をJSON形式で返却（モックデータ）
      res.status(200).json(createSuccessResponse(auditLogs, 'Audit logs retrieved successfully (mock data)'));
      break;

    case 'POST':
      try {
        const auditData = req.body; // リクエストボディから監査データを取得
        
        // モック監査ログ作成処理
        const newAuditLog = {
          id: Date.now(), // 現在時刻をIDとして使用
          ...auditData, // リクエストデータを展開
          timestamp: new Date().toISOString(), // タイムスタンプ
          ipAddress: req.headers['x-forwarded-for'] || req.connection?.remoteAddress || 'unknown', // IPアドレス（プロキシ対応）
          userAgent: req.headers['user-agent'] || 'unknown' // ユーザーエージェント
        };

        // 監査ログ作成成功レスポンス（モックデータ）
        res.status(201).json(createSuccessResponse(newAuditLog, 'Audit log created successfully (mock data)'));
      } catch (error) {
        // エラーが発生した場合の処理
        res.status(400).json(createErrorResponse(400, 'Invalid audit data', error));
      }
      break;

    default:
      // 許可されていないHTTPメソッドの場合
      res.status(405).json(createErrorResponse(405, 'Method not allowed'));
  }
}
