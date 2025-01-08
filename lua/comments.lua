-- function to check if a string is a comment, given the string and the comment marker
-- the comment marker is a string that is used to create a comment in any given language, for example '//' for javascript
-- returns true or false
local function check_comment(str, commentMarker)
	local trimmed = str:match("^%s*(.-)$")
	return trimmed:sub(1, #commentMarker) == commentMarker
end

-- commands for executing the comment or uncomment
-- commented is usually passed in as a result of the check_comment function
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

-- comment used to do different types of comments within html files, as there could be css, or javascript within an html file
local function html5Comment(line, syntax_name)
	-- check if the current line is an html line
	if string.find(syntax_name, "html") then
		htmlComment(check_comment(line, "<!--"))
	-- else check if the current line is an javaScript line
	elseif string.find(syntax_name, "javaScript") then
		doubleSlashComment(check_comment(line, "//"))
	-- else check if the current line is an css line
	elseif string.find(syntax_name, "css") then
		cssComment(check_comment(line, "/*"))
	-- if all of those checks fail, then default to an html comment
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

local function doubleDashComment(commented)
	if commented then
		vim.cmd("normal! ^xx")
		vim.fn.setpos('.', save_pos)
	else
		vim.cmd("normal! I--")
		vim.fn.setpos('.', save_pos)
	end
end

-- used in the comment function to check what type of comment should be executed based on the filetype
local function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- executes one of the comment command depending on the file type
local function comment(type, syntax_name, line, save_pos)
	local commentMarker = "//"
	local commented
	local lineLength = #line
	if contains({"lua", "haskell", "sql"}, type) then
		commented = check_comment(line, "--")
		doubleDashComment(commented) 
		commentMarker = "--"
	elseif contains({"python", "r", "ruby"}, type) then
		commented = check_comment(line, "#")
		hashComment(commented)
		commentMarker = "#"
	elseif type == "html" then
		commented = check_comment(line, "<!--")
		html5Comment(line, syntax_name)
		commentMarker = "<!--"
	else
		doubleSlashComment(check_comment(line, "//"))
	end

	vim.fn.setpos('.', save_pos)
	-- readjusting the position based on the length of the marker, and whether the line was empty to begin with
	if lineLength == 0 then
		vim.cmd("normal! $")
	elseif commented then
		vim.cmd("normal! " .. tostring(#commentMarker) .. "h")
	else
		vim.cmd("normal! " .. tostring(#commentMarker) .. "l")
	end
end

-- this function is called when the user enters the command ":Comment"
local function comment_based_on_context()
	-- the current mode in neovim
	local mode = vim.api.nvim_get_mode().mode
	-- check if the user is either in normal, or command line mode
	if mode == 'n' or mode == 'c' then
		-- record the current cursor position so that we can return to it once the command has been executed
		local save_pos = vim.fn.getpos(".")
		-- get the syntax name, this helps us to check if there is javascript or css within a html file
		local syntax = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
		local syntax_name = (#syntax == 0) and "" or vim.fn.synIDattr(syntax[#syntax], "name")
		-- get the file type
		local filetype = vim.bo.filetype
		-- get the text from the currently selected line so that we can enter it into the check comment function later
		local line = vim.fn.getline(".")
		-- pass all of these props into the comment function
		comment(filetype, syntax_name, line, save_pos)
	end
end

-- creates the command ":Comment"
vim.api.nvim_create_user_command('Comment', function()
	comment_based_on_context()
end, {})

return {
	comment_based_on_context = comment_based_on_context
}
