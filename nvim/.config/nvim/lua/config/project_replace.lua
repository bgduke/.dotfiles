local M = {}

local function search_escape(text)
	return text:gsub("\\", "\\\\"):gsub("/", "\\/")
end

local function replacement_escape(text)
	return text:gsub("\\", "\\\\"):gsub("/", "\\/"):gsub("&", "\\&")
end

function M.run()
	local rg = vim.fn.exepath("rg")
	if rg == "" then
		vim.notify("Project replace needs ripgrep: rg is not executable in Neovim's PATH", vim.log.levels.ERROR)
		return
	end

	local search = vim.fn.input("Search: ")
	if search == "" then
		return
	end

	local replacement = vim.fn.input("Replace with: ")
	local confirm = vim.fn.input("Confirm each replacement? [y/N]: ")
	local flags = confirm:lower():match("^y") and "gec" or "ge"

	local rg_cmd = {
		rg,
		"--vimgrep",
		"--fixed-strings",
		"--hidden",
		"--glob=!.git",
		search,
		".",
	}

	local matches = vim.fn.systemlist(rg_cmd)
	if vim.v.shell_error ~= 0 then
		if vim.v.shell_error == 1 then
			vim.notify("No matches found for: " .. search, vim.log.levels.INFO)
		else
			vim.notify("Project replace ripgrep failed: " .. table.concat(matches, "\n"), vim.log.levels.ERROR)
		end
		return
	end

	vim.fn.setqflist({}, "r", {
		title = "Project replace: " .. search,
		lines = matches,
		efm = "%f:%l:%c:%m",
	})

	local pattern = "\\V" .. search_escape(search)
	local replace = replacement_escape(replacement)
	vim.cmd("silent cfdo keeppatterns %s/" .. pattern .. "/" .. replace .. "/" .. flags .. " | update")
	vim.notify("Project replace complete: " .. search, vim.log.levels.INFO)
end

return M
