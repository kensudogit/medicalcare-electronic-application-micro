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

## Railway環境変数の設定

RailwayのVariablesセクションで以下を設定してください：

### API Gateway
- `EUREKA_SERVER_URL`: `http://service-discovery:8761/eureka/`（オプション、デフォルト値あり）
- `EUREKA_REGISTER`: `false`（オプション、デフォルト値あり）
- `EUREKA_FETCH`: `false`（オプション、デフォルト値あり）

### 各マイクロサービス
- `EUREKA_SERVICE_URL`: `http://service-discovery:8761/eureka/`（または`EUREKA_SERVER_URL`）
- `SPRING_DATASOURCE_URL`: 各サービスのデータベース接続URL
  - `audit-service`: `jdbc:postgresql://postgres-audit:5432/medicalcare_audit`
  - `user-service`: `jdbc:postgresql://postgres-users:5432/medicalcare_users`
  - `application-service`: `jdbc:postgresql://postgres-applications:5432/medicalcare_applications`
  - `notification-service`: `jdbc:postgresql://postgres-notifications:5432/medicalcare_notifications`
  - `file-service`: `jdbc:postgresql://postgres-files:5432/medicalcare_files`
- `SPRING_DATASOURCE_USERNAME`: `postgres`（オプション、デフォルト値あり）
- `SPRING_DATASOURCE_PASSWORD`: `password`（オプション、デフォルト値あり）

## データベース接続エラー

### 原因
`Connection to localhost:5432 refused`エラーは、アプリケーションが`localhost`に接続しようとしているが、Docker環境ではサービス名（例: `postgres-audit`）を使用する必要があることを示します。

### 解決方法

1. **application.ymlの確認**
   - デフォルト値が`localhost`ではなく、サービス名（例: `postgres-audit`）になっているか確認
   - 環境変数を使用する設定になっているか確認

2. **docker-compose.ymlの確認**
   - 各サービスに`SPRING_DATASOURCE_URL`環境変数が設定されているか確認
   - データベースサービス名が正しいか確認

3. **Railway環境変数の設定**
   - RailwayのVariablesセクションで、各サービスのデータベース接続URLを設定
   - サービス名を使用したURLを設定（例: `jdbc:postgresql://postgres-audit:5432/medicalcare_audit`）

## 502エラーの詳細な確認手順

1. **Railwayのダッシュボードで各サービスのステータスを確認**
   - 各サービスが「Running」状態か確認

2. **API Gatewayのログを確認**
   - Railwayのダッシュボードで`api-gateway`サービスのログを開く
   - エラーメッセージがないか確認
   - 起動に成功しているか確認（"Started ApiGatewayApplication"などのメッセージ）

3. **Service Discoveryのログを確認**
   - `service-discovery`サービスが起動しているか確認
   - Eurekaサーバーが正常に動作しているか確認

4. **ネットワーク接続を確認**
   - Railwayのネットワーク設定で、各サービスが同じネットワークに接続されているか確認
   - `medicalcare-network`が正しく設定されているか確認

5. **ポート設定を確認**
   - API Gatewayが`PORT`環境変数を使用しているか確認（`application.yml`で`server.port: ${PORT:8080}`が設定されている）
   - Railwayのポート設定が正しいか確認

6. **公開設定を確認**
   - RailwayのSettings > Networkingで、API Gatewayが公開設定されているか確認
   - パブリックURLが正しく生成されているか確認

詳細は`RAILWAY_502_FIX.md`を参照してください。

