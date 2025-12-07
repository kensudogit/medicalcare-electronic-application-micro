/**
 * 通知管理API関数
 * 通知の作成、取得、更新、削除を処理
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
    const backendResponse = await proxyToBackend(req, '/api/notifications');
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
      // デモンストレーション用のモック通知データ
      const notifications = [
        {
          id: 1, // 通知ID
          userId: 1, // ユーザーID
          type: 'EMAIL', // 通知タイプ：メール
          title: 'Application Status Update', // 通知タイトル
          message: 'Your medical certificate application has been received and is under review.', // 通知メッセージ
          status: 'SENT', // ステータス：送信済み
          sentAt: '2024-01-20T16:00:00Z', // 送信日時
          readAt: null, // 既読日時：未読
          priority: 'NORMAL', // 優先度：通常
          category: 'APPLICATION_STATUS' // カテゴリ：申請状況
        },
        {
          id: 2, // 通知ID
          userId: 2, // ユーザーID
          type: 'SMS', // 通知タイプ：SMS
          title: 'Document Required', // 通知タイトル
          message: 'Please upload your insurance policy document to complete your application.', // 通知メッセージ
          status: 'SENT', // ステータス：送信済み
          sentAt: '2024-01-20T15:30:00Z', // 送信日時
          readAt: '2024-01-20T15:35:00Z', // 既読日時：既読
          priority: 'HIGH', // 優先度：高
          category: 'DOCUMENT_REQUEST' // カテゴリ：書類要求
        },
        {
          id: 3, // 通知ID
          userId: 1, // ユーザーID
          type: 'PUSH', // 通知タイプ：プッシュ通知
          title: 'Reminder', // 通知タイトル
          message: 'Don\'t forget to complete your medical application by the deadline.', // 通知メッセージ
          status: 'PENDING', // ステータス：保留中
          sentAt: '2024-01-20T17:00:00Z', // 送信日時
          readAt: null, // 既読日時：未読
          priority: 'MEDIUM', // 優先度：中
          category: 'REMINDER' // カテゴリ：リマインダー
        }
      ];

      // 通知一覧をJSON形式で返却（モックデータ）
      res.status(200).json(createSuccessResponse(notifications, 'Notifications retrieved successfully (mock data)'));
      break;

    case 'POST':
      try {
        const notificationData = req.body; // リクエストボディから通知データを取得
        
        // モック通知作成処理
        const newNotification = {
          id: Date.now(), // 現在時刻をIDとして使用
          ...notificationData, // リクエストデータを展開
          status: 'PENDING', // デフォルトステータス：保留中
          sentAt: new Date().toISOString(), // 送信日時
          readAt: null // 既読日時：未読
        };

        // 通知作成成功レスポンス（モックデータ）
        res.status(201).json(createSuccessResponse(newNotification, 'Notification created successfully (mock data)'));
      } catch (error) {
        // エラーが発生した場合の処理
        res.status(400).json(createErrorResponse(400, 'Invalid notification data', error));
      }
      break;

    default:
      // 許可されていないHTTPメソッドの場合
      res.status(405).json(createErrorResponse(405, 'Method not allowed'));
  }
}
