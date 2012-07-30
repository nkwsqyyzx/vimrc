"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This vimrc is most frequent used by wsq.
" You can find the latest version on:
"       http://github.com/nkwsqyyzx/vimrc/
"
" Maintainer:  wsq
" Last Change: 2012-7-30 15:47:52
" Email:       nk.wangshuangquan@gmail.com    
" Version:     0.1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype on

" the most frequent used working path.should change this in a project.
let workPath='d:\work\'
if isdirectory(workPath)
    exec "cd ".workPath
else
    " tell the user to modify the path.
    echo workPath.' is not a directory'
endif

set backspace=indent,eol,start whichwrap+=<,>,[,]
set fileencodings=utf-8,gb2312,gbk,gb18030,ucs-bom,default,chinese
syntax on

if filereadable('c:\private.vim')
    source c:\private.vim
endif

" Sun Aug 21 00:05:50 CST 2011
" format codes.
set cindent
set tabstop=4
set shiftwidth=4
set colorcolumn=81
" auto change tab to 4 spaces.should avoid this in Python.
set expandtab
set autoindent

" Tue Aug 30 22:24:56 CST 2011 very useful in format a function or a {} block.
:nmap <S-Tab> ma=a{`a
"}

" 2012/7/16/ format codes.
" From:http://wiki.hotoo.me/Vim.html
nmap <tab> v>
vmap <tab> >gv
vmap <s-tab> <gv

" no backup no swp.
set nobackup
set nowb

" see E303 can not open temp file.
set directory=.,$TEMP

" easy view codes.
set number
set ruler

" esay searching file.
set incsearch
set hlsearch
set ignorecase
" press ESC to unhilight the search results.
nnoremap <silent> <ESC> :noh<CR><ESC>

" set the path for file searching.
set path+=.\*\,.\*\*\,.\*\*\*\

" auto read file if the file was updated.
set autoread

" make gvim to the max size when started.
if has("win32")
    autocmd GUIEnter * simalt ~x
else
" add linux and mac version.
endif

" file type 2012/6/29/
au BufRead,BufNewFile *.xaml set filetype=xml

" very important, for map leader.
let mapleader = ","

" Mon Sep 19 10:49:18 CST 2011 new a tab.
:nmap <Leader>t :tabnew<CR>
:imap <C-t> <C-o>:tabnew<CR>

" Tue Sep 27 09:07:03 CST 2011 switch tabs.
:nmap <Leader>1 :tabfirst<CR>
:nmap <Leader>2 :tabprevious<CR>
:nmap <Leader>3 :tabnext<CR>
:nmap <Leader>4 :tablast<CR>

" Wed Dec 21 17:19:37 CST 2011 esay to use MiniBufExplorer.
:nmap <silent> <Leader>y :TMiniBufExplorer<CR>

" Tue Sep 27 10:51:41 CST 2011 quit all buffer and exit.
:nmap <Leader>Q :qall<CR>

:nmap <Leader>ss :source %<CR>

" move fast in search results.
:nmap <S-F3> :cnext<CR>
:nmap <S-F1> :cNext<CR>

" clipboard.
" Tue Sep 13 16:33:43 CST 2011
:nmap <Leader>v "*p
:imap <C-v> <C-o>"*p
:imap <Leader>v <C-r>"*

" Thu Aug 25 08:51:46 CST 2011
" clipboard.
:vmap <C-x> "*d
:vmap <C-c> "*y


" Fri Oct 28 09:25:26 CST 2011
" switch in buffers.
:nmap <Leader>n :bNext<CR>
:nmap <Leader>p :bprevious<CR>
:nmap <C-tab> :bNext<CR>
:nmap <C-S-tab> :bprevious<CR>

:nmap <C-l> <C-w><C-l>
:nmap <C-h> <C-w><C-h>
:nmap <C-j> <C-w><C-j>
:nmap <C-k> <C-w><C-k>

" easy go to the next/prev diff.
:nmap <A-j> ]c
:nmap <A-k> [c

" Tue Sep 13 16:34:01 CST 2011
:nmap <Leader>w :w<CR>

" Wed Sep 14 09:54:35 CST 2011
:nmap <Leader>q :bd<CR>

" Tue Sep 13 16:34:01 CST 2011
" delete all lines.frequent used in temp file such as logs.
:nmap <Leader>d :%d<CR>

" enter to current directory and edit it.
:nmap <Leader>Z :call ChangeToDirectory()<CR>

" edit the current directory but not enter the directory.
:nmap <Leader>z :call EditFileDirectory()<CR>

" Wed Sep 14 14:41:51 CST 2011
" format codes.
:nmap <Leader>f zfa}

" gui font.
if has('win32')
    set guifont=Courier_New:h13:cANSI
else
    set guifont=Monaco:h14
endif

" search word under the cursor.
map <S-F4> :call Search_Word()<CR>:copen<CR>
function! Search_Word()
let w = expand("<cword>") " get the word under the cursor
silent execute ":vimgrep " w " **/*.cs **/*.xaml *.cs *.xaml"
endfunction

" Shift-F5 easy to change to .m/.h file.
" Thu Aug 25 17:46:04 CST 2011 use bufexists to detect the buffer exists in the buffer list.
:map <silent> <S-F5> :call ChangeToHFile()<CR>
function! ChangeToHFile()
    let filename=expand("%:r")
    let fileext=expand("%:e")
    let fileopen=""
    if 0
        if fileext==?"h"
            let fileopen=filename.".m"
        else
            let fileopen=filename.".h"
        endif
    else
        if fileext==?"xaml"
            let fileopen=filename.".xaml.cs"
        elseif fileext==?"cs"
            let fileopen=filename
        endif
    endif
    if filereadable(fileopen)
        call SwitchToBuf(fileopen)
    else 
    endif
endfunction

" very useful,space to go to next/prev page.
:map <Space> <C-F>
:map <S-Space> <C-B>

" two ,, to escape from insert mode,back to normal mode.
" Wed Aug 24 09:05:44 CST 2011
im  ,, <ESC>

" fast close window such as quickfix or help window.
:nmap <silent> dc <C-W><C-W>:close<CR>

" Sun Aug 28 23:20:58 CST 2011 switch in file.
" see http://easwy.com/blog/archives/advanced-vim-skills-introduce-vimrc/
function! SwitchToBuf(filename)
    " find in current tab
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
    return
    else
        " find in each tab
        tabfirst
        let tab = 1
        while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(a:filename)
            if bufwinnr != -1
                exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
            return
            endif
            tabnext
            let tab = tab + 1
        endwhile
    " not exist, new tab
    exec ":e ". fnameescape(a:filename)
    endif
endfunction

" edit the current directory.
:nmap <Leader>z :call EditFileDirectory()<CR>
function! EditFileDirectory()
    let path = expand('%:p:h')
    exec ":e ". fnameescape(path)
endfunction

" enter the current file`s directory.
:nmap <Leader>Z :call ChangeToDirectory()<CR>
function! ChangeToDirectory()
    let path = expand('%:p:h')
    exec ":e ". fnameescape(path)
    exec ":cd ". fnameescape(path)
endfunction

" show results in tab.
function! TabMessage(cmd)
    redir => message
    silent execute a:cmd
    redir END
    tabnew
    silent put=message
    set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

" 2012/6/5/ added:delete all other buffers.
" http://blog.csdn.net/magicpang/article/details/2308167
fun! DeleteAllBuffersInWindow()
    let s:curWinNr = winnr()
    if winbufnr(s:curWinNr) == 1
        ret
    endif
    let s:curBufNr = bufnr("%")
    exe "bn"
    let s:nextBufNr = bufnr("%")
    while s:nextBufNr != s:curBufNr
        exe "bn"
        exe "bdel ".s:nextBufNr
        let s:nextBufNr = bufnr("%")
    endwhile
endfun
command! -nargs=0 DeleteAllBuffers call DeleteAllBuffersInWindow()
let g:indent_guides_guide_size = 1
