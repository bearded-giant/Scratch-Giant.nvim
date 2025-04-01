if vim.g.loaded_scratch_giant then
	return
end
vim.g.loaded_scratch_giant = true

require("scratch-giant").setup()
