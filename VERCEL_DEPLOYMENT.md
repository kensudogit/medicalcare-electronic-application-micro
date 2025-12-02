# 🚀 Vercel デプロイ完了 - Medical Care Microservices

## 🎉 **デプロイ状況: 完了**

このドキュメントでは、VercelにデプロイされたMedical Care Microservicesの使用方法とAPIエンドポイントについて説明します。

---

## 🌐 **デプロイされたサービス**

### **API エンドポイント一覧**

| エンドポイント | メソッド | 説明 | ステータス |
|----------------|----------|------|------------|
| `/api/health` | GET | システムヘルスチェック | ✅ 稼働中 |
| `/api/users` | GET, POST | ユーザー管理 | ✅ 稼働中 |
| `/api/applications` | GET, POST | 医療申請管理 | ✅ 稼働中 |
| `/api/notifications` | GET, POST | 通知管理 | ✅ 稼働中 |
| `/api/files` | GET, POST | ファイル管理 | ✅ 稼働中 |
| `/api/audit` | GET, POST | 監査ログ | ✅ 稼働中 |
| `/health` | GET | ヘルスチェック（短縮版） | ✅ 稼働中 |
| `/` | GET | ルートエンドポイント | ✅ 稼働中 |

---

## 🔧 **API 使用方法**

### **1. ヘルスチェック**

```bash
# システム全体のヘルスチェック
curl https://your-project.vercel.app/api/health

# 短縮版ヘルスチェック
curl https://your-project.vercel.app/health
```

**レスポンス例:**
```json
{
  "status": "UP",
  "timestamp": "2024-01-20T15:30:00Z",
  "service": "Medical Care API Gateway",
  "version": "1.0.0",
  "environment": "production",
  "services": {
    "user-service": "UP",
    "application-service": "UP",
    "notification-service": "UP",
    "file-service": "UP",
    "audit-service": "UP"
  }
}
```

### **2. ユーザー管理**

```bash
# ユーザー一覧取得
curl https://your-project.vercel.app/api/users

# 新規ユーザー作成
curl -X POST https://your-project.vercel.app/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newuser",
    "email": "newuser@example.com",
    "firstName": "New",
    "lastName": "User",
    "role": "PATIENT"
  }'
```

### **3. 医療申請管理**

```bash
# 申請一覧取得
curl https://your-project.vercel.app/api/applications

# 新規申請作成
curl -X POST https://your-project.vercel.app/api/applications \
  -H "Content-Type: application/json" \
  -d '{
    "patientId": 1,
    "applicationType": "MEDICAL_CERTIFICATE",
    "requiredDocuments": ["ID_CARD", "MEDICAL_RECORD"],
    "priority": "NORMAL"
  }'
```

### **4. 通知管理**

```bash
# 通知一覧取得
curl https://your-project.vercel.app/api/notifications

# 新規通知作成
curl -X POST https://your-project.vercel.app/api/notifications \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "type": "EMAIL",
    "title": "Application Update",
    "message": "Your application has been processed.",
    "priority": "NORMAL"
  }'
```

### **5. ファイル管理**

```bash
# ファイル一覧取得
curl https://your-project.vercel.app/api/files

# 新規ファイル登録
curl -X POST https://your-project.vercel.app/api/files \
  -H "Content-Type: application/json" \
  -d '{
    "fileName": "document.pdf",
    "originalName": "document.pdf",
    "fileSize": 1024000,
    "mimeType": "application/pdf",
    "uploadedBy": 1,
    "tags": ["DOCUMENT"]
  }'
```

### **6. 監査ログ**

```bash
# 監査ログ一覧取得
curl https://your-project.vercel.app/api/audit

# 新規監査ログ作成
curl -X POST https://your-project.vercel.app/api/audit \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "action": "USER_LOGIN",
    "resource": "AUTHENTICATION",
    "details": "User logged in successfully"
  }'
```

---

## 🧪 **テスト用のサンプルデータ**

### **ユーザーデータ**
```json
{
  "id": 1,
  "username": "john.doe",
  "email": "john.doe@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "role": "PATIENT",
  "status": "ACTIVE"
}
```

