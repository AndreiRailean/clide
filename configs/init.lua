local nvim_state = "/app/.clide_state/nvim"

if vim.fn.isdirectory(nvim_state) == 0 then
	vim.fn.mkdir(nvim_state, "p")
end

vim.opt.undodir = nvim_state .. "/undo//"
vim.opt.swapfile = true
vim.opt.directory = nvim_state .. "/swap//"

vim.opt.number = true
