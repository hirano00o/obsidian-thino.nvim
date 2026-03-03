# obsidian-thino.nvim

[obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) を通じて、[Thino](https://github.com/Quorafind/Obsidian-Thino) 形式のメモをデイリーノートに投稿する Neovim プラグインです。

## このプラグインは何か

Thino は Obsidian のプラグインで、タイムスタンプ付きのクイックメモを記録できます。このプラグインは同じ体験を Neovim 上で実現します。フローティングウィンドウを開いてメモを入力し、ポストすれば今日のデイリーノートに自動でタイムスタンプ付きで書き込まれます。エディタを離れる必要はありません。

## 要件

- Neovim >= 0.10.0
- [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim)

## インストール

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "hirano00o/obsidian-thino.nvim",
  dependencies = {
    "epwalsh/obsidian.nvim",  -- 今日のデイリーノートのパスを取得するために必要
  },
  opts = {},
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "hirano00o/obsidian-thino.nvim",
  requires = { "epwalsh/obsidian.nvim" },
  config = function()
    require("obsidian-thino").setup()
  end,
}
```

### 依存プラグイン

| プラグイン | 用途 |
|-----------|------|
| [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) | 今日のデイリーノートのパスを解決するために使用 |

## 使い方

### コマンド

```vim
:ThinoPost
```

メモ入力用のフローティングウィンドウを開きます。

### キーマップ（フローティングウィンドウ内）

| キー | モード | 動作 |
|------|--------|------|
| `<C-CR>` (Ctrl+Enter) | ノーマル、インサート | メモを今日のデイリーノートに投稿 |
| `<C-s>` (Ctrl+s) | ノーマル、インサート | 同上 |
| `q` | ノーマル | キャンセルしてウィンドウを閉じる |

### 出力形式

入力例:
```
メモの1行目
2行目
3行目
```

デイリーノートへの書き込み結果（`itemize = "list"` の場合）:
```markdown
- 14:30 メモの1行目
  2行目
  3行目
```

デイリーノートへの書き込み結果（`itemize = "task"` の場合）:
```markdown
- [ ] 14:30 メモの1行目
  2行目
  3行目
```

## 設定

```lua
require("obsidian-thino").setup({
  -- 以下はデフォルト値
  time_format = "%H:%M",
  itemize = "list",
  popup_window = {
    border = "rounded",
    title = "Thino (<C-CR> or <C-s> to post)",
    title_pos = "center",
    width_ratio = 0.6,
    height = 10,
  },
})
```

### オプション一覧

| オプション | 型 | デフォルト | 説明 |
|-----------|-----|-----------|------|
| `time_format` | `string` | `"%H:%M"` | タイムスタンプのフォーマット。`"%H:%M"` または `"%H:%M:%S"` が指定可能。 |
| `itemize` | `string` | `"list"` | リストのスタイル。`"list"` は `- `、`"task"` は `- [ ] ` を先頭に付与。 |
| `popup_window.border` | `string` | `"rounded"` | ウィンドウの枠線スタイル。`"bold"`, `"double"`, `"none"`, `"rounded"`, `"shadow"`, `"single"`, `"solid"` から選択。 |
| `popup_window.title` | `string` | `"Thino (<C-CR> or <C-s> to post)"` | ウィンドウ上部に表示されるタイトル。 |
| `popup_window.title_pos` | `string` | `"center"` | タイトルの表示位置。`"left"`, `"center"`, `"right"` から選択。 |
| `popup_window.width_ratio` | `number` | `0.6` | エディタ幅に対するウィンドウ幅の比率（0.1〜1.0）。 |
| `popup_window.height` | `number` | `10` | ウィンドウの高さ（行数、1以上）。 |

## ライセンス

MIT
