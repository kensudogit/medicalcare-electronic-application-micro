/**
 * ファイル管理API関数
 * ファイル情報の作成、取得、更新、削除を処理
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
    const backendResponse = await proxyToBackend(req, '/api/files');
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

      // ファイル一覧をJSON形式で返却（モックデータ）
      res.status(200).json(createSuccessResponse(files, 'Files retrieved successfully (mock data)'));
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

        // ファイルアップロード成功レスポンス（モックデータ）
        res.status(201).json(createSuccessResponse(newFile, 'File uploaded successfully (mock data)'));
      } catch (error) {
        // エラーが発生した場合の処理
        res.status(400).json(createErrorResponse(400, 'Invalid file data', error));
      }
      break;

    default:
      // 許可されていないHTTPメソッドの場合
      res.status(405).json(createErrorResponse(405, 'Method not allowed'));
  }
}
