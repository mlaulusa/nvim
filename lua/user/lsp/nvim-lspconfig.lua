local status, nvim_lsp = pcall(require, 'lspconfig')
if (not status) then return end

local protocol = require('vim.lsp.protocol')

-- put diagnostic stuff in a floating window
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus = false })]]

local custom_attach = function(client, bufnr)
  print("LSP started")
  require'completion'.on_attach(client)
  -- require'diagnostic'.on_attach(client)

  -- formatting
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
    buffer = bufnr,
    callback = function() vim.lsp.buf.formatting_seq_sync() end
  })
  end

  local map = vim.api.nvim_set_keymap

  map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
	map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
	map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
	map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
	map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
	map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
	map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
	map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
	map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
	map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
	map('n','<leader>af','<cmd>lua vim.lsp.buf.code_action()<CR>')
	map('n','<leader>ee','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>')
	map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
	map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
	map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
	map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

nvim_lsp.lua_ls.setup {
  on_attach = custom_attach,
  settings = {
    Lua = {
      diagnostic = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
    },
  },
}

nvim_lsp.svelte.setup {
  on_attach = custom_attach,
  filetypes = {
    "svelte"
  },
  capabilities = capabilities,
}

nvim_lsp.tsserver.setup {
  on_attach = custom_attach,
  filetypes = {
    "typescript", "typescriptreact", "typescript.tsx"
  },
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities,
}
