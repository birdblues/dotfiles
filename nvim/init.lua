local function set_english()
  -- macOS: 영어 입력기 ID ("com.apple.keylayout.ABC" 등)
  os.execute("/opt/homebrew/bin/im-select com.apple.keylayout.ABC")
end

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = set_english,
})

vim.g.fuzzy_prebuilt = true

vim.opt.langmap =
  "ㅁa,ㅠb,ㅊc,ㅇd,ㄷe,ㄹf,ㅎg,ㅗh,ㅑi,ㅓj,ㅏk,ㅣl,ㅡm,ㅜn,ㅐo,ㅔp,ㅂq,ㄱr,ㄴs,ㅅt,ㅕu,ㅍv,ㅈw,ㅌx,ㅛy,ㅋz"

if vim.g.vscode then
  require("config.lazy-vscode")
else
  require("config.lazy")
end

if vim.g.vscode then
  print("Neovim is running in VSCode")
  require("config.lazy-vscode")
  vim.opt.clipboard:append("unnamedplus")
else
  print("Neovim is running in terminal")
  require("config.lazy")
  require("plugins.colorscheme")
end

vim.g.python3_host_prog = vim.fn.expand("~/.venvs/nvim/bin/python")
vim.opt.spell = false
