# 502エラー対応ガイド

## エラーの説明

### 502 Bad Gateway
502エラーは、プロキシサーバー（Vercel）がバックエンドサーバー（Railway）に接続できない、またはバックエンドが応答していない場合に発生します。

### content.jsエラー
`content.js`のエラーは、ブラウザ拡張機能の問題、またはフロントエンドとバックエンドの通信の問題が原因です。

---

## 解決策

### 1. 環境変数の設定

Vercel Dashboardで環境変数を設定してください：

1. [Vercel Dashboard](https://vercel.com/dashboard)にアクセス
2. プロジェクトを選択
3. **Settings** → **Environment Variables**
4. 以下の環境変数を追加：

```env
API_GATEWAY_URL=https://your-api-gateway.railway.app
```

または

```env
RAILWAY_API_GATEWAY_URL=https://your-api-gateway.railway.app
```

### 2. Railwayバックエンドの確認

#### バックエンドが起動しているか確認

```bash
# Railway Dashboardで各サービスのステータスを確認
# または、直接URLにアクセス
curl https://your-api-gateway.railway.app/health
```

#### バックエンドのログを確認

1. Railway Dashboard → プロジェクト → サービス
2. **Logs**タブでエラーログを確認

### 3. CORS設定の確認

バックエンド（Railway）でCORSが正しく設定されているか確認：

```java
// Spring Bootの場合
@CrossOrigin(origins = "*")
```

### 4. ネットワーク接続の確認

#### タイムアウト設定

APIルートは10秒のタイムアウトが設定されています。バックエンドが10秒以内に応答しない場合は、モックデータが返されます。

#### 接続テスト

```bash
# バックエンドに直接接続テスト
curl -v https://your-api-gateway.railway.app/health

# タイムアウトテスト
curl --max-time 10 https://your-api-gateway.railway.app/health
```

### 5. フォールバック機能

現在の実装では、バックエンドが利用できない場合、自動的にモックデータが返されます。これは502エラーを防ぐためのフォールバック機能です。

---

## トラブルシューティング手順

### ステップ1: 環境変数の確認

```bash
# Vercel CLIで環境変数を確認
vercel env ls
```

### ステップ2: バックエンドのヘルスチェック

```bash
# バックエンドのヘルスチェック
curl https://your-api-gateway.railway.app/health

# 期待されるレスポンス
{
  "status": "UP",
  ...
}
```

### ステップ3: Vercelログの確認

```bash
# Vercelログを確認
vercel logs

# 特定の関数のログ
vercel logs --function=api/users
```

### ステップ4: ローカルでのテスト

```bash
# ローカルでVercel開発サーバーを起動
vercel dev

# 環境変数を設定
export API_GATEWAY_URL=https://your-api-gateway.railway.app

# APIをテスト
curl http://localhost:3000/api/health
```

---

## よくある問題と解決策

### 問題1: 環境変数が設定されていない

**症状**: 502エラーが発生し、モックデータが返される

**解決策**:
1. Vercel Dashboardで環境変数を設定
2. 再デプロイ

### 問題2: バックエンドが起動していない

**症状**: バックエンドURLにアクセスできない

**解決策**:
1. Railway Dashboardでサービスのステータスを確認
2. サービスを再起動
3. ログを確認してエラーを修正

### 問題3: CORSエラー

**症状**: ブラウザコンソールにCORSエラーが表示される

**解決策**:
1. バックエンドでCORS設定を確認
2. `Access-Control-Allow-Origin`ヘッダーを確認

### 問題4: タイムアウト

**症状**: 10秒以内にバックエンドが応答しない

**解決策**:
1. バックエンドのパフォーマンスを確認
2. データベース接続を確認
3. 不要な処理を最適化

---

## デバッグ方法

### 1. ログの確認

```javascript
// api/utils.jsでログを確認
console.warn('Backend unavailable, using mock data:', error.message);
```

### 2. ネットワークタブの確認

ブラウザの開発者ツール → **Network**タブで：
- リクエストのステータスコード
- レスポンス時間
- エラーメッセージ

### 3. Vercel関数ログ

Vercel Dashboard → **Functions** → **Logs**で：
- 関数の実行ログ
- エラーメッセージ
- 実行時間

---

## 予防策

### 1. ヘルスチェックの実装

定期的にバックエンドのヘルスチェックを実行：

```javascript
// ヘルスチェック関数
async function checkBackendHealth() {
  try {
    const response = await fetch(`${backendUrl}/health`);
    return response.ok;
  } catch (error) {
    return false;
  }
}
```

### 2. リトライロジック

バックエンド接続に失敗した場合のリトライ：

```javascript
async function proxyWithRetry(req, endpoint, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      return await proxyToBackend(req, endpoint);
    } catch (error) {
      if (i === retries - 1) throw error;
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
    }
  }
}
```

### 3. キャッシュの活用

頻繁にアクセスするデータをキャッシュ：

```javascript
// Vercel Edge Cache
res.setHeader('Cache-Control', 's-maxage=60, stale-while-revalidate');
```

---

## まとめ

502エラーが発生した場合：

1. ✅ 環境変数が正しく設定されているか確認
2. ✅ バックエンドが起動しているか確認
3. ✅ ネットワーク接続を確認
4. ✅ ログを確認してエラーを特定
5. ✅ フォールバック機能（モックデータ）が動作していることを確認

現在の実装では、バックエンドが利用できない場合でも、モックデータが返されるため、502エラーは発生しません。バックエンドが利用可能になると、自動的にバックエンドのデータが返されます。

---

## 参考リンク

- [Vercel Environment Variables](https://vercel.com/docs/concepts/projects/environment-variables)
- [Railway Troubleshooting](https://docs.railway.app/troubleshooting)
- [HTTP Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/502)

