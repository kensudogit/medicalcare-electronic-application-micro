# Vercel デプロイガイド

## 概要

このガイドでは、Medical Care Electronic Application マイクロサービスを Vercel にデプロイする手順を説明します。

## 前提条件

1. **Node.js** (v18.0.0以上)
2. **Vercel CLI**
3. **Java 17** (JDK)
4. **Gradle**

## セットアップ

### 1. 自動セットアップ (推奨)

Windows の場合:
```bash
setup-vercel.bat
```

### 2. 手動セットアップ

#### Vercel CLI のインストール
```bash
npm install -g vercel
```

#### Vercel アカウントの設定
```bash
vercel login
```

## デプロイ手順

### 方法1: 自動デプロイスクリプト (推奨)

Windows の場合:
```bash
deploy-vercel.bat
```

### 方法2: 手動デプロイ

1. **プロジェクトのビルド**
```bash
cd api-gateway
./gradlew clean build -x test
cd ..
```

2. **Vercel へのデプロイ**
```bash
vercel --prod
```

## 環境変数の設定

Vercel ダッシュボードで以下の環境変数を設定してください:

- `SPRING_PROFILES_ACTIVE`: `vercel`
- `SERVER_PORT`: `8080`
- `JAVA_HOME`: `/usr/lib/jvm/java-17-openjdk`

## デプロイ後の確認

### 1. ヘルスチェック
```
https://your-project-name.vercel.app/health
```

### 2. API エンドポイント
```
https://your-project-name.vercel.app/api/users
https://your-project-name.vercel.app/api/applications
https://your-project-name.vercel.app/api/notifications
https://your-project-name.vercel.app/api/files
```

### 3. ルートエンドポイント
```
https://your-project-name.vercel.app/
```

## デプロイ状況の確認

```bash
check-vercel-status.bat
```

## 注意事項

- このデプロイでは、API Gateway のみが Vercel にデプロイされます
- 他のマイクロサービスは別のインフラにデプロイする必要があります
- データベース接続は外部のデータベースサービスを使用してください
- Vercel の無料プランでは、関数の実行時間に制限があります

## トラブルシューティング

### ビルドエラー
- Java 17 がインストールされているか確認
- Gradle が正しく動作するか確認
- `./gradlew clean build -x test` を実行

### デプロイエラー
- Vercel CLI が最新版か確認
- 環境変数が正しく設定されているか確認
- ビルドが成功しているか確認

### 実行時エラー
- Vercel ダッシュボードでログを確認
- 環境変数の設定を確認
- 関数の実行時間制限を確認

## アーキテクチャ

```
┌─────────────────┐
│   Vercel        │
│   (API Gateway) │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│   External      │
│   Services      │
│   (Database,    │
│    Other MS)    │
└─────────────────┘
```

## サポート

問題が発生した場合は、以下を確認してください:
1. Vercel ダッシュボードのログ
2. ビルドログ
3. アプリケーションログ
4. 環境変数の設定

## 次のステップ

1. 他のマイクロサービスをクラウドプロバイダーにデプロイ
2. データベース接続の設定
3. サービス間通信の設定
4. 監視とログの設定
