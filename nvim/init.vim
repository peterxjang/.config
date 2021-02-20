call plug#begin("~/.vim/plugged")
  " Themes
  Plug 'dracula/vim'
	Plug 'haishanh/night-owl.vim'
	" Editing
	Plug 'cohama/lexima.vim'
	Plug 'tpope/vim-commentary'
	Plug 'bling/vim-bufferline'
	" Fuzzy find
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
	" Autocomplete/linting/formatting
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-solargraph', 'coc-elixir']
	" Language specific
	Plug 'leafgarland/typescript-vim'
	Plug 'posva/vim-vue'
	Plug 'elixir-editors/vim-elixir'
call plug#end()

" Syntax highlighting
if (has("termguicolors"))
  set termguicolors
endif
syntax enable
colorscheme night-owl

" Basic settings
set splitright
set splitbelow
set number
set tabstop=2
set shiftwidth=2
set clipboard=unnamed
set foldmethod=indent
set foldlevelstart=20
set nostartofline

" Buffer line
let g:bufferline_show_bufnr = 0
let g:bufferline_active_buffer_left = ''
let g:bufferline_active_buffer_right = ''
let g:bufferline_echo = 0
autocmd VimEnter *
	\ let &statusline='%{bufferline#refresh_status()}'
		\ .bufferline#get_status_string()

" Remember file position
augroup remember_position
  autocmd!
  let btToIgnore = ['terminal']
  autocmd BufWinLeave ?* if index(btToIgnore, &buftype) < 0 | mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END

" Fuzzy finder setup
let FZF_DEFAULT_COMMAND='fd --type f'
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
endif
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }

" Key overrides
imap <C-c> <Esc>
nnoremap <C-c> :noh<CR><C-c>
inoremap <C-f> <C-o>l
inoremap <C-b> <C-o>h
inoremap <silent><expr> <Tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Shortcuts
nnoremap <leader>s :w<CR>
inoremap <leader>s <C-c>:w<cr>
nnoremap <leader>p :Files<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>, :bprev<CR>
nnoremap <leader>. :bnext<CR>
nnoremap <leader>/ :Commentary<CR>
vnoremap <leader>/ :Commentary<CR>

" VSCode specific settings
if exists('g:vscode')
  nmap j gj
  nmap k gk
endif

