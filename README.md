# Scratch-Giant for Neovim

A simple plugin for Neovim that provides a persistent scratchpad functionality. The scratchpad persists to a file so you can close and reopen it between sessions.

## Features

- Open a dedicated scratchpad buffer with a single command
- Persist scratchpad content to a file automatically
- Configurable file path and keybindings
- Auto-save on text changes

## Installation

### Using lazy.nvim

```lua
{
  'bearded-giant/scratch-giant.nvim',
  config = function()
    require('scratch-giant').setup()
  end
}
```

## Configuration

```lua
require('scratch-giant').setup({
  file_path = vim.fn.stdpath('data') .. '/scratch-giant.md', -- Default location
  open_cmd = 'edit', -- Command used to open the scratchpad
  mappings = {
    open = '<leader>s', -- Keymap to open the scratchpad
  },
  auto_save = true, -- Automatically save changes
  file_type = 'markdown' -- Filetype for the scratchpad (markdown or text)
})
```

## Usage

- Use the `:ScratchGiant` command to open the scratchpad
- Press `<leader>s` (default keymap) to quickly open the scratchpad
- The content will be automatically saved and persist between sessions

## License

MIT
