local function comment_based_on_context()
	vim.notify("Function Triggered!")
	local save_pos = vim.fn.getpos(".")
	local syntax = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
	local syntax_name = (#syntax == 0) and "" or vim.fn.synIDattr(syntax[#syntax], "name")
	vim.notify("Current syntax: " .. syntax_name)
end

vim.api.nvim_set_keymap("n", "<C-_>", [[<Cmd>lua require('comments').comment_based_on_context()<CR>]], { noremap = true, silent = true })

return {
	comment_based_on_context = comment_based_on_context
}
