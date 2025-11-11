function ColorMyPencils(color)
	color = color or "rose-pine"
	-- Use pcall to avoid errors if colorscheme isn't installed yet
	local ok = pcall(vim.cmd.colorscheme, color)
	if not ok then
		return
	end
	
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()

