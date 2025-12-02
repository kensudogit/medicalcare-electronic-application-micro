# トラブルシューティングガイド

## 502 Bad Gateway エラー

### 原因
502エラーは、API Gatewayが起動していない、または正しく動作していないことを示します。

### 確認事項

1. **Railwayのデプロイメント状況を確認**
   - Railwayのダッシュボードで、各サービスが正常に起動しているか確認
   - 特に`api-gateway`サービスが起動しているか確認

2. **サービス間の依存関係を確認**
   - `api-gateway`は`service-discovery`に依存しています
   - `service-discovery`が起動していない場合、`api-gateway`も起動できません

3. **ログを確認**
   - Railwayのダッシュボードで各サービスのログを確認
   - エラーメッセージがないか確認

### 解決方法

1. **サービスを再起動**
   ```bash
   # Railwayのダッシュボードで各サービスを再起動
   ```

2. **サービス起動順序を確認**
   - `service-discovery`が最初に起動する必要があります
   - その後、他のサービスが起動します

3. **環境変数を確認**
   - RailwayのVariablesセクションで、必要な環境変数が設定されているか確認

## favicon.ico エラー

### 原因
Spring Cloud Gatewayはデフォルトで静的リソースを提供しないため、`favicon.ico`のリクエストが404エラーになります。

### 解決方法

`HealthController`に`/favicon.ico`のエンドポイントを追加しました。これにより、204 No Contentが返され、エラーが解消されます。

## content.js エラー

### 原因
`content.js:1 Uncaught (in promise) The message port closed before a response was received.`

このエラーは、ブラウザ拡張機能（Chrome拡張機能など）の問題で、アプリケーションとは無関係です。

### 解決方法

1. **ブラウザ拡張機能を無効化**
   - 開発者ツールで拡張機能を無効化してテスト

2. **シークレットモードでテスト**
   - 拡張機能が無効なシークレットモードでアプリケーションをテスト

3. **エラーを無視**
   - このエラーはアプリケーションの動作に影響しないため、無視しても問題ありません

## サービス起動順序

正しい起動順序：

1. **service-discovery** (Eureka Server)
2. **postgres-*** (データベース)
3. **redis** (キャッシュ)
4. **api-gateway**
5. **user-service**
6. **application-service**
7. **notification-service**
8. **file-service**
9. **audit-service**

## ヘルスチェック

各サービスのヘルスチェックエンドポイント：

- API Gateway: `http://localhost:8080/health`
- User Service: `http://localhost:8081/actuator/health`
- Application Service: `http://localhost:8082/actuator/health`
- Notification Service: `http://localhost:8083/actuator/health`
- File Service: `http://localhost:8084/actuator/health`
- Audit Service: `http://localhost:8085/actuator/health`
- Service Discovery: `http://localhost:8761/actuator/health`

## Railwayでの確認方法

1. **Railwayのダッシュボードを開く**
2. **各サービスのログを確認**
3. **Metrics**タブでCPU/メモリ使用率を確認
4. **Deployments**タブでデプロイメント履歴を確認

