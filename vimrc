set nocompatible
"
" GENERAL SETTINGS
"
syntax enable                           " Enables syntax highlighing
set hidden                              " Required to keep multiple buffers open multiple buffers
set nowrap                              " Display long lines as just one line
set noerrorbells                        " Never ever
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set ruler              			        " Show the cursor position all the time
set cmdheight=2                         " More space for displaying messages
set mouse=a                             " Enable your mouse
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                            " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set tabstop=4 softtabstop=4             " Insert 4 spaces for a tab
set number
set shiftwidth=4                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
set laststatus=2                        " Always display the status line
set relativenumber                      " Line numbers
set cursorline                          " Enable highlighting of the current line
set background=light                    " tell vim what the background color looks like
set showtabline=2                       " Always show tabs
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set noswapfile                          " No swap files
set undodir=~/.vim/undodir              " Undo directory for undotree
set undofile                            " Write an undo file for undotruee
set shortmess+=c                        " Don't pass messages to |ins-completion-menu|.
set signcolumn=yes                      " Always show the signcolumn, otherwise it would shift the text each time
set updatetime=50                       " Faster completion
set timeoutlen=100                      " By default timeoutlen is 1000 ms
set clipboard=unnamed                   " Copy paste between vim and everything else
set incsearch                           " Allow finding search results
set nohlsearch                          " Don't highlight search results by default
set colorcolumn=88                      " Get a nice visualization where lw=88
highlight ColorColumn ctermbg=0 guibg=lightgrey
set iskeyword+=-                      	" treat dash separated words as a word text object
autocmd FileType * setlocal formatoptions-=cor  " Properly wrap comments
set backspace=indent,eol,start          " enable backspace

if has('python3')
    set pyx=3
endif

" Highlight search results only while searching
augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END
hi Comment cterm=italic

"
" MAPPINGS
"
nnoremap <C-l> $
nnoremap <C-h> ^
xnoremap <C-l> $
xnoremap <C-h> ^
silent! nnoremap <C-k> <C-U>
silent! xnoremap <C-k> <C-U>
silent! nnoremap <C-j> <C-D>
silent! xnoremap <C-j> <C-D>
nnoremap J 5gj
nnoremap K 5gk
xnoremap J 5gj
xnoremap K 5gk

" Leader key
let mapleader=" "

" let localleader=" "
nnoremap <Space> <Nop>

" Better indenting
vnoremap < <gv
vnoremap > >gv

" TAB in general mode will move to text buffer
nnoremap <silent> <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <silent> <S-TAB> :bprevious<CR>
