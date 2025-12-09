# Railway設定チェックリスト

## ⚠️ 重要: Railway Dashboardでの設定確認

このエラーを解決するには、**Railway Dashboardで正しい設定を行うことが最も重要**です。

## チェックリスト

### ✅ ステップ1: Railway Dashboardにアクセス

1. [Railway Dashboard](https://railway.app)にアクセス
2. プロジェクトを選択

### ✅ ステップ2: Build設定の確認

**Settings** → **Build**セクションで以下を確認：

- [ ] **Build Method**: `Docker Compose` ⚠️ **重要: `Dockerfile`ではない**
- [ ] **Docker Compose File**: `docker-compose.yml`
- [ ] **Root Directory**: `/`（プロジェクトルート）
- [ ] **Build Command**: **空**（削除されている）
- [ ] **Start Command**: **空**（削除されている、または`docker-compose up -d`）

### ✅ ステップ3: ビルドキャッシュをクリア

1. **Settings** → **Build**セクション
2. **Clear Build Cache**ボタンをクリック
3. 確認ダイアログで**Clear**をクリック

### ✅ ステップ4: 再デプロイ

1. **Deployments**タブを開く
2. **Redeploy**をクリック
3. ビルドログを確認

### ✅ ステップ5: ビルドログの確認

ビルドログで以下を確認：

- ✅ `Using Docker Compose`というメッセージが表示される
- ❌ `Using Detected Dockerfile`というメッセージが**表示されない**

## よくある間違い

### ❌ 間違い1: Build Methodが`Dockerfile`になっている

**症状**: ビルドログに`Using Detected Dockerfile`と表示される

**解決策**: **Build Method**を`Docker Compose`に変更

### ❌ 間違い2: Build Commandが設定されている

**症状**: `npm install`や`npm run build`などのコマンドが設定されている

**解決策**: **Build Command**を空にする（削除）

### ❌ 間違い3: Start Commandが`npm start`になっている

**症状**: `npm start`や`vercel dev`などのコマンドが設定されている

**解決策**: **Start Command**を空にする、または`docker-compose up -d`に設定

## 正しい設定のスクリーンショット例

```
Settings > Build
├── Build Method: Docker Compose ✅
├── Docker Compose File: docker-compose.yml ✅
├── Root Directory: / ✅
├── Build Command: (empty) ✅
└── Start Command: (empty) ✅
```

## 設定が正しくない場合の症状

- ❌ ビルドログに`Using Detected Dockerfile`と表示される
- ❌ `VOLUME`キーワードエラーが発生する
- ❌ 個別のDockerfileが検出される

## 設定が正しい場合の症状

- ✅ ビルドログに`Using Docker Compose`と表示される
- ✅ `docker-compose.yml`が使用される
- ✅ すべてのサービスが正しくビルドされる

## トラブルシューティング

### 問題: 設定を変更してもエラーが続く

**解決策**:
1. プロジェクトを削除
2. 新しいプロジェクトを作成
3. GitHubリポジトリを接続
4. **Settings** → **Build**で正しく設定
5. デプロイ

### 問題: Build Methodの選択肢に`Docker Compose`がない

**解決策**:
1. Railwayの最新バージョンを使用しているか確認
2. Railwayサポートに連絡

## まとめ

**最も重要なポイント**: Railway Dashboardで**Build Method**を`Docker Compose`に設定すること。

これが正しく設定されていないと、Railwayは個別のDockerfileを検出し、VOLUMEエラーが発生します。

---

## 参考リンク

- [Railway Docker Compose Documentation](https://docs.railway.app/deploy/docker-compose)
- [Railway Build Settings](https://docs.railway.app/deploy/builds)

---

**⚠️ 重要**: このチェックリストのすべての項目を確認してください。特に**Build Method**が`Docker Compose`であることを確認することが最も重要です。

