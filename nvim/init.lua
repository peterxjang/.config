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
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'
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

-- nvim-cmp
local cmp = require('cmp')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }
	})
})

-- lsp 
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local	on_attach = function(client, bufnr)
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

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').elixirls.setup({
	cmd = { "/usr/local/bin/elixir-ls/language_server.sh" },
	on_attach = on_attach,
	capabilities = capabilities,
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

