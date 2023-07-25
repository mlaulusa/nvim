local neodev_status_ok, neodev = pcall(require, "neodev")
if not neodev_status_ok then
	return
end

local dapui_status_ok, dapui = pcall(require, "dapui")
if not dapui_status_ok then
	return
end

neodev.setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

dapui.setup()
