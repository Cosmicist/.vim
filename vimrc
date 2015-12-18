python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

" Use VIm settings, rather that Vi settings (mucho better!)
" This must be first, because it changes other options as a side effect.
set nocompatible
set t_Co=256

execute pathogen#infect()

syntax on
colorscheme jelleybeans " xoria256 twilight256
:filetype plugin indent on
autocmd Filetype gitcommit setlocal spell textwidth=72

" === Spaces, Tabs & Indentation ===
set tabstop=4       " number of visual spaces per tab
set softtabstop=4   " <BS> removes spaces as if they were tabs
set expandtab       " tabs are spaces (overloadable per file type later)
set shiftwidth=4    " number of spaces to use for autoindenting
set shiftround      " use multiple of shiftwidth when indenting with '<' and '>'
set copyindent      " copy the previous indentation on autoindenting

" === UI ===
set number      " always show line numbers
set cursorline  " highlight current line
set wildmenu    " visual autocomplete for command menu
set lazyredraw  " redraw only when we need to
set showmatch   " highlight matching [{()}]
set incsearch   " search as characters are entered
set hlsearch    " highlight matches

" === Other options ===
set nowrap          " don't wrap lines
set tags=tags
set ignorecase      " ignore case when searching
set smartcase       " ignore case if search pattern is all lowercase
set autowrite       " Save on buffer switch
set mouse=a
set encoding=utf-8 " Necessary to show Unicode glyphs

" === Folding ===
set foldenable          " enable folding
set foldmethod=syntax   " fold based on syntax
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" space toggles folds
nnoremap <space> za

" === Leader Shortcuts ===
let mapleader=","
" turn off search highlight:
nnoremap <leader><space> :noh<CR> 
" edit vimrc/zshrc and source vimrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" SuperSave: save current session
nnoremap <leader>s :mksession<CR>
" SilverSearcher: open ag.vim
nnoremap <leader>a :Ag

" === CtrlP ===
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" === NERDTree ===
map <C-b> :NERDTreeToggle<CR>
" Open NERDTree if no file is specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close VIm if only NERDTree is left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd cursorhold * set nohlsearch
autocmd cursormoved * set hlsearch

"Auto change directory to match current file ,cd
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

" Auto-remove trailing spaces
autocmd BufWritePre *.php :%s/\s\+$//e

" Create/edit file in the current directory
nmap :ed :edit %:p:h/

" Swap files out of the project root
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

" Modeline
set modelines=5

function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Allow saving files as sudo when I forget to start vim with sudo
" http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap w!! w !sudo tee > /dev/null %

" Automatically set paste and nopaste mode at when pasting (as happens in
" VIM UI). Tmux compatible.

function! WrapForTmux(s)
    if !exists('$TMUX')
        return a:s
    endif

    let tm_start = "\<Esc>Ptmux;"
    let tm_end   = "\<Esc>\\"

    return tm_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tm_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

