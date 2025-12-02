/**
 * ユーザー管理API関数
 * ユーザーの作成、取得、更新、削除を処理
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
      // デモンストレーション用のモックユーザーデータ
      const users = [
        {
          id: 1, // ユーザーID
          username: 'john.doe', // ユーザー名
          email: 'john.doe@example.com', // メールアドレス
          firstName: 'John', // 名
          lastName: 'Doe', // 姓
          role: 'PATIENT', // 役割：患者
          status: 'ACTIVE', // ステータス：アクティブ
          createdAt: '2024-01-15T10:00:00Z', // 作成日時
          phoneNumber: '+1-555-0123', // 電話番号
          dateOfBirth: '1985-03-15', // 生年月日
          address: '123 Main St, City, State 12345' // 住所
        },
        {
          id: 2, // ユーザーID
          username: 'jane.smith', // ユーザー名
          email: 'jane.smith@example.com', // メールアドレス
          firstName: 'Jane', // 名
          lastName: 'Smith', // 姓
          role: 'DOCTOR', // 役割：医師
          status: 'ACTIVE', // ステータス：アクティブ
          createdAt: '2024-01-10T09:00:00Z', // 作成日時
          phoneNumber: '+1-555-0456', // 電話番号
          specialization: 'Cardiology', // 専門分野：心臓病学
          licenseNumber: 'MD-12345' // 医師免許番号
        },
        {
          id: 3, // ユーザーID
          username: 'admin.user', // ユーザー名
          email: 'admin@medicalcare.com', // メールアドレス
          firstName: 'Admin', // 名
          lastName: 'User', // 姓
          role: 'ADMIN', // 役割：管理者
          status: 'ACTIVE', // ステータス：アクティブ
          createdAt: '2024-01-01T08:00:00Z', // 作成日時
          phoneNumber: '+1-555-0789', // 電話番号
          department: 'System Administration' // 部署：システム管理
        }
      ];

      // ユーザー一覧をJSON形式で返却
      res.status(200).json({
        success: true, // 成功フラグ
        data: users, // ユーザーデータ
        total: users.length, // 総ユーザー数
        timestamp: new Date().toISOString() // レスポンス時刻
      });
      break;

    case 'POST':
      try {
        const userData = req.body; // リクエストボディからユーザーデータを取得
        
        // モックユーザー作成処理
        const newUser = {
          id: Date.now(), // 現在時刻をIDとして使用
          ...userData, // リクエストデータを展開
          status: 'ACTIVE', // デフォルトステータス：アクティブ
          createdAt: new Date().toISOString() // 作成日時
        };

        // ユーザー作成成功レスポンス
        res.status(201).json({
          success: true, // 成功フラグ
          message: 'User created successfully', // 成功メッセージ
          data: newUser, // 作成されたユーザーデータ
          timestamp: new Date().toISOString() // レスポンス時刻
        });
      } catch (error) {
        // エラーが発生した場合の処理
        res.status(400).json({
          success: false, // 失敗フラグ
          error: 'Invalid user data', // エラータイプ
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
