# Railway Dockerfile検出エラー修正ガイド

## 問題

RailwayがプロジェクトルートでDockerfileを検出しようとし、以下のエラーが発生していました：

```
ERROR: failed to build: failed to solve: failed to compute cache key: failed to calculate checksum of ref n073ub3vpr1cu2dqpgxi8yuz3::mknfeydiih4eji9ny75b2k8ye: "/src": not found
```

## 原因

1. RailwayがプロジェクトルートでDockerfileを探そうとしている
2. プロジェクトルートにはDockerfileがなく、各サービスディレクトリ（`api-gateway/`, `user-service/`など）にDockerfileがある
3. Railwayの設定でDocker Composeを使用するように明示的に設定されていない

## 解決策

### 1. Railway Web UIでの設定（最重要）

Railway Dashboardで以下の設定を行ってください：

1. **プロジェクト** → **Settings** → **Build**
2. **Build Method**を`Docker Compose`に設定
3. **Docker Compose File**を`docker-compose.yml`に設定
4. **Root Directory**を`/`（プロジェクトルート）に設定

### 2. 設定ファイルの確認

以下のファイルが正しく設定されているか確認：

#### railway.toml
```toml
[build]
builder = "DOCKERFILE"
dockerfilePath = "docker-compose.yml"
```

#### railway.json
```json
{
  "build": {
    "builder": "DOCKERFILE",
    "dockerfilePath": "docker-compose.yml"
  }
}
```

### 3. .railwayignoreファイル

`.railwayignore`ファイルを作成して、不要なファイルを除外：

```
api/
public/
vercel.json
package.json
*.md
```

---

## Railway設定手順（詳細）

### ステップ1: プロジェクト設定

1. [Railway Dashboard](https://railway.app)にアクセス
2. プロジェクトを選択
3. **Settings**をクリック

### ステップ2: Build設定

**Settings** → **Build**セクション：

1. **Build Method**:
   - ❌ `Dockerfile`（選択しない）
   - ✅ `Docker Compose`（これを選択）

2. **Docker Compose File**:
   - `docker-compose.yml`

3. **Root Directory**:
   - `/`（プロジェクトルート）

### ステップ3: Deploy設定

**Settings** → **Deploy**セクション：

1. **Start Command**:
   - 空（docker-composeが自動的に使用される）
   - または `docker-compose up -d`

2. **Restart Policy**:
   - `ON_FAILURE`
   - **Max Retries**: `10`

### ステップ4: 環境変数の設定

**Settings** → **Variables**で環境変数を設定：

```env
# 各サービス用のデータベースURL
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=postgres

# Eureka設定
EUREKA_SERVER_URL=http://service-discovery:8761/eureka/
```

---

## トラブルシューティング

### 問題1: RailwayがDockerfileを検出する

**症状**: ログに`Using Detected Dockerfile`と表示される

**解決策**:
1. Railway Settings → **Build** → **Build Method**を`Docker Compose`に変更
2. **Docker Compose File**を`docker-compose.yml`に設定
3. 設定を保存して再デプロイ

### 問題2: "/src": not found エラー

**症状**: ビルド時に`/src`ディレクトリが見つからない

**原因**: RailwayがプロジェクトルートでDockerfileを探している

**解決策**:
1. Railway Settingsで**Build Method**を`Docker Compose`に設定
2. 各サービスのDockerfileは`docker-compose.yml`で正しく参照されているか確認

### 問題3: docker-compose.ymlが見つからない

**症状**: `docker-compose.yml`が見つからないエラー

**解決策**:
1. プロジェクトルートに`docker-compose.yml`が存在するか確認
2. Railway Settings → **Build** → **Docker Compose File**のパスを確認
3. **Root Directory**が正しく設定されているか確認

---

## 確認事項

### 1. docker-compose.ymlの存在確認

```bash
# プロジェクトルートで確認
ls -la docker-compose.yml
```

### 2. 各サービスのDockerfile確認

以下のディレクトリにDockerfileが存在することを確認：

- `api-gateway/Dockerfile`
- `application-service/Dockerfile`
- `user-service/Dockerfile`
- `notification-service/Dockerfile`
- `file-service/Dockerfile`
- `audit-service/Dockerfile`
- `service-discovery/Dockerfile`

### 3. docker-compose.ymlの設定確認

```yaml
services:
  api-gateway:
    build:
      context: ./api-gateway  # サービスディレクトリがコンテキスト
      dockerfile: Dockerfile   # そのディレクトリ内のDockerfile
```

---

## デプロイフロー

正しいデプロイフロー：

1. Railwayが`docker-compose.yml`を読み込む
2. 各サービスの`build.context`で指定されたディレクトリをビルドコンテキストとして使用
3. 各ディレクトリ内の`Dockerfile`を使用してビルド
4. すべてのサービスを起動

---

## まとめ

✅ **Railway Settings → Build → Build Method: Docker Compose**
✅ **Docker Compose File: docker-compose.yml**
✅ **各サービスのDockerfileは各ディレクトリ内に存在**
✅ **プロジェクトルートにはDockerfileがない（正しい）**

Railwayの設定で**Build Method**を`Docker Compose`に設定することで、この問題は解決されます。

---

## 参考リンク

- [Railway Docker Compose Documentation](https://docs.railway.app/deploy/docker-compose)
- [Railway Build Settings](https://docs.railway.app/deploy/builds)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

