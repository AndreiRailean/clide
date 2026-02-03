local project_state = "/app/.dev-env-container-state"

if vim.fn.isdirectory(project_state) == 0 then
	vim.fn.mkdir(project_state, "p")
end

vim.opt.undodir = project_state .. "/undo//"
vim.opt.swapfile = true
vim.opt.directory = project_state .. "/swap//"

vim.opt.number = true
