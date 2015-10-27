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

set nowrap " don't wrap lines
set tabstop=4 " a tab is four spaces
set tags=tags
set softtabstop=4 " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab " expand tabs by default (overloadable per file type later)
set shiftwidth=4 " number of spaces to use for autoindenting
set shiftround " use multiple of shiftwidth when indenting with '<' and '>'
set copyindent " copy the previous indentation on autoindenting
set number " always show line numbers
set ignorecase " ignore case when searching
set smartcase " ignore case if search pattern is all lowercase
set autowrite "Save on buffer switch
set mouse=a
set encoding=utf-8 " Necessary to show Unicode glyphs

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