### **申請データ**
```json
{
  "id": 1,
  "patientId": 1,
  "patientName": "John Doe",
  "applicationType": "MEDICAL_CERTIFICATE",
  "status": "PENDING",
  "priority": "NORMAL"
}
```

### **通知データ**
```json
{
  "id": 1,
  "userId": 1,
  "type": "EMAIL",
  "title": "Application Status Update",
  "message": "Your application has been received.",
  "status": "SENT"
}
```

---

## 🔍 **エラーハンドリング**

### **HTTP ステータスコード**

| コード | 説明 |
|--------|------|
| 200 | 成功 |
| 201 | 作成成功 |
| 400 | リクエストエラー |
| 405 | メソッド不許可 |
| 500 | サーバーエラー |

### **エラーレスポンス例**

```json
{
  "success": false,
  "error": "Invalid user data",
  "message": "Username is required"
}
```

---

## 🚀 **ローカル開発**

### **1. 依存関係のインストール**

```bash
npm install
```

### **2. ローカル開発サーバーの起動**

```bash
npm run dev
# または
vercel dev
```

### **3. ローカルテスト**

```bash
# ヘルスチェック
curl http://localhost:3000/api/health

# ユーザー一覧
curl http://localhost:3000/api/users
```

---

## 📊 **パフォーマンスと制限**

### **Vercel 制限事項**
- **関数実行時間**: 最大30秒
- **ペイロードサイズ**: 最大4.5MB
- **同時実行数**: プランによる制限

### **最適化のヒント**
- 軽量なレスポンスを返す
- 不要なデータ処理を避ける
- キャッシュを活用する

---

## 🔒 **セキュリティ**

### **CORS設定**
- すべてのオリジンからのアクセスを許可
- 本番環境では適切なオリジンを制限することを推奨

### **認証・認可**
- 現在はモックデータを使用
- 本番環境では適切な認証システムを実装することを推奨

---

## 📈 **監視とログ**

### **Vercel ダッシュボード**
- 関数の実行状況
- エラーログ
- パフォーマンスメトリクス

### **ログの確認方法**
```bash
# デプロイログ
vercel logs

# 特定の関数のログ
vercel logs --function=api/health
```

---

## 🛠️ **トラブルシューティング**

### **よくある問題**

#### **1. 関数がタイムアウトする**
- 処理を軽量化する
- 非同期処理を最適化する

#### **2. CORSエラー**
- ヘッダーの設定を確認
- プリフライトリクエストの処理を確認

#### **3. デプロイエラー**
- ビルドログを確認
- 依存関係を確認

### **デバッグ方法**
```bash
# ローカルでテスト
vercel dev

# ログを確認
vercel logs

# 環境変数を確認
vercel env ls
```

---

## 🔄 **更新と再デプロイ**

### **コード更新後の再デプロイ**

```bash
# 本番環境にデプロイ
vercel --prod

# プレビューデプロイ
vercel
```

### **環境変数の更新**

```bash
# 環境変数を設定
vercel env add VARIABLE_NAME

# 環境変数を確認
vercel env ls
```

---

## 📚 **次のステップ**

### **推奨される拡張機能**

1. **データベース統合**
   - MongoDB Atlas
   - PlanetScale
   - Supabase

2. **認証システム**
   - Auth0
   - NextAuth.js
   - Clerk

3. **ファイルストレージ**
   - AWS S3
   - Cloudinary
   - Upload.io

4. **監視とアラート**
   - Sentry
   - LogRocket
   - DataDog

---

## 🎯 **まとめ**

✅ **Vercelデプロイ完了**
✅ **全APIエンドポイント稼働中**
✅ **ヘルスチェック機能**
✅ **CORS対応**
✅ **エラーハンドリング**
✅ **モックデータ提供**

---

**🚀 おめでとうございます！Medical Care MicroservicesがVercelに正常にデプロイされました！**

すべてのAPIエンドポイントが利用可能で、本格的な開発とテストを開始できます。
