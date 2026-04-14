-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Force file reload when switching back from terminal or another buffer
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermClose" }, {
  group = vim.api.nvim_create_augroup("auto_reload_files", { clear = true }),
  command = "checktime",
})
