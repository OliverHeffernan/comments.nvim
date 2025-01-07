local function comment_based_on_context()
	--vim.notify("Function Triggered!")
	local save_pos = vim.fn.getpos(".")
	local syntax = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
	local syntax_name = (#syntax == 0) and "" or vim.fn.synIDattr(syntax[#syntax], "name")
	local filetype = vim.bo.filetype
	local line = vim.fn.getline(".")
	local is_commented = line:match("^%s*--") -- check if line is already commented, matching if it starts with -- with optional spaces
	
	local filetype_action = {
		lua = function()
			if is_commented then
				vim.cmd("normal! ^xx")
				vim.fn.setpos('.', save_pos)
			else
				vim.cmd("normal! I--")
				vim.fn.setpos('.', save_pos)
				--vim.cmd("normal! <Esc>")
			end
		end
	}

	if filetype_action[filetype] then
		filetype_action[filetype]()
	end
	--vim.notify("Current syntax: " .. syntax_name)
end

--vim.api.nvim_set_keymap("n", "<C-k>", [[<Cmd>lua require('comments').comment_based_on_context()<CR>]], { noremap = true, silent = true })

vim.api.nvim_create_user_command('Comment', function()
	comment_based_on_context()
end, {})

return {
	comment_based_on_context = comment_based_on_context
}
