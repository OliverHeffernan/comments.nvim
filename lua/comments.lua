local function check_comment(str, commentMarker)
	local trimmed = str:match("^%s*(.-)$")
	--vim.notify("'" .. trimmed:sub(1, #commentMarker) .. "'")
	--vim.notify(tostring(#commentMarker))
	--vim.notify("'" .. commentMarker .. "'")
	return trimmed:sub(1, #commentMarker) == commentMarker
end

local function doubleSlashComment(commented)
	if commented then
		vim.cmd("normal! ^xx")
	else
		vim.cmd("normal! I//")
	end
end

local function cssComment(commented)
	if commented then
		vim.cmd("normal! ^xx")
		vim.cmd("normal! $xx")
	else
		vim.cmd("normal! I/*")
		vim.cmd("normal! A*/")
	end
end

local function htmlComment(commented)
	if commented then
		vim.cmd("normal! ^4x")
		vim.cmd("normal! $xxx")
	else
		vim.cmd("normal! I<!--")
		vim.cmd("normal! A-->")
	end
end

local function html5Comment(line)
	if string.find(syntax_name, "html") then
		htmlComment(check_comment(line, "<!--"))
	elseif string.find(syntax_name, "javaScript") then
		doubleSlashComment(check_comment(line, "//"))
	elseif string.find(syntax_name, "css") then
		type = "css"
		cssComment(check_comment(line, "/*"))
	else
		htmlComment(check_comment(line, "<!--"))
	end
end

local function hashComment(commented)
	if commented then
		vim.cmd("normal! ^x")
	else
		vim.cmd("normal! I#")
	end
end

local function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

local function doubleDashComment(commented)
	if commented then
		vim.cmd("normal! ^xx")
		vim.fn.setpos('.', save_pos)
	else
		vim.cmd("normal! I--")
		vim.fn.setpos('.', save_pos)
	end
end

local function comment(type, syntax_name, line)
	if contains({"lua", "haskell", "sql"}, type) then
		doubleDashComment(check_comment(line, "--")) 
	elseif contains({"python", "r", "ruby"}, type) then
		hashComment(check_comment(line, "#"))
	elseif type == "html" then
		html5Comment(line, type)
	else
		doubleSlashComment(check_comment(line, "//"))
	end

	vim.fn.setpos('.', save_pos)
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
		comment(filetype, syntax_name, line)
	end
end
		--[[
		local filetype_action = {
			lua = function()
				doubleDashComment(check_comment(line, 
			end,
			Haskell = function()
				if check_comment(line, filetype) then
					vim.cmd("normal! ^xx")
					vim.fn.setpos('.', save_pos)
				else
					vim.cmd("normal! I--")
					vim.fn.setpos('.', save_pos)
				end
			end,
			vue = function()
				local html = string.find(syntax_name, "html")
				if html and check_comment(line, "html") then
					vim.cmd("normal! I<!--")
					vim.cmd("normal! A-->")
					vim.fn.setpos('.', save_pos)
				end
			end,
			html = function()
				local type = "html"
				if string.find(syntax_name, "html") then
					type = "html"
					htmlComment(check_comment(line, type))
				elseif string.find(syntax_name, "javaScript") then
					type = "javaScript"
					javaScriptComment(check_comment(line, type))
				elseif string.find(syntax_name, "css") then
					type = "css"
					cssComment(check_comment(line, type))
				else
					htmlComment(check_comment(line, type))
				end
			end,
			javaScript = function()
				javaScriptComment(check_comment(line, "javaScript"))
			end,
			javascript = function()
				javaScriptComment(check_comment(line, "javaScript"))
			css = function()
				cssComment(check_comment(line, "css"))
			end,
			python = function()
				pythonComment(check_comment(line, "python"))
			end,
			r = function()
				pythonComment(check_comment(line, "python"))
			end,
			c = function ()
				javaScriptComment(check_comment(line, "javaScript"))
			end,
			cpp = function ()
				javaScriptComment(check_comment(line, "javaScript"))
			end,
			java = function()
				javaScriptComment(check_comment(line, "javaScript"))
			end,
			ruby = function()
				pythonComment(check_comment(line, "python"))
			end,
			typescript = function()
				javaScriptComment(check_comment(line, "javaScript"))
			end,
			kotlin = function()
				javaScriptComment(check_comment(line, "javaScript"))
			end,
		}



		if filetype_action[filetype] then
			filetype_action[filetype]()
		end
		]]




vim.api.nvim_create_user_command('Comment', function()
	comment_based_on_context()
end, {})

return {
	comment_based_on_context = comment_based_on_context
}
