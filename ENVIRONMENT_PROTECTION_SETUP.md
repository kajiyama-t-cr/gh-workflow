# GitHub Environments 環境保護の設定手順

このガイドでは、本番環境（prd）へのデプロイを管理者のみに制限する方法を説明します。

## 前提条件

- リポジトリの管理者権限が必要です
- ワークフローファイルに `environment:` の設定が必要（deploy-test.yml に設定済み）

## 設定手順

### 1. GitHubリポジトリのSettings を開く

1. GitHubでリポジトリページを開く
2. 上部メニューの `Settings` タブをクリック

### 2. Environments ページへ移動

1. 左サイドバーの `Environments` をクリック
2. `New environment` ボタンをクリック

### 3. prd 環境を作成

1. Environment name に `prd` と入力
2. `Configure environment` ボタンをクリック

### 4. 保護ルールを設定

#### Required reviewers（必須承認者）の設定

1. `Required reviewers` のチェックボックスを有効化
2. `Add up to 6 reviewers` の検索ボックスで承認者を追加
   - 管理者のGitHubユーザー名を入力
   - または管理者チームを選択
3. `Save protection rules` をクリック

#### その他のオプション設定（任意）

**Wait timer（待機時間）**
- デプロイ前に一定時間待機させる場合に設定
- 例: 5分待機してから実行

**Deployment branches and tags（デプロイ可能なブランチ）**
- `Selected branches and tags` を選択
- `Add deployment branch or tag rule` で `main` ブランチのみに制限
- これにより main ブランチからのみ本番デプロイ可能になります

**Environment secrets（環境固有のシークレット）**
- 本番環境専用のAPIキーやトークンを設定

### 5. 他の環境も設定（オプション）

dev と stg 環境も作成する場合:
- `New environment` で `dev` を作成（保護ルールなし）
- `New environment` で `stg` を作成（保護ルールなし）

## 検証方法

### 1. ワークフローを手動実行

1. リポジトリの `Actions` タブを開く
2. 左サイドバーから `Deploy Test` ワークフローを選択
3. `Run workflow` ボタンをクリック
4. `Environment` ドロップダウンから `prd` を選択
5. `Run workflow` を実行

### 2. 承認待ち状態を確認

- ワークフローが開始されると、承認待ち状態（Waiting）になります
- 画面に「Waiting for review」と表示されます
- 承認者に通知が送られます

### 3. 承認を実行

**承認者の場合:**
1. Actions タブで実行中のワークフローをクリック
2. 黄色い「Review deployments」ボタンが表示される
3. クリックして `prd` 環境にチェックを入れる
4. コメントを入力（任意）
5. `Approve and deploy` をクリック

**承認者以外の場合:**
- 「Review deployments」ボタンは表示されません
- ワークフローは承認待ち状態のままになります

### 4. デプロイ実行の確認

- 承認後、ワークフローが再開され、デプロイが実行されます
- ログで各ステップの実行内容を確認できます

## 現在のワークフロー設定の説明

`deploy-test.yml` の重要なポイント:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    # この行がGitHub Environmentsの保護ルールを有効化
    environment: ${{ github.event.inputs.environment || 'stg' }}
```

- `environment:` に環境名を指定することで、その環境の保護ルールが適用されます
- 手動実行時: 選択した環境（dev/stg/prd）の保護ルールを使用
- push時: デフォルトで stg 環境として実行（保護ルールなし）

## トラブルシューティング

### 承認ボタンが表示されない

- 自分が承認者リストに含まれているか確認
- リポジトリの管理者権限があるか確認

### ワークフローが実行されない

- ワークフローファイルが main または staging ブランチにマージされているか確認
- YAMLの構文エラーがないか確認

### 環境が見つからない

- 環境名の大文字小文字が一致しているか確認（prd vs PRD）
- Settings → Environments で環境が作成されているか確認

## 参考リンク

- [GitHub Environments 公式ドキュメント](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [Deployment protection rules](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#deployment-protection-rules)
