# Railway VOLUMEキーワードエラー修正ガイド

## エラーメッセージ

```
The `VOLUME` keyword is banned in Dockerfiles. Use Railway volumes instead.
```

## 原因

Railwayでは、Dockerfile内の`VOLUME`キーワードが禁止されています。

## 解決策

### ステップ1: Dockerfileの確認

すべてのDockerfileを確認し、`VOLUME`キーワードを削除します。

#### ❌ 禁止されている記述

```dockerfile
VOLUME ["/app/uploads"]
VOLUME /app/data
```

#### ✅ 正しい記述

```dockerfile
# ディレクトリを作成するが、VOLUMEは使用しない
RUN mkdir -p /app/uploads && \
    chown -R appuser:appgroup /app/uploads
```

### ステップ2: 現在のプロジェクトの状況

✅ **すべてのDockerfileを確認した結果、`VOLUME`キーワードは使用されていません。**

### ステップ3: Railway Volumesの設定

#### 方法1: Railway Web UI

1. Railway Dashboard → プロジェクト → **Volumes**
2. **Create Volume**をクリック
3. 設定：
   - **Name**: `file-uploads`
   - **Mount Path**: `/app/uploads`
4. `file-service`にアタッチ

#### 方法2: docker-compose.yml（現在の実装）

`docker-compose.yml`でvolumesが定義されています：

```yaml
file-service:
  volumes:
    - file_uploads:/app/uploads

volumes:
  file_uploads:
```

Railwayは`docker-compose.yml`のvolumes定義を自動的に処理します。

---

## 確認手順

### 1. Dockerfileの確認

```bash
# すべてのDockerfileでVOLUMEキーワードを検索
grep -r "VOLUME" */Dockerfile
```

結果が空であれば、問題ありません。✅

### 2. docker-compose.ymlの確認

```bash
# volumes定義を確認
grep -A 5 "volumes:" docker-compose.yml
```

volumesが正しく定義されていることを確認。✅

### 3. Railway設定の確認

Railway Dashboard → **Settings** → **Build**:
- **Build Method**: `Docker Compose`
- **Docker Compose File**: `docker-compose.yml`

---

## トラブルシューティング

### 問題1: エラーが続く場合

**原因**: キャッシュされたDockerfileが使用されている可能性

**解決策**:
1. Railway Dashboard → **Settings** → **Clear Build Cache**
2. 再デプロイ

### 問題2: ファイルが永続化されない

**原因**: Railway Volumesが設定されていない

**解決策**:
1. Railway Dashboard → **Volumes**でボリュームを作成
2. サービスにアタッチ
3. マウントパスを確認

---

## まとめ

✅ **現在のプロジェクトは正しく設定されています**
- Dockerfileに`VOLUME`キーワードは使用されていません
- `docker-compose.yml`でvolumesが適切に定義されています

エラーが発生する場合は、Railwayのキャッシュをクリアして再デプロイしてください。

---

## 参考リンク

- [Railway Volumes Documentation](https://docs.railway.com/reference/volumes)
- [RAILWAY_VOLUMES_GUIDE.md](./RAILWAY_VOLUMES_GUIDE.md)

