-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
  -- VSCode extension
else
  -- ordinary Neovim
  require("config.lazy")
end

-- Neovim spell check 비활성화
vim.opt.spell = false
vim.g.python3_host_prog = vim.fn.expand("~/.venvs/nvim/bin/python")
vim.g.loaded_perl_provider = 0
