local function comment_based_on_context()
	local save_pos = vim.fn.getpos(".")
	local syntax = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
	local syntax_name = (#syntax == 0) and "" or vim.fn.synIDattr(syntax[#syntax], "name")
	print("Current syntax: " .. syntax_name)
end

vim.api.nvim_set_keymap("n", "<C-/>", [[<Cmd>lua require('comments').lua comment_based_on_context()<CR>]], { noremap = true, silent = true })

return {
	comment_basedon_context = comment_based_on_context
}
