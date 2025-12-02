# Railway セットアップ手順

## "Dockerfile does not exist" エラーの解決方法

### 問題
RailwayのSettings > Buildで「Dockerfile」が選択されているため、プロジェクトルートにDockerfileを探してエラーになっています。

### 解決方法

#### ステップ1: RailwayのWeb UIで設定を変更

1. Railwayのダッシュボードでプロジェクトを開く
2. **Settings**タブをクリック
3. **Build**セクションに移動
4. **Build Method**または**Builder**のドロップダウンを確認
5. **「Docker Compose」**を選択
   - もし「Docker Compose」オプションがない場合:
     - **「Nixpacks」**を選択（自動検出）
     - または、**「Dockerfile」**の設定を削除

#### ステップ2: railway.jsonの確認

- プロジェクトルートに`railway.json`がある場合:
  - docker-composeを使用する場合は**削除**してください
  - または、`dockerfilePath`の設定を削除してください

#### ステップ3: デプロイ設定の確認

**Settings > Deploy**で以下を確認:
- **Start Command**: `docker-compose up -d`（オプション）
- Railwayは`docker-compose.yml`を自動検出します

## 推奨設定

### Build設定
- **Build Method**: **Docker Compose**（推奨）
- または **Nixpacks**（自動検出）

### Watch Paths設定
以下を追加してください:
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

## 注意事項

- Railwayでdocker-composeを使用する場合、`railway.json`は**不要**です
- 各サービスのDockerfileは各サービスディレクトリ内にあります
- `docker-compose.yml`がプロジェクトルートにあることを確認してください

## トラブルシューティング: "gradlew not found" エラー

このエラーが発生する場合、Railwayのビルドコンテキストが正しく設定されていない可能性があります。

### 確認事項

1. **docker-compose.ymlの設定を確認**:
   ```yaml
   services:
     notification-service:
       build:
         context: ./notification-service  # サービスディレクトリがコンテキスト
         dockerfile: Dockerfile
   ```

2. **Railwayの設定を確認**:
   - **Settings > Build**で「Docker Compose」が選択されているか確認
   - プロジェクトルートに`docker-compose.yml`が存在するか確認

3. **ビルドログを確認**:
   - `COPY . .`の後に`ls -la`を実行して、どのファイルがコピーされているか確認
   - `gradlew`が存在しない場合、ビルドコンテキストが正しく設定されていない可能性があります

### 解決方法

RailwayのWeb UIで以下を確認してください:
- **Settings > Build**で「Docker Compose」を選択
- プロジェクトルートに`docker-compose.yml`が存在することを確認
- 各サービスの`context`が正しく設定されていることを確認

