local function check_comment(str)
	local trimmed = str:match("^%s*(.-)$")

	if trimmed:sub(1, 2) == "--" then
		return true
	else
		return false
	end
end

local function comment_based_on_context()
	--vim.notify("Function Triggered!")
	local save_pos = vim.fn.getpos(".")
	local syntax = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
	local syntax_name = (#syntax == 0) and "" or vim.fn.synIDattr(syntax[#syntax], "name")
	local filetype = vim.bo.filetype
	local line = vim.fn.getline(".")

	local filetype_action = {
		lua = function()
			if check_comment(line) then
				vim.cmd("normal! ^xx")
				vim.fn.setpos('.', save_pos)
			else
				vim.cmd("normal! I--")
				vim.fn.setpos('.', save_pos)
			end
		end
	}

	if filetype_action[filetype] then
		filetype_action[filetype]()
	end
end



vim.api.nvim_create_user_command('Comment', function()
	comment_based_on_context()
end, {})

return {
	comment_based_on_context = comment_based_on_context
}
