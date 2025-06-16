local vscode = require("vscode-neovim")
vim.keymap.set({ "n", "x", "i" }, "<C-d>", function()
  vscode.with_insert(function()
    vscode.action("editor.action.addSelectionToNextFindMatch")
  end)
end)

-- 효율적인 입력기 관리
local M = {}
M.abc_layout = 'com.apple.keylayout.ABC'
M.last_ime_check = 0

function M.ensure_abc_layout()
  local current_time = vim.loop.hrtime()
  -- 50ms 이내 중복 체크 방지
  if current_time - M.last_ime_check < 10000000 then
    return
  end

  M.last_ime_check = current_time

  if vim.fn.executable('im-select') == 1 then
    vim.fn.jobstart({ 'im-select' }, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data and data[1] and data[1] ~= M.abc_layout then
          vim.fn.system('im-select ' .. M.abc_layout)
        end
      end
    })
  end
end

-- Normal 모드 진입 시
vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
  callback = function()
    M.ensure_abc_layout()
  end
})

-- 커서 이동 시 (더 적극적인 감지)
vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    if vim.fn.mode() == 'n' then
      M.ensure_abc_layout()
    end
  end
})
