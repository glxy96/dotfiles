---
name: branch-clean
description: Clean up merged Git branches safely. Current branch or all merged branches.
disable-model-invocation: true
argument-hint: [all]
---

# Branch Cleanup

Git ブランチの安全なクリーンアップを行う。

## 使い分け

- `$ARGUMENTS` が空 → 現在のブランチを片付ける
- `$ARGUMENTS` が `all` → マージ済みブランチを一括削除

---

## 現在のブランチを片付ける（引数なし）

以下の順番で安全チェックを行い、すべてパスした場合のみ削除する。
1つでも失敗したら理由を伝えて **中断** する。

### チェック項目

1. **mainにいないか**: `git rev-parse --abbrev-ref HEAD` で確認。mainなら「既にmainです」と伝えて終了
2. **未コミットの変更がないか**: `git status --porcelain` で確認。変更があれば中断
3. **リモートにpush済みか**: `git rev-parse --abbrev-ref --symbolic-full-name @{u}` でupstreamがあるか確認。なければ「リモートにpushされていません。作業が失われる可能性があります」と中断
4. **PRがマージ済みか**: `gh pr view "$current_branch" --repo "$(gh repo view --json nameWithOwner -q '.nameWithOwner')" --json state -q '.state'` で確認。`MERGED` でなければ中断

### 実行

すべてのチェックを通過したら:

```
current_branch=$(git rev-parse --abbrev-ref HEAD)
git switch main
git pull
git branch -d "$current_branch"
```

- `git branch -d` が失敗した場合（未マージ）はそのままエラーにする。`-D` は絶対に使わない
- リモートブランチが残っていれば `git push origin --delete "$current_branch"` で削除（エラーは無視）
- 完了したら削除したブランチ名を報告

---

## マージ済みブランチを一括削除（`all`）

### 手順

1. `git switch main && git pull` で最新化
2. `git branch` でローカルブランチ一覧を取得（main を除外）
3. `repo=$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/' | sed 's/.*github.com[:/]\(.*\)/\1/')` でリポジトリ名を取得
4. 各ブランチについて `gh pr view <branch> --repo "$repo" --json state -q '.state'` で状態を確認
4. `MERGED` のブランチのみ:
   - `git branch -d <branch>` でローカル削除
   - `git push origin --delete <branch>` でリモート削除（エラーは無視）
5. 削除したブランチ一覧と、スキップしたブランチ（未マージ・PRなし）の一覧を報告

### 安全ルール

- `main` は絶対に削除しない
- `git branch -D` は絶対に使わない
- PRの状態が `MERGED` でないブランチはスキップ
- 未コミット変更がある場合は開始前に警告して中断
