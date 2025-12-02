/**
 * 医療申請管理API関数
 * 医療申請の作成、取得、更新、削除を処理
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
      // デモンストレーション用のモック申請データ
      const applications = [
        {
          id: 1, // 申請ID
          patientId: 1, // 患者ID
          patientName: 'John Doe', // 患者名
          applicationType: 'MEDICAL_CERTIFICATE', // 申請タイプ：医療証明書
          status: 'PENDING', // ステータス：審査中
          submittedAt: '2024-01-20T14:30:00Z', // 提出日時
          requiredDocuments: ['ID_CARD', 'MEDICAL_RECORD'], // 必要書類
          priority: 'NORMAL', // 優先度：通常
          category: 'HEALTH_CERTIFICATE', // カテゴリ：健康証明書
          estimatedProcessingTime: '3-5 business days', // 推定処理時間
          assignedTo: null // 担当者：未割り当て
        },
        {
          id: 2, // 申請ID
          patientId: 2, // 患者ID
          patientName: 'Jane Smith', // 患者名
          applicationType: 'INSURANCE_CLAIM', // 申請タイプ：保険請求
          status: 'APPROVED', // ステータス：承認済み
          submittedAt: '2024-01-18T10:15:00Z', // 提出日時
          approvedAt: '2024-01-19T16:45:00Z', // 承認日時
          requiredDocuments: ['ID_CARD', 'INSURANCE_POLICY'], // 必要書類
          priority: 'HIGH', // 優先度：高
          category: 'INSURANCE', // カテゴリ：保険
          estimatedProcessingTime: '1-2 business days', // 推定処理時間
          assignedTo: 'Dr. Johnson' // 担当者：ジョンソン医師
        },
        {
          id: 3, // 申請ID
          patientId: 1, // 患者ID
          patientName: 'John Doe', // 患者名
          applicationType: 'MEDICAL_APPOINTMENT', // 申請タイプ：医療予約
          status: 'SCHEDULED', // ステータス：予約済み
          submittedAt: '2024-01-19T09:00:00Z', // 提出日時
          scheduledAt: '2024-01-25T14:00:00Z', // 予約日時
          requiredDocuments: ['ID_CARD'], // 必要書類
          priority: 'MEDIUM', // 優先度：中
          category: 'APPOINTMENT', // カテゴリ：予約
          estimatedProcessingTime: 'Immediate', // 推定処理時間：即座
          assignedTo: 'Dr. Williams' // 担当者：ウィリアムズ医師
        }
      ];

      // 申請一覧をJSON形式で返却
      res.status(200).json({
        success: true, // 成功フラグ
        data: applications, // 申請データ
        total: applications.length, // 総申請数
        timestamp: new Date().toISOString() // レスポンス時刻
      });
      break;

    case 'POST':
      try {
        const applicationData = req.body; // リクエストボディから申請データを取得
        
        // モック申請作成処理
        const newApplication = {
          id: Date.now(), // 現在時刻をIDとして使用
          ...applicationData, // リクエストデータを展開
          status: 'PENDING', // デフォルトステータス：審査中
          submittedAt: new Date().toISOString() // 提出日時
        };

        // 申請作成成功レスポンス
        res.status(201).json({
          success: true, // 成功フラグ
          message: 'Application submitted successfully', // 成功メッセージ
          data: newApplication, // 作成された申請データ
          timestamp: new Date().toISOString() // レスポンス時刻
        });
      } catch (error) {
        // エラーが発生した場合の処理
        res.status(400).json({
          success: false, // 失敗フラグ
          error: 'Invalid application data', // エラータイプ
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
