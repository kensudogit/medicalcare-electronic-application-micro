/**
 * 監査ログAPI関数
 * システム内のすべてのアクションの監査ログを記録・取得
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

      // 監査ログ一覧をJSON形式で返却
      res.status(200).json({
        success: true, // 成功フラグ
        data: auditLogs, // 監査ログデータ
        total: auditLogs.length, // 総監査ログ数
        timestamp: new Date().toISOString() // レスポンス時刻
      });
      break;

    case 'POST':
      try {
        const auditData = req.body; // リクエストボディから監査データを取得
        
        // モック監査ログ作成処理
        const newAuditLog = {
          id: Date.now(), // 現在時刻をIDとして使用
          ...auditData, // リクエストデータを展開
          timestamp: new Date().toISOString(), // タイムスタンプ
          ipAddress: req.headers['x-forwarded-for'] || req.connection.remoteAddress || 'unknown', // IPアドレス（プロキシ対応）
          userAgent: req.headers['user-agent'] || 'unknown' // ユーザーエージェント
        };

        // 監査ログ作成成功レスポンス
        res.status(201).json({
          success: true, // 成功フラグ
          message: 'Audit log created successfully', // 成功メッセージ
          data: newAuditLog, // 作成された監査ログデータ
          timestamp: new Date().toISOString() // レスポンス時刻
        });
      } catch (error) {
        // エラーが発生した場合の処理
        res.status(400).json({
          success: false, // 失敗フラグ
          error: 'Invalid audit data', // エラータイプ
          message: error.message // エラーメッセージ
        });
      }
      break;

    default:
      // 許可されていないHTTPメソッドの場合
      res.status(405).json({ 
        success: false, // 失敗フラグ
        error: 'Method not allowed' // エラーメッセージ
      });
  }
}
