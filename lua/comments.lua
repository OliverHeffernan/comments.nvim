local function check_comment(str, type)
	local trimmed = str:match("^%s*(.-)$")
	local commentMarker = "//"
	if type == "lua" then
		commentMarker = "--"
	elseif type == "html" then
		commentMarker = "<!--"
	elseif type == "css" then
		commentMarker = "/*"
	end
	--vim.notify("'" .. trimmed:sub(1, #commentMarker) .. "'")
	--vim.notify(tostring(#commentMarker))
	--vim.notify("'" .. commentMarker .. "'")
	return trimmed:sub(1, #commentMarker) == commentMarker
end

local function javaScriptComment(commented)
	if commented then
		vim.cmd("normal! ^xx")
	else
		vim.cmd("normal! I//")
	end
end

local function cssComment(commented)
	if commented then
		vim.cmd("normal! A*/")
	else
		vim.cmd("normal! I/*")
	end
end

local function comment_based_on_context()
	--vim.notify("Function Triggered!")
	
	local mode = vim.api.nvim_get_mode().mode
	if mode == 'n' or mode == 'c' then
		local save_pos = vim.fn.getpos(".")
		local syntax = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
		local syntax_name = (#syntax == 0) and "" or vim.fn.synIDattr(syntax[#syntax], "name")
		local filetype = vim.bo.filetype
		vim.notify(filetype)
		vim.notify(syntax_name)
		local line = vim.fn.getline(".")

		local filetype_action = {
			lua = function()
				if check_comment(line, filetype) then
					vim.cmd("normal! ^xx")
					vim.fn.setpos('.', save_pos)
				else
					vim.cmd("normal! I--")
					vim.fn.setpos('.', save_pos)
				end
			end,
			vue = function()
				local html = syntax_name.find("html")
				if html and check_comment(line, "html") then
					vim.cmd("normal! I<!--")
					vim.cmd("normal! A-->")
					vim.fn.setpos('.', save_pos)
				end
			end,
			html = function()
				local type = "html"
				if syntax_name.find("html") then
					type = "html"
				elseif syntax_name.find("javaScript") then
					type = "javaScript"
					javaScriptComment(check_comment(line, type))
				elseif syntax_name.find("css") then
					type = "css"
					cssComment(check_comment(line, type))
				else
					if check_comment(line, type) then
						vim.cmd("normal! I<!--")
						vim.cmd("normal! A-->")
						vim.fn.setpos('.', save_pos)
					end
				end
			end,
			javaScript = function()
				javaScriptComment(check_comment(line, "javaScript"))
			end
			css = function()
				cssComment(check_comment(line, "css"))
			end
		}

		if filetype_action[filetype] then
			filetype_action[filetype]()
		end
	end
end



vim.api.nvim_create_user_command('Comment', function()
	comment_based_on_context()
end, {})

return {
	comment_based_on_context = comment_based_on_context
}
