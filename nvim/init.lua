-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
  -- VSCode extension
else
  -- ordinary Neovim
  require("config.lazy")
end

-- Neovim spell check 비활성화
vim.opt.spell = false
vim.opt.spelllang = ""

