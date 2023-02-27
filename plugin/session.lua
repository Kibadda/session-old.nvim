if vim.g.loaded_Session == 1 then
  return
end

vim.g.loaded_Session = 1

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("SessionVimLeaveSaveSession", { clear = true }),
  callback = function()
    require("session.core").update();
  end
})
