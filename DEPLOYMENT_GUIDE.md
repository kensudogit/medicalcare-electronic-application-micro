# 🚀 デプロイメントガイド

このドキュメントでは、Medical Care Electronic ApplicationのFrontend（Vercel）とBackend（Railway）へのデプロイ方法を説明します。

---

## 📋 目次

1. [前提条件](#前提条件)
2. [Frontend（Vercel）デプロイ](#frontendvercelデプロイ)
3. [Backend（Railway）デプロイ](#backendrailwayデプロイ)
4. [環境変数の設定](#環境変数の設定)
5. [デプロイ後の確認](#デプロイ後の確認)
6. [トラブルシューティング](#トラブルシューティング)

---

## 前提条件

### 必要なツール

- **Node.js** 18.0.0以上
- **npm** または **yarn**
- **Git**
- **Vercel CLI**（Frontendデプロイ用）
- **Railway CLI**（Backendデプロイ用、オプション）

### アカウント

- **Vercelアカウント**: [https://vercel.com](https://vercel.com)
- **Railwayアカウント**: [https://railway.app](https://railway.app)

---

## Frontend（Vercel）デプロイ

### 方法1: 自動デプロイスクリプトを使用（推奨）

```bash
# Windows
deploy-frontend-vercel.bat

# Linux/Mac
chmod +x deploy-frontend-vercel.sh
./deploy-frontend-vercel.sh
```

### 方法2: Vercel CLIを使用

```bash
# 1. Vercel CLIをインストール（未インストールの場合）
npm install -g vercel

# 2. Vercelにログイン
vercel login

# 3. 依存関係をインストール
npm install

# 4. 本番環境にデプロイ
vercel --prod
```

### 方法3: Vercel Web UIを使用

1. [Vercel Dashboard](https://vercel.com/dashboard)にアクセス
2. **"Add New..."** → **"Project"** をクリック
3. GitHubリポジトリを選択またはインポート
4. プロジェクト設定：
   - **Framework Preset**: Other
   - **Root Directory**: `/`（プロジェクトルート）
   - **Build Command**: `npm run build`（オプション）
   - **Output Directory**: `public`
5. **"Deploy"** をクリック

### Frontend構成

- **API Routes**: `/api/*.js` - Serverless Functions
- **Static Files**: `/public/*` - 静的ファイル
- **Configuration**: `vercel.json` - Vercel設定

### デプロイ後の確認

```bash
# デプロイURLを確認
vercel ls --prod

# ヘルスチェック
curl https://your-project.vercel.app/api/health
```

---

## Backend（Railway）デプロイ

### 方法1: Railway Web UIを使用（推奨）

#### ステップ1: プロジェクトの作成

1. [Railway Dashboard](https://railway.app)にアクセス
2. **"New Project"** をクリック
3. **"Deploy from GitHub repo"** を選択
4. リポジトリを選択

#### ステップ2: Docker Compose設定

1. プロジェクトダッシュボードで **"Settings"** をクリック
2. **"Build"** セクションに移動
3. 以下の設定を行う：
   - **Build Method**: `Docker Compose`
   - **Docker Compose File**: `docker-compose.yml`
   - **Root Directory**: `/`（プロジェクトルート）

#### ステップ3: 環境変数の設定

**Settings** → **Variables** で以下の環境変数を設定：

```env
# Service Discovery
EUREKA_SERVER_URL=http://service-discovery:8761/eureka/

# Database URLs
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-users:5432/medicalcare_users
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=your-secure-password

# Application Service
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-applications:5432/medicalcare_applications

# Notification Service
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-notifications:5432/medicalcare_notifications

# File Service
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-files:5432/medicalcare_files

# Audit Service
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-audit:5432/medicalcare_audit
```

#### ステップ4: Watch Paths設定

**Settings** → **Watch Paths** で以下を設定：

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

#### ステップ5: デプロイ

1. **"Deploy"** をクリック
2. ビルドログを確認
3. 各サービスのURLを確認

### 方法2: Railway CLIを使用

```bash
# 1. Railway CLIをインストール
npm install -g @railway/cli

# 2. Railwayにログイン
railway login

# 3. プロジェクトを初期化
railway init

# 4. デプロイ（docker-composeを使用）
railway up
```

**注意**: Railway CLIでのdocker-composeデプロイは制限があるため、Web UIの使用を推奨します。

### 方法3: 自動デプロイスクリプトを使用

```bash
# Windows
deploy-backend-railway.bat

# Linux/Mac
chmod +x deploy-backend-railway.sh
./deploy-backend-railway.sh
```

### Backend構成

- **API Gateway**: Port 8080
- **User Service**: Port 8081
- **Application Service**: Port 8082
- **Notification Service**: Port 8083
- **File Service**: Port 8084
- **Audit Service**: Port 8085
- **Service Discovery**: Port 8761

---

## 環境変数の設定

### Vercel環境変数

Vercel Dashboard → **Settings** → **Environment Variables** で設定：

```env
NODE_ENV=production
API_GATEWAY_URL=https://your-railway-api-gateway.railway.app
```

### Railway環境変数

各サービスごとに環境変数を設定：

#### API Gateway
```env
EUREKA_SERVER_URL=http://service-discovery:8761/eureka/
EUREKA_REGISTER=false
EUREKA_FETCH=false
```

#### User Service
```env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-users:5432/medicalcare_users
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=password
EUREKA_SERVICE_URL=http://service-discovery:8761/eureka/
```

#### Application Service
```env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-applications:5432/medicalcare_applications
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=password
EUREKA_SERVICE_URL=http://service-discovery:8761/eureka/
```

#### Notification Service
```env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-notifications:5432/medicalcare_notifications
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=password
EUREKA_SERVICE_URL=http://service-discovery:8761/eureka/
```

#### File Service
```env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-files:5432/medicalcare_files
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=password
EUREKA_SERVICE_URL=http://service-discovery:8761/eureka/
```

#### Audit Service
```env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-audit:5432/medicalcare_audit
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=password
EUREKA_SERVICE_URL=http://service-discovery:8761/eureka/
```

---

## デプロイ後の確認

### Frontend（Vercel）確認

```bash
# ヘルスチェック
curl https://your-project.vercel.app/api/health

# ユーザーAPI
curl https://your-project.vercel.app/api/users

# 申請API
curl https://your-project.vercel.app/api/applications
```

### Backend（Railway）確認

```bash
# Service Discovery
curl https://your-service-discovery.railway.app/actuator/health

# API Gateway
curl https://your-api-gateway.railway.app/health

# User Service
curl https://your-user-service.railway.app/actuator/health

# Application Service
curl https://your-application-service.railway.app/actuator/health
```

---

## トラブルシューティング

### Vercelデプロイの問題

#### 問題1: 関数がタイムアウトする

**解決策**:
- `vercel.json`で`maxDuration`を調整
- 処理を軽量化する
- 非同期処理を最適化する

#### 問題2: CORSエラー

**解決策**:
- `api/*.js`ファイルでCORSヘッダーを確認
- プリフライトリクエスト（OPTIONS）の処理を確認

#### 問題3: デプロイエラー

**解決策**:
```bash
# ビルドログを確認
vercel logs

# ローカルでテスト
vercel dev
```

### Railwayデプロイの問題

#### 問題1: Dockerfileが見つからない

**解決策**:
- Railway Settings → Build → Build Method を **"Docker Compose"** に設定
- `docker-compose.yml`がプロジェクトルートにあることを確認

#### 問題2: サービスが起動しない

**解決策**:
- 環境変数が正しく設定されているか確認
- ビルドログを確認
- 各サービスのヘルスチェックを確認

#### 問題3: データベース接続エラー

**解決策**:
- PostgreSQLサービスのURLを確認
- 環境変数の`SPRING_DATASOURCE_URL`を確認
- データベースの起動を待つ（依存関係の設定を確認）

#### 問題4: ポート競合

**解決策**:
- Railwayは自動的にポートを割り当てます
- 環境変数`PORT`を使用してポートを動的に取得

---

## デプロイフロー図

```
┌─────────────────┐
│   GitHub Repo   │
└────────┬────────┘
         │
         ├─────────────────┬─────────────────┐
         │                 │                 │
         ▼                 ▼                 ▼
    ┌─────────┐      ┌──────────┐     ┌──────────┐
    │ Vercel  │      │ Railway  │     │  Local   │
    │(Frontend)│     │(Backend) │     │  Dev     │
    └─────────┘      └──────────┘     └──────────┘
         │                 │
         ▼                 ▼
    ┌─────────┐      ┌──────────┐
    │  API    │◄─────┤ Services │
    │ Routes  │      │ (Docker) │
    └─────────┘      └──────────┘
```

---

## 次のステップ

1. **カスタムドメインの設定**
   - Vercel: Settings → Domains
   - Railway: Settings → Domains

2. **CI/CDの設定**
   - GitHub Actions
   - 自動デプロイの設定

3. **監視とログ**
   - Vercel Analytics
   - Railway Metrics
   - エラートラッキング

4. **セキュリティ**
   - 環境変数の暗号化
   - API認証の実装
   - CORS設定の最適化

---

## 参考リンク

- [Vercel Documentation](https://vercel.com/docs)
- [Railway Documentation](https://docs.railway.app)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)

---

**🎉 デプロイ完了！**

Frontend（Vercel）とBackend（Railway）へのデプロイが完了しました。問題が発生した場合は、トラブルシューティングセクションを参照してください。

