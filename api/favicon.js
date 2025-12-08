/**
 * Favicon API関数
 * favicon.icoリクエストを処理
 * 502エラーを防ぐため、空のレスポンスを返す
 */
export default function handler(req, res) {
  // favicon.icoリクエストの場合、204 No Contentを返す
  // これにより、ブラウザがfaviconを探し続けるのを防ぐ
  res.status(204).end();
}

