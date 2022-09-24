local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
  -- Themes
  Plug 'haishanh/night-owl.vim'
	-- Interface
  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim'
	Plug 'karb94/neoscroll.nvim'
	-- Editing
  Plug 'cohama/lexima.vim'
  Plug 'tpope/vim-commentary'
	Plug 'mattn/emmet-vim'
	-- Languages
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'neovim/nvim-lspconfig'
	Plug 'jose-elias-alvarez/null-ls.nvim'
vim.call('plug#end')

-- Shortcuts
vim.keymap.set('n', '<leader>s', ':w<CR>')
vim.keymap.set('i', '<leader>s', '<C-c>:w<cr>')  
vim.keymap.set('n', '<leader>p', ':Telescope find_files<CR>')
vim.keymap.set('n', '<leader>b', ':Telescope buffers<CR>')
vim.keymap.set('n', '<leader>f', ':Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>/', ':Commentary<CR>')
vim.keymap.set('v', '<leader>/', ':Commentary<CR>') 
vim.keymap.set('n', '<C-c>', ':noh<CR><C-c>')

-- Basic settings
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.clipboard = 'unnamed'
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 20
vim.opt.cursorline = true
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes:1"
vim.opt.numberwidth = 5
vim.wo.wrap = false
vim.opt.termguicolors = true
vim.cmd [[colorscheme night-owl]]
vim.opt.mouse = "a"

-- gitsigns 
require('gitsigns').setup()

-- neoscroll
require('neoscroll').setup()

-- commentary
vim.cmd [[autocmd FileType elixir setlocal commentstring=#\ %s]]

-- emmet
vim.cmd [[imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")]]

-- treesitter
require('nvim-treesitter.configs').setup({ highlight = { enable = true }})

-- lsp 
vim.cmd [[autocmd CompleteDone * pclose]]
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local	on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.formatting_sync()
			end,
		})
	end
end

require('lspconfig').elixirls.setup({
	cmd = { "/usr/local/bin/elixir-ls/language_server.sh" },
	on_attach = on_attach
})

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.diagnostics.eslint,
		require("null-ls").builtins.formatting.prettier,
		require("null-ls").builtins.diagnostics.rubocop,
		require("null-ls").builtins.formatting.rufo,
	},
	on_attach = on_attach
})

