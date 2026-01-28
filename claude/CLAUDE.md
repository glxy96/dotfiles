# Global Claude Code Instructions

このファイルはすべてのプロジェクトで読み込まれるグローバル指示です。
プロジェクト固有の `CLAUDE.md` で別のルールが指定されている場合は、そちらを優先してください。

## Git Workflow

特に指示がない限り、以下のルールに従ってください：

1. **mainブランチへの直接コミット禁止**
   - 必ずfeatureブランチを作成してから作業する
   - `git checkout -b <branch-name>`

2. **作業完了後はPRを作成**
   - `gh pr create` コマンドでPull Requestを作成する
   - ユーザーがGitHub上でレビュー・マージする

3. **マージ後のクリーンアップ**
   - マージ完了後、ローカルブランチを削除: `git branch -d <branch-name>`
   - mainを最新に: `git checkout main && git pull`

### 典型的な作業フロー

```bash
# 1. ブランチ作成
git checkout -b feature/add-new-feature

# 2. 作業・コミット
git add <files>
git commit -m "✨ Add new feature"

# 3. プッシュ & PR作成
git push -u origin feature/add-new-feature
gh pr create --title "Add new feature" --body "..."

# 4. （ユーザーがマージ後）クリーンアップ
git checkout main
git pull
git branch -d feature/add-new-feature
```

## 実装アプローチ

- **場当たり的な修正を避ける**: 根本原因を理解してから対処する
- **意図を明確にする**: なぜその実装にするのか、理由を考える
- **全体との整合性**: アーキテクチャや既存のパターンとの一貫性を保つ
- **大局的な視点**: 目の前の問題だけでなく、将来の影響も考慮する
