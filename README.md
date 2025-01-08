# Comments.nvim
Comments.nvim is a plugin for neovim, which allows you to comment any line of code with a simple command.

## Installation
You can install this using lazy.nvim
```
{
    "OliverHeffernan/comments.nvim",
    config = function()
        require("comments")
    end,
},
```
# Usage
The command to comment a line is `:Comment`. I recommend binding this to a keyboard shortcut in your init.lua. I like control + k.
```lua
vim.api.nvim_set_keymap('n', '<C-k>', ':Comment<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-k>', '<Esc>:Comment<CR>i', { noremap = true, silent = true })
```

# Supported languages
 - All languages that use "//" for single-line commenting, including:
     - javaScript
     - java
     - c
     - c++
     - c#
     - go
     - rust
     - and more
 - html
 - css
 - python
 - lua
 - haskell
 - sql
 - r
 - ruby

If you have any more languages, or if you notice that there is a javascript framework that does not work, feel free to contribute to the repository, or make a request.

## JavaScript Frameworks
It should work with all javaScript frameworks, but I have only tested for vue. Please let me know if it does/doesn't work with any other javascript frameworks, so that I can update this list or fix the issue.
