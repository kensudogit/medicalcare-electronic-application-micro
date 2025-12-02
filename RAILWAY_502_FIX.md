# Railway 502エラー解決ガイド

## 問題
`https://medicalcare-electronic-application-micro-production.up.railway.app/` にアクセスすると502 Bad Gatewayエラーが発生する。

## 原因

1. **ポート設定の問題**: Railwayは自動的に`PORT`環境変数を設定しますが、アプリケーションが固定ポート8080を使用している
2. **サービス公開設定の問題**: Railwayでどのサービスを公開するかを明示的に設定する必要がある
3. **サービス起動の問題**: API Gatewayが正しく起動していない可能性

## 解決方法

### 1. ポート設定の修正（完了）

`api-gateway/src/main/resources/application.yml`を修正して、`PORT`環境変数に対応しました：

```yaml
server:
  port: ${PORT:8080}
```

これにより、Railwayが自動的に設定する`PORT`環境変数を使用できるようになります。

### 2. Railwayでの公開設定

Railwayでdocker-composeを使用する場合、以下の手順でAPI Gatewayを公開サービスとして設定してください：

#### ステップ1: Railwayダッシュボードを開く
1. [Railway Dashboard](https://railway.app/dashboard)にログイン
2. プロジェクト「medicalcare-electronic-application-micro」を開く

#### ステップ2: サービスを確認
1. 左側のサービス一覧で、`api-gateway`サービスを確認
2. もし`api-gateway`サービスが存在しない場合、docker-compose.ymlのサービス名を確認

#### ステップ3: 公開設定
1. `api-gateway`サービスをクリック
2. **Settings**タブを開く
3. **Networking**セクションに移動
4. **Generate Domain**ボタンをクリックして、パブリックURLを生成
   - または、既存のドメインがある場合は、それが正しく設定されているか確認

#### ステップ4: ポート設定の確認
1. **Settings**タブの**Variables**セクションを確認
2. `PORT`環境変数が自動的に設定されているか確認
   - Railwayは自動的に`PORT`環境変数を設定します
   - 手動で設定する必要はありません

### 3. サービス起動の確認

#### ステップ1: ログを確認
1. Railwayダッシュボードで`api-gateway`サービスを開く
2. **Deployments**タブを開く
3. 最新のデプロイメントをクリック
4. **Logs**タブで、以下のメッセージを確認：
   - `Started ApiGatewayApplication` - 起動成功
   - エラーメッセージがないか確認

#### ステップ2: ヘルスチェックを確認
1. Railwayダッシュボードで`api-gateway`サービスを開く
2. **Metrics**タブで、CPU/メモリ使用率を確認
3. ヘルスチェックが成功しているか確認

### 4. サービス間の依存関係を確認

API Gatewayは`service-discovery`に依存しています：

1. `service-discovery`サービスが起動しているか確認
2. `service-discovery`のログで、Eurekaサーバーが正常に起動しているか確認
3. `api-gateway`のログで、Eurekaへの接続が成功しているか確認

### 5. ネットワーク設定の確認

docker-compose.ymlで、すべてのサービスが同じネットワーク（`medicalcare-network`）に接続されているか確認：

```yaml
networks:
  - medicalcare-network
```

## トラブルシューティング

### API Gatewayが起動しない場合

1. **ログを確認**
   - Railwayダッシュボードで`api-gateway`サービスのログを確認
   - エラーメッセージを特定

2. **環境変数を確認**
   - `EUREKA_SERVER_URL`が正しく設定されているか確認
   - `EUREKA_REGISTER`と`EUREKA_FETCH`が`false`に設定されているか確認

3. **Service Discoveryの起動を確認**
   - `service-discovery`サービスが起動しているか確認
   - Eurekaサーバーが正常に動作しているか確認

### 502エラーが続く場合

1. **サービスを再起動**
   - Railwayダッシュボードで、`api-gateway`サービスを再起動
   - 必要に応じて、`service-discovery`も再起動

2. **デプロイを再実行**
   - Railwayダッシュボードで、最新のコミットを再デプロイ

3. **ポート設定を確認**
   - Railwayの`PORT`環境変数が正しく設定されているか確認
   - `application.yml`で`${PORT:8080}`が正しく設定されているか確認

## 確認手順

1. ✅ `application.yml`で`server.port: ${PORT:8080}`が設定されている
2. ✅ Railwayで`api-gateway`サービスが公開設定されている
3. ✅ `service-discovery`サービスが起動している
4. ✅ `api-gateway`サービスのログで起動成功メッセージが確認できる
5. ✅ ヘルスチェックが成功している

## 次のステップ

1. Railwayで再デプロイを実行
2. ログを確認して、エラーメッセージがないか確認
3. パブリックURLにアクセスして、502エラーが解消されているか確認

