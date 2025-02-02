# go-to-pr.nvim

A Neovim plugin that provides GitHub Pull Request integration using the GitHub CLI (`gh`).

## Features

- Open or create Pull Requests directly from Neovim
- Find the Pull Request that introduced the code at your cursor position
- Seamless integration with GitHub CLI

## Prerequisites

- Neovim 0.10.0 or later
- [GitHub CLI](https://cli.github.com/) (`gh`) installed and authenticated
- Git

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "tkuramot/go-to-pr.nvim",
  config = function()
    require("go-to-pr").setup()
  end
}
```

## Usage

The plugin provides the following functions:

### `require("go-to-pr").open_pr()`

Opens the current branch's Pull Request in your browser. If no PR exists, it opens the PR creation page.

Example mapping:
```lua
vim.keymap.set("n", "<leader>gho", require("go-to-pr").open_pr, { desc = "Open/Create PR" })
```

### `require("go-to-pr").blame_pr()`

Finds and opens the Pull Request that introduced the code at your cursor position.

Example mapping:
```lua
vim.keymap.set("n", "<leader>ghb", require("go-to-pr").blame_pr, { desc = "Blame PR" })
```

## License

MIT License
