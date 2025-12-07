# 🚀 クイックデプロイガイド

このガイドでは、Medical Care Electronic Applicationを素早くデプロイする方法を説明します。

---

## ⚡ 5分でデプロイ

### Frontend（Vercel）デプロイ

```bash
# Windows
deploy-frontend-vercel.bat

# Linux/Mac
chmod +x deploy-frontend-vercel.sh
./deploy-frontend-vercel.sh
```

**または手動で:**

```bash
# 1. Vercel CLIをインストール
npm install -g vercel

# 2. ログイン
vercel login

# 3. デプロイ
vercel --prod
```

---

### Backend（Railway）デプロイ

#### ステップ1: Railwayプロジェクトを作成

1. [Railway Dashboard](https://railway.app)にアクセス
2. **"New Project"** → **"Deploy from GitHub repo"**
3. リポジトリを選択

#### ステップ2: Docker Compose設定

1. **Settings** → **Build**
2. **Build Method**: `Docker Compose`
3. **Docker Compose File**: `docker-compose.yml`

#### ステップ3: 環境変数を設定

**Settings** → **Variables** で以下を追加：

```env
# 各サービス用のデータベースURL（Railwayが自動生成するPostgreSQLを使用）
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=postgres
```

#### ステップ4: デプロイ

**"Deploy"** ボタンをクリック

---

## 📝 詳細な手順

詳細な手順については、[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)を参照してください。

---

## 🔗 デプロイ後のURL確認

### Vercel
```bash
vercel ls --prod
```

### Railway
Railway Dashboard → 各サービスの **"Settings"** → **"Networking"** でURLを確認

---

## ✅ デプロイ確認

### Frontend
```bash
curl https://your-project.vercel.app/api/health
```

### Backend
```bash
curl https://your-api-gateway.railway.app/health
```

---

**🎉 デプロイ完了！**

