local M = {}

M.config = {
	file_path = vim.fn.stdpath("data") .. "/scratch-giant.md",
	open_cmd = "edit",
	mappings = {
		open = "<leader>s",
		toggle = "<leader>S",
	},
	auto_save = true,
	file_type = "markdown",
}

M.scratch_buffer = nil

function M.setup(user_config)
	if user_config then
		for k, v in pairs(user_config) do
			M.config[k] = v
		end
	end

	vim.api.nvim_create_user_command("ScratchGiant", function()
		M.open_scratchpad()
	end, {})

	vim.api.nvim_create_user_command("ScratchGiantToggle", function()
		M.toggle_scratchpad()
	end, {})

	if M.config.mappings.open then
		vim.keymap.set("n", M.config.mappings.open, function()
			M.open_scratchpad()
		end, { noremap = true, silent = true })
	end

	if M.config.mappings.toggle then
		vim.keymap.set("n", M.config.mappings.toggle, function()
			M.toggle_scratchpad()
		end, { noremap = true, silent = true })
	end
end

function M.open_scratchpad()
	if M.scratch_buffer and vim.api.nvim_buf_is_valid(M.scratch_buffer) then
		vim.api.nvim_set_current_buf(M.scratch_buffer)
		return
	end

	local dir = vim.fn.fnamemodify(M.config.file_path, ":h")
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	vim.cmd(M.config.open_cmd .. " " .. vim.fn.fnameescape(M.config.file_path))
	M.scratch_buffer = vim.api.nvim_get_current_buf()

	if M.config.auto_save then
		local group = vim.api.nvim_create_augroup("ScratchGiantAutoSave", { clear = true })
		vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
			group = group,
			buffer = M.scratch_buffer,
			callback = function()
				vim.cmd("silent! write")
			end,
		})
	end

	vim.opt_local.buflisted = false
	vim.opt_local.buftype = ""
	vim.opt_local.filetype = M.config.file_type
end

function M.close_scratchpad()
	if M.scratch_buffer and vim.api.nvim_buf_is_valid(M.scratch_buffer) then
		if M.config.auto_save then
			vim.api.nvim_buf_call(M.scratch_buffer, function()
				vim.cmd("silent! write")
			end)
		end

		if vim.api.nvim_get_current_buf() == M.scratch_buffer then
			vim.cmd("bprevious")
		end

		vim.api.nvim_buf_delete(M.scratch_buffer, { force = true })
		M.scratch_buffer = nil
	end
end

function M.toggle_scratchpad()
	if
		M.scratch_buffer
		and vim.api.nvim_buf_is_valid(M.scratch_buffer)
		and vim.api.nvim_buf_is_loaded(M.scratch_buffer)
		and vim.api.nvim_get_current_buf() == M.scratch_buffer
	then
		M.close_scratchpad()
	else
		M.open_scratchpad()
	end
end

return M
