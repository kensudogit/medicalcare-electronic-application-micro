# Medical Care Electronic Application - Microservices Architecture

## 概要

このプロジェクトは、医療電子申請システムをマイクロサービスアーキテクチャに分割したものです。

## アーキテクチャ

### サービス構成

1. **Service Discovery (Eureka Server)**
   - ポート: 8761
   - 役割: サービス登録・発見

2. **API Gateway**
   - ポート: 8080
   - 役割: ルーティング、認証、レート制限

3. **User Service**
   - ポート: 8081
   - 役割: ユーザー管理、認証

4. **Application Service**
   - ポート: 8082
   - 役割: 申請書管理

5. **Notification Service**
   - ポート: 8083
   - 役割: 通知管理


### インフラストラクチャ

- **PostgreSQL**: データベース (ポート: 5433, 5434, 5435, 5436)
- **Redis**: キャッシュ (ポート: 6380)
- **Nginx**: ロードバランサー (ポート: 80)

## 起動方法

### 前提条件

- **Java SE 21 LTS** (必須)
  - ダウンロード: https://adoptium.net/temurin/releases/?version=21
  - 確認方法: `java -version` で Java 21 が表示されることを確認
  - 確認スクリプト: `check-java-21.bat` を実行
- **Docker Desktop** (必須)
  - ダウンロード: https://www.docker.com/products/docker-desktop
  - Docker Desktop が起動していることを確認
  - 確認スクリプト: `check-docker-and-java.bat` を実行
- **Docker Compose** (Docker Desktop に含まれています)

### 環境チェック

起動前に環境を確認することを推奨します:

```bash
# Windows
check-docker-and-java.bat

# Java 21 のみ確認
check-java-21.bat
```

これらのスクリプトは以下を確認します:
- Java SE 21 LTS のインストール
- Docker Desktop の起動状態
- すべてのサービスの Java 21 設定

### クイックスタート

```bash
# プロジェクトディレクトリに移動
cd medicalcare-electronic-application-micro

# 環境チェック（推奨）
check-docker-and-java.bat

# サービスを起動（Windows）
start-all-services.bat

# または直接起動
docker-compose up -d --build

# ログを確認
docker-compose logs -f
```

**注意**: Docker Desktop が起動していない場合、`start-all-services.bat` が自動的に起動を試みます。

### 個別サービス起動

```bash
# Service Discovery のみ起動
docker-compose up -d service-discovery

# API Gateway を起動
docker-compose up -d api-gateway

# User Service を起動
docker-compose up -d user-service
```

## アクセス

- **Service Discovery**: http://localhost:8761
- **API Gateway**: http://localhost:8080
- **User Service**: http://localhost:8081
- **Application Service**: http://localhost:8082
- **Notification Service**: http://localhost:8083
- **File Service**: http://localhost:8084
- **Nginx**: http://localhost

## API エンドポイント

### User Service
- `GET /api/users` - ユーザー一覧
- `POST /api/users` - ユーザー作成
- `GET /api/users/{id}` - ユーザー詳細
- `PUT /api/users/{id}` - ユーザー更新
- `DELETE /api/users/{id}` - ユーザー削除

### Application Service
- `GET /api/applications` - 申請書一覧
- `POST /api/applications` - 申請書作成
- `GET /api/applications/{id}` - 申請書詳細
- `PUT /api/applications/{id}` - 申請書更新
- `DELETE /api/applications/{id}` - 申請書削除

### Notification Service
- `GET /api/notifications` - 通知一覧
- `POST /api/notifications` - 通知作成
- `GET /api/notifications/{id}` - 通知詳細
- `PUT /api/notifications/{id}` - 通知更新
- `DELETE /api/notifications/{id}` - 通知削除

### File Service
- `GET /api/files` - ファイル一覧
- `POST /api/files` - ファイルアップロード
- `GET /api/files/{id}` - ファイルダウンロード
- `DELETE /api/files/{id}` - ファイル削除

## 開発

### 技術スタック

- **Java**: Java SE 21 LTS (Eclipse Temurin)
- **Spring Boot**: 3.2.0
- **Kotlin**: 1.9.20
- **Gradle**: 8.5
- **Docker**: 最新版（Java 21 LTS ベースイメージ使用）

### ローカル開発環境

```bash
# データベースのみ起動
docker-compose up -d postgres-users postgres-applications redis

# 各サービスを個別に起動（Java 21 が必要）
cd api-gateway
./gradlew bootRun
```

**重要**: ローカル開発でも Java SE 21 LTS が必要です。すべてのサービスは Java 21 でビルド・実行されます。

### テスト

```bash
# 全テスト実行
./gradlew test

# 特定サービスのテスト
cd user-service && ./gradlew test
```

## 監視

### ヘルスチェック

各サービスは `/actuator/health` エンドポイントでヘルスチェックを提供しています。

### ログ

```bash
# 全サービスのログ
docker-compose logs -f

# 特定サービスのログ
docker-compose logs -f user-service
```

## デプロイ

### Frontend（Vercel）デプロイ

FrontendはVercelのServerless Functionsとしてデプロイされます。

#### クイックデプロイ

```bash
# Windows
deploy-frontend-vercel.bat

# Linux/Mac
chmod +x deploy-frontend-vercel.sh
./deploy-frontend-vercel.sh
```

#### 手動デプロイ

```bash
# Vercel CLIをインストール
npm install -g vercel

# ログイン
vercel login

# 本番環境にデプロイ
vercel --prod
```

詳細は [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) を参照してください。

### Backend（Railway）デプロイ

BackendはRailwayでDocker Composeを使用してデプロイされます。

#### Railway Web UIを使用（推奨）

1. [Railway Dashboard](https://railway.app)でプロジェクトを作成
2. GitHubリポジトリを接続
3. **Settings** → **Build**:
   - **Build Method**: `Docker Compose`
   - **Docker Compose File**: `docker-compose.yml`
4. **Settings** → **Variables** で環境変数を設定
5. **Deploy** をクリック

#### 自動デプロイスクリプト

```bash
# Windows
deploy-backend-railway.bat

# Linux/Mac
chmod +x deploy-backend-railway.sh
./deploy-backend-railway.sh
```

詳細は [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) または [QUICK_DEPLOY.md](./QUICK_DEPLOY.md) を参照してください。

## トラブルシューティング

### よくある問題

1. **Docker Desktop が起動していない**
   ```bash
   # エラー: "The system cannot find the file specified"
   # 解決方法:
   # 1. Docker Desktop を起動
   # 2. 完全に起動するまで待つ
   # 3. check-docker-and-java.bat で確認
   ```

2. **Java 21 がインストールされていない**
   ```bash
   # エラー: "Java is not installed"
   # 解決方法:
   # 1. Java SE 21 LTS をインストール
   #    https://adoptium.net/temurin/releases/?version=21
   # 2. JAVA_HOME 環境変数を設定
   # 3. check-java-21.bat で確認
   ```

3. **ポート競合**
   ```bash
   # 使用中のポートを確認
   netstat -tulpn | grep :8080
   
   # Docker Compose を停止
   docker-compose down
   ```

2. **データベース接続エラー**
   ```bash
   # データベースコンテナの状態確認
   docker-compose ps postgres-users
   
   # データベースログ確認
   docker-compose logs postgres-users
   ```

3. **サービス登録エラー**
   ```bash
   # Service Discovery の状態確認
   curl http://localhost:8761/eureka/apps
   ```

4. **デプロイエラー**
   - Vercel: `vercel logs` でログを確認
   - Railway: Railway Dashboardでビルドログを確認

## ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。 
