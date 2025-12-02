# Railway デプロイメントガイド

## 概要

このプロジェクトはRailwayでdocker-composeを使用してデプロイされます。

## デプロイメント方法

### 方法1: Railway CLIを使用

```bash
# Railway CLIをインストール
npm i -g @railway/cli

# Railwayにログイン
railway login

# プロジェクトを初期化
railway init

# docker-composeを使用してデプロイ
railway up
```

### 方法2: Railway Web UIを使用

1. Railwayのダッシュボードで新しいプロジェクトを作成
2. GitHubリポジトリを接続
3. **Settings > Build**で以下を設定:
   - **Build Command**: 空（docker-composeを使用するため）
   - **Start Command**: `docker-compose up -d`
   - **Root Directory**: `/`（プロジェクトルート）

4. **Settings > Deploy**で以下を設定:
   - **Deploy Strategy**: `docker-compose`
   - **Docker Compose File**: `docker-compose.yml`

## 重要な設定

### Watch Paths設定

RailwayのSettings > Watch Pathsで以下を設定してください:

```
/api-gateway/**
/audit-service/**
/application-service/**
/user-service/**
/notification-service/**
/file-service/**
/service-discovery/**
/docker-compose.yml
/infrastructure/**
/monitoring/**
```

### 環境変数

各サービスに必要な環境変数をRailwayのVariablesセクションで設定してください。

## トラブルシューティング

### "Dockerfile does not exist" エラー

このエラーが発生する場合:

1. **railway.jsonを削除**: プロジェクトルートに`railway.json`がある場合は削除してください
2. **docker-composeを使用**: Railwayの設定でdocker-composeを使用するように設定してください
3. **ビルドコンテキストを確認**: 各サービスの`docker-compose.yml`で`context`が正しく設定されているか確認してください

### 各サービスのビルドコンテキスト

`docker-compose.yml`では、各サービスのビルドコンテキストが正しく設定されています:

```yaml
services:
  api-gateway:
    build:
      context: ./api-gateway  # サービスディレクトリがコンテキスト
      dockerfile: Dockerfile   # そのディレクトリ内のDockerfile
```

## 注意事項

- Railwayでは、docker-composeを使用する場合、`railway.json`は不要です
- 各サービスは個別のビルドコンテキストを持っています
- Watch Pathsを正しく設定することで、変更時に自動デプロイがトリガーされます

