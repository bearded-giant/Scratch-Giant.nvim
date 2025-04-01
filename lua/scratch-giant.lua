local M = {}

M.config = {
	file_path = vim.fn.stdpath("data") .. "/scratch-giant.md",
	open_cmd = "edit",
	mappings = {
		open = "<leader>s",
	},
	auto_save = true,
	file_type = "markdown",
}

function M.setup(user_config)
	if user_config then
		for k, v in pairs(user_config) do
			M.config[k] = v
		end
	end

	vim.api.nvim_create_user_command("ScratchGiant", function()
		M.open_scratchpad()
	end, {})

	if M.config.mappings.open then
		vim.keymap.set("n", M.config.mappings.open, function()
			M.open_scratchpad()
		end, { noremap = true, silent = true })
	end
end

function M.open_scratchpad()
	local dir = vim.fn.fnamemodify(M.config.file_path, ":h")
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	vim.cmd(M.config.open_cmd .. " " .. vim.fn.fnameescape(M.config.file_path))

	if M.config.auto_save then
		local group = vim.api.nvim_create_augroup("ScratchGiantAutoSave", { clear = true })
		vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
			group = group,
			buffer = vim.api.nvim_get_current_buf(),
			callback = function()
				vim.cmd("silent! write")
			end,
		})
	end

	vim.opt_local.buflisted = false
	vim.opt_local.buftype = ""
	vim.opt_local.filetype = M.config.file_type
end

return M
