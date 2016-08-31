" vimrc file for zhcosin.
" to use this vimrc by add ':source dir/vimrcx_cosin.vim' in the main vimrc
" file.
" author:				zhcosin<zhoucosin@163.com>
" last modified:		2015/06/08

" no compatible with vi.
set nocompatible

" set encodings.
set encoding=cp936
set fileencodings=cp936,gbk,gb2312,gb18030
set fileencoding=cp936
set termencoding=cp936

" the position and size of the gvim windows when start.
winpos 235 130
set lines=25 columns=100 
set autoindent

" set the width of the TAB key.
set tabstop=4
set shiftwidth=4

" set the mininum lines between cursos and the top or
" bottom of the screen.
set scrolloff=2

" a line end with \r\n or \n
set fileformats=dos,unix

" font and size
set guifont=courier_new:h10

" color scheme
if has("gui_running")
  "colorscheme solarized
  colorscheme desert
else
  colorscheme desert
endif " has

" show the number of each line
set nu

" status bar
set ruler

" display incomplete commands
set showcmd			

" Show matching brackets when text indicator is over them
set showmatch

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" do incremental searching
set incsearch		

" keep 20 lines of command line history
set history=20		

" keep a backup file
set backup			

" show too-long line as far as possible instead of show '@@@'...
set display=lastline

"Set mapleader
let mapleader = " "

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
vnoremap <silent> <leader>/ /<C-R>"<CR>
vnoremap <silent> <leader>? ?<C-R>"<CR>
vnoremap <silent> <leader>// /<C-R>=escape(@", '\\/.*^~[]')<CR><CR>
vnoremap <silent> <leader>?? ?<C-R>=escape(@", '\\/.*^~[]')<CR><CR>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" fold with the marker in file when the file type is cosin.
" you can make your file belong to this type by written the follow
" content in the first line in your file:
" # vim: filetype=cosin
" the first character can be '#' or ';' or other comment-like character.
autocmd FileType cosin	set foldmethod=marker
autocmd FileType c		set foldmethod=syntax
autocmd FileType cpp	set foldmethod=syntax

"Fast reloading of the .vimrc
map <silent> <leader>ss :source $VIMRUNTIME/vimrc_cosin.vim<cr>
"Fast editing of .vimrc
map <silent> <leader>ee :e $VIMRUNTIME/vimrc_cosin.vim<cr>
"When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source $VIMRUNTIME/vimrc_cosin.vim
"Execute the command which edit in current line and put the result
"follow this line
map <silent> <leader>x yyp:. !bash<cr>

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Open lvimgrep and put the cursor in the right position
map <leader>fa :lvimgrep //% \| lopen<left><left><left><left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

