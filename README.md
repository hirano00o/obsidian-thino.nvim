# obsidian-thino.nvim

A Neovim plugin that posts memos in [Thino](https://github.com/Quorafind/Obsidian-Thino) format to your daily note via [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim).

## What is this plugin?

Thino is an Obsidian plugin for capturing quick, timestamped memos. This Neovim plugin brings that same experience to Neovim: open a floating window, type your memo, and post it with a timestamp to today's daily note — all without leaving your editor.

## Requirements

- Neovim >= 0.10.0
- [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim)

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "hirano00o/obsidian-thino.nvim",
  dependencies = {
    "epwalsh/obsidian.nvim",  -- Required to locate today's daily note
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

### Dependencies

| Plugin | Purpose |
|--------|---------|
| [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) | Resolves the path to today's daily note |

## Usage

### Command

```vim
:ThinoPost
```

Opens a floating window for memo input.

### Keymaps (inside the floating window)

| Key | Mode | Action |
|-----|------|--------|
| `<C-CR>` (Ctrl+Enter) | Normal, Insert | Post the memo to today's daily note |
| `q` | Normal | Cancel and close the window |

### Output format

Input:
```
First line of memo
second line
third line
```

Posted to daily note (`itemize = "list"`):
```markdown
- 14:30 First line of memo
  second line
  third line
```

Posted to daily note (`itemize = "task"`):
```markdown
- [ ] 14:30 First line of memo
  second line
  third line
```

## Configuration

```lua
require("obsidian-thino").setup({
  -- Default values shown below
  time_format = "%H:%M",
  itemize = "list",
  popup_window = {
    border = "rounded",
    title = "Thino (<C-CR> to post)",
    title_pos = "center",
    width_ratio = 0.6,
    height = 10,
  },
})
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `time_format` | `string` | `"%H:%M"` | Timestamp format. Accepts `"%H:%M"` or `"%H:%M:%S"`. |
| `itemize` | `string` | `"list"` | List style. `"list"` produces `- `, `"task"` produces `- [ ] `. |
| `popup_window.border` | `string` | `"rounded"` | Window border style. One of `"bold"`, `"double"`, `"none"`, `"rounded"`, `"shadow"`, `"single"`, `"solid"`. |
| `popup_window.title` | `string` | `"Thino (<C-CR> to post)"` | Title displayed at the top of the window. |
| `popup_window.title_pos` | `string` | `"center"` | Title position. One of `"left"`, `"center"`, `"right"`. |
| `popup_window.width_ratio` | `number` | `0.6` | Width of the window as a ratio of the editor width (0.1–1.0). |
| `popup_window.height` | `number` | `10` | Height of the window in lines (≥ 1). |

## License

MIT
