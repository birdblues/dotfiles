-- -- bootstrap lazy.nvim, LazyVim and your plugins
if vim.g.vscode then
  print("Neovim is running in VSCode")
else
  print("Neovim is running in terminal")
  require("config.lazy")
  require("plugins.colorscheme")
end

vim.g.python3_host_prog = vim.fn.expand("~/.venvs/nvim/bin/python")
