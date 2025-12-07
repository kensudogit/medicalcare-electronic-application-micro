# Railway Volumes設定ガイド

## 概要

Railwayでは、Dockerfile内の`VOLUME`キーワードが禁止されています。代わりに、RailwayのVolumes機能を使用する必要があります。

## 重要な注意事項

### ❌ 禁止事項

Dockerfile内で`VOLUME`キーワードを使用することはできません：

```dockerfile
# ❌ これは禁止されています
VOLUME ["/app/uploads"]
```

### ✅ 推奨事項

1. Dockerfileから`VOLUME`キーワードを削除
2. Railway Volumesを使用して永続ストレージを設定

---

## 現在のプロジェクトの状況

### Dockerfileの確認

すべてのDockerfileを確認した結果、`VOLUME`キーワードは使用されていません。✅

### docker-compose.ymlのvolumes

`docker-compose.yml`では、以下のvolumesが定義されています：

```yaml
volumes:
  postgres_users_data:
  postgres_applications_data:
  postgres_notifications_data:
  postgres_files_data:
  postgres_audit_data:
  file_uploads:
  redis_data:
  prometheus_data:
  grafana_data:
```

これらは**Docker Composeのvolumes定義**であり、Dockerfileの`VOLUME`キーワードとは異なります。✅

---

## Railway Volumesの設定方法

### 方法1: Railway Web UI

1. Railway Dashboard → プロジェクト → **Volumes**
2. **Create Volume**をクリック
3. ボリューム名とマウントパスを設定
4. サービスにアタッチ

### 方法2: railway.toml

```toml
[service]
volumes = [
  { mountPath = "/app/uploads", name = "file-uploads" }
]
```

### 方法3: docker-compose.yml（Railway対応）

Railwayは`docker-compose.yml`のvolumes定義をサポートしていますが、以下の点に注意：

1. **Named volumes**はRailwayで自動的に管理されます
2. **Bind mounts**（`./path:/container/path`）は使用できません
3. **Anonymous volumes**は推奨されません

---

## ファイルサービス用のVolumes設定

### 現在の設定

`file-service`では、`/app/uploads`ディレクトリにファイルを保存します。

#### Dockerfile（現在の実装）

```dockerfile
# Create uploads directory
RUN mkdir -p /app/uploads && \
    chown -R appuser:appgroup /app/uploads
```

`VOLUME`キーワードは使用していません。✅

#### docker-compose.yml

```yaml
file-service:
  volumes:
    - file_uploads:/app/uploads
```

### Railwayでの設定

Railwayでは、以下のいずれかの方法でvolumesを設定できます：

#### オプション1: Railway Volumesを使用（推奨）

1. Railway Dashboard → **Volumes**
2. 新しいボリュームを作成：
   - **Name**: `file-uploads`
   - **Mount Path**: `/app/uploads`
3. `file-service`にアタッチ

#### オプション2: docker-compose.ymlを使用

`docker-compose.yml`のvolumes定義は、Railwayで自動的に処理されます。

---

## データベース用のVolumes設定

### PostgreSQL Volumes

各PostgreSQLサービスで使用されるvolumes：

- `postgres_users_data`
- `postgres_applications_data`
- `postgres_notifications_data`
- `postgres_files_data`
- `postgres_audit_data`

これらは`docker-compose.yml`で定義されており、Railwayで自動的に管理されます。

---

## トラブルシューティング

### 問題1: "VOLUME keyword is banned"エラー

**症状**: Railwayでビルド時に`VOLUME`キーワードエラーが発生

**解決策**:
1. すべてのDockerfileを確認
2. `VOLUME`キーワードを削除
3. Railway Volumesを使用して永続ストレージを設定

### 問題2: ファイルが永続化されない

**症状**: コンテナ再起動時にファイルが失われる

**解決策**:
1. Railway Dashboard → **Volumes**でボリュームが作成されているか確認
2. サービスにボリュームがアタッチされているか確認
3. マウントパスが正しいか確認

### 問題3: ボリュームのマウントエラー

**症状**: ボリュームのマウントに失敗する

**解決策**:
1. マウントパスが存在するか確認（Dockerfileで`RUN mkdir -p /path`を実行）
2. パーミッションが正しいか確認
3. Railway Volumesの設定を確認

---

## ベストプラクティス

### 1. Dockerfileでのディレクトリ作成

```dockerfile
# ✅ 推奨: ディレクトリを作成するが、VOLUMEは使用しない
RUN mkdir -p /app/uploads && \
    chown -R appuser:appgroup /app/uploads
```

### 2. docker-compose.ymlでのvolumes定義

```yaml
# ✅ 推奨: Named volumesを使用
services:
  file-service:
    volumes:
      - file_uploads:/app/uploads

volumes:
  file_uploads:
```

### 3. Railway Volumesの使用

- Railway Dashboardで明示的にボリュームを作成
- 必要なサービスにアタッチ
- マウントパスを正しく設定

---

## まとめ

✅ **現在のプロジェクトは正しく設定されています**
- Dockerfileに`VOLUME`キーワードは使用されていません
- `docker-compose.yml`でvolumesが適切に定義されています
- Railwayで自動的にvolumesが管理されます

### 確認事項

- [x] すべてのDockerfileに`VOLUME`キーワードがない
- [x] `docker-compose.yml`でvolumesが定義されている
- [x] ディレクトリがDockerfileで作成されている

---

## 参考リンク

- [Railway Volumes Documentation](https://docs.railway.com/reference/volumes)
- [Docker Compose Volumes](https://docs.docker.com/compose/compose-file/compose-file-v3/#volumes)
- [Dockerfile VOLUME Instruction](https://docs.docker.com/reference/dockerfile/#volume)

---

**注意**: Railwayでは、Dockerfile内の`VOLUME`キーワードは使用できません。代わりに、Railway Volumesまたは`docker-compose.yml`のvolumes定義を使用してください。

