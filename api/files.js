/**
 * ファイル管理API関数
 * ファイル情報の作成、取得、更新、削除を処理
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
      // デモンストレーション用のモックファイルデータ
      const files = [
        {
          id: 1, // ファイルID
          fileName: 'medical_certificate.pdf', // ファイル名
          originalName: 'medical_certificate.pdf', // 元のファイル名
          fileSize: 245760, // ファイルサイズ（バイト）
          mimeType: 'application/pdf', // MIMEタイプ
          uploadDate: '2024-01-20T14:30:00Z', // アップロード日時
          uploadedBy: 1, // アップロード者ID
          uploadedByUsername: 'john.doe', // アップロード者名
          status: 'VERIFIED', // ステータス：検証済み
          tags: ['MEDICAL_DOCUMENT', 'CERTIFICATE'], // タグ
          downloadCount: 5 // ダウンロード回数
        },
        {
          id: 2, // ファイルID
          fileName: 'insurance_policy.jpg', // ファイル名
          originalName: 'insurance_policy.jpg', // 元のファイル名
          fileSize: 1024000, // ファイルサイズ（バイト）
          mimeType: 'image/jpeg', // MIMEタイプ
          uploadDate: '2024-01-20T13:45:00Z', // アップロード日時
          uploadedBy: 2, // アップロード者ID
          uploadedByUsername: 'jane.smith', // アップロード者名
          status: 'PENDING_VERIFICATION', // ステータス：検証待ち
          tags: ['INSURANCE', 'POLICY'], // タグ
          downloadCount: 2 // ダウンロード回数
        }
      ];

      // ファイル一覧をJSON形式で返却
      res.status(200).json({
        success: true, // 成功フラグ
        data: files, // ファイルデータ
        total: files.length, // 総ファイル数
        timestamp: new Date().toISOString() // レスポンス時刻
      });
      break;

    case 'POST':
      try {
        const fileData = req.body; // リクエストボディからファイルデータを取得
        
        // モックファイルアップロード処理
        const newFile = {
          id: Date.now(), // 現在時刻をIDとして使用
          ...fileData, // リクエストデータを展開
          uploadDate: new Date().toISOString(), // アップロード日時
          status: 'PENDING_VERIFICATION', // デフォルトステータス：検証待ち
          downloadCount: 0 // ダウンロード回数：初期値0
        };

        // ファイルアップロード成功レスポンス
        res.status(201).json({
          success: true, // 成功フラグ
          message: 'File uploaded successfully', // 成功メッセージ
          data: newFile, // 作成されたファイルデータ
          timestamp: new Date().toISOString() // レスポンス時刻
        });
      } catch (error) {
        // エラーが発生した場合の処理
        res.status(400).json({
          success: false, // 失敗フラグ
          error: 'Invalid file data', // エラータイプ
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
