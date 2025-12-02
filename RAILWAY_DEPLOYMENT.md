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

1. **RailwayのSettings > Buildを確認**: 
   - 「Dockerfile」が選択されている場合、RailwayはプロジェクトルートにDockerfileを探します
   - **解決策**: RailwayのWeb UIで**Settings > Build**に移動し、**「Docker Compose」**を選択してください
   - または、**「Nixpacks」**を選択して、自動検出を使用することもできます

2. **railway.jsonの設定**:
   - `railway.json`が存在する場合、`dockerfilePath`が設定されているとRailwayはDockerfileを探します
   - docker-composeを使用する場合は、`railway.json`を削除するか、`dockerfilePath`を削除してください

3. **推奨設定**:
   - RailwayのWeb UIで**Settings > Build**に移動
   - **Build Method**で**「Docker Compose」**を選択
   - これにより、`docker-compose.yml`が自動的に検出され、各サービスのDockerfileが正しく使用されます

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

