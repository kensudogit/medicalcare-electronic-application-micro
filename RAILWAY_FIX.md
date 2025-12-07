# Railway デプロイエラー修正ガイド

## 問題

Railwayで以下のエラーが発生していました：

```
Error: No existing credentials found. Please run `vercel login` or pass "--token"
```

## 原因

Railwayが`npm start`を実行しようとし、`package.json`の`start`スクリプトが`vercel dev`になっていたため、Vercel CLIの認証エラーが発生していました。

## 解決策

### 1. package.jsonの修正

`start`スクリプトを修正して、Railway環境では何もしないようにしました：

```json
"start": "echo 'This project uses Docker Compose for backend services. Use docker-compose up -d to start services.' && exit 0"
```

### 2. Railway設定の確認

Railwayでは、**Docker Compose**を使用してバックエンドサービスをデプロイするため、`npm start`は使用されません。

#### Railway Web UIでの設定

1. Railway Dashboard → プロジェクト → **Settings**
2. **Build**セクション：
   - **Build Method**: `Docker Compose`
   - **Docker Compose File**: `docker-compose.yml`
   - **Root Directory**: `/`（プロジェクトルート）

3. **Deploy**セクション：
   - **Start Command**: 空（docker-composeが自動的に使用される）
   - または `docker-compose up -d`

### 3. 環境変数の設定

Railway Dashboard → **Variables**で環境変数を設定：

```env
# 各サービス用のデータベースURL
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=postgres

# Eureka設定
EUREKA_SERVER_URL=http://service-discovery:8761/eureka/
```

### 4. Watch Paths設定

**Settings** → **Watch Paths**で以下を設定：

```
/api-gateway/**
/application-service/**
/user-service/**
/notification-service/**
/file-service/**
/audit-service/**
/service-discovery/**
/docker-compose.yml
/infrastructure/**
```

---

## デプロイ手順

### 方法1: Railway Web UI（推奨）

1. [Railway Dashboard](https://railway.app)にアクセス
2. **New Project** → **Deploy from GitHub repo**
3. リポジトリを選択
4. **Settings** → **Build**:
   - **Build Method**: `Docker Compose`
   - **Docker Compose File**: `docker-compose.yml`
5. **Settings** → **Variables**で環境変数を設定
6. **Deploy**をクリック

### 方法2: Railway CLI

```bash
# Railway CLIをインストール
npm install -g @railway/cli

# ログイン
railway login

# プロジェクトを初期化
railway init

# デプロイ（docker-composeを使用）
railway up
```

---

## 確認事項

### 1. Docker Composeが正しく設定されているか

```bash
# ローカルでテスト
docker-compose config
```

### 2. 各サービスのDockerfileが存在するか

- `api-gateway/Dockerfile`
- `application-service/Dockerfile`
- `user-service/Dockerfile`
- `notification-service/Dockerfile`
- `file-service/Dockerfile`
- `audit-service/Dockerfile`
- `service-discovery/Dockerfile`

### 3. ビルドログの確認

Railway Dashboard → **Deployments** → **Build Logs**で：
- ビルドが成功しているか
- エラーメッセージがないか

---

## トラブルシューティング

### 問題1: npm startが実行される

**症状**: Railwayが`npm start`を実行しようとする

**解決策**:
1. Railway Settings → **Build** → **Build Method**を`Docker Compose`に設定
2. **Start Command**を空にする、または`docker-compose up -d`に設定

### 問題2: Vercel CLIエラー

**症状**: `Error: No existing credentials found`

**解決策**:
- RailwayではVercel CLIは不要です
- `package.json`の`start`スクリプトは既に修正済み
- RailwayはDocker Composeを使用します

### 問題3: サービスが起動しない

**症状**: コンテナが起動しない

**解決策**:
1. Railway Dashboard → **Logs**でエラーログを確認
2. 環境変数が正しく設定されているか確認
3. データベースサービスが起動しているか確認

---

## まとめ

✅ **package.jsonの`start`スクリプトを修正**
✅ **RailwayはDocker Composeを使用**
✅ **Vercel CLIは不要（FrontendはVercelで別途デプロイ）**

Railwayでは、Docker Composeを使用してバックエンドサービスをデプロイするため、`npm start`は使用されません。Railwayの設定で**Build Method**を`Docker Compose`に設定することで、この問題は解決されます。

---

## 参考リンク

- [Railway Docker Compose Documentation](https://docs.railway.app/deploy/docker-compose)
- [Railway Build Settings](https://docs.railway.app/deploy/builds)

