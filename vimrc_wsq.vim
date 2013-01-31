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

let s:script_name = expand('<sfile>:p:h')
" set for develope environmet.I just have ios and csharp
" iosdev for ios
" csharpdev for c#
let s:dev_env = "csharpdev"

filetype on

set backspace=indent,eol,start whichwrap+=<,>,[,]
set fileencodings=utf-8,gb2312,gbk,gb18030,ucs-bom,default,chinese
syntax on

" Sun Aug 21 00:05:50 CST 2011
" format codes.
set cindent
set smartindent
set tabstop=4
set shiftwidth=4
" auto change tab to 4 spaces.should avoid this in Python.
set expandtab
set autoindent
set nowrap

" Tue Aug 30 22:24:56 CST 2011 very useful in format a function or a {} block.
:nmap <S-Tab> ma=a{`a
"}

" 2012/7/16/ format codes.
" From:http://wiki.hotoo.me/Vim.html
vmap <tab> >gv
vmap <s-tab> <gv

" very important, for map leader.
let mapleader = ","

" Search the selected text quickly.From the help document.
vmap <Leader> y/<C-R>"<CR>

" no backup no swp.
set nobackup
set nowb

" see E303 can not open temp file.
set directory=.,$TEMP

" easy view codes.
set number
nnoremap <Leader>r :call ToggleRelativeNumber()<CR>
set ruler

" if is relativenumber,set it to norelativenumber or else
function! ToggleRelativeNumber()
    if &relativenumber
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction

" esay searching file.
set incsearch
set cursorline
set hlsearch
set ignorecase
" press ESC to unhilight the search results.
nnoremap <silent> <ESC> :noh<CR><ESC>

" auto read file if the file was updated.
set autoread

" make gvim to the max size when started.winsize not work in windows...
if has("win32")
    autocmd GUIEnter * simalt ~x
elseif has('unix')
    if &diff
        autocmd GUIEnter * winsize 200 999
    else
        autocmd GUIEnter * winsize 999 999
    endif
endif

" file type 2012/6/29/
au BufRead,BufNewFile *.xaml set filetype=xml

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
elseif has('gui_macvim')
    set guifont=Monaco:h14
elseif has('unix')
    set guifont=Monospace\ 13
endif

" Shift-F5 easy to change to .m/.h file.
" Thu Aug 25 17:46:04 CST 2011 use bufexists to detect the buffer exists in the buffer list.
:map <silent> <S-F5> :call ChangeToHFile()<CR>
function! ChangeToHFile()
    let filename=expand("%:r")
    let fileext=expand("%:e")
    let fileopen=""
    if s:dev_env == "iosdev"
        if fileext==?"h"
            let fileopen=filename.".m"
        else
            let fileopen=filename.".h"
        endif
    elseif s:dev_env == "csharpdev"
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

" press + to edit the current buffer directory
:map + :e %:h<CR>

" very useful,space to go to next/prev page.
:map <Space> <C-F>
:map <S-Space> <C-B>

" two ,, to escape from insert mode,back to normal mode.
" Wed Aug 24 09:05:44 CST 2011
im  ,, <ESC>

" two jj kk hh ll to escape from insert mode, back to normal mode and move the cursr.
" Wed Nov 14 10:50:29 CST 2012
im jj <ESC>j
im kk <ESC>kk
im ll <ESC>2l
im hh <ESC>h

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

" delete white space at the end of line.
command! -nargs=0 TralingSpaces silent! exec ':%s/\s\+$//g'

autocmd BufWritePre *.m TralingSpaces
autocmd BufWritePre *.h TralingSpaces
autocmd BufWritePre *.mm TralingSpaces
" autocmd BufWritePre *.xaml TralingSpaces
" autocmd BufWritePre *.cs TralingSpaces
autocmd BufWritePre *.vim TralingSpaces

" edit the current directory.
:nmap <Leader>z :call EditFileDirectory()<CR>
function! EditFileDirectory()
    let path = expand('%:p:h')
    exec ":e ". fnameescape(path)
endfunction

" load a script the current directory
function! LoadScriptName(fname)
    let fname = s:script_name . '/' . a:fname
    exec 'so '.fname
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
function! DeleteAllBuffersInWindow()
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
endfunction
command! -nargs=0 DeleteAllBuffers call DeleteAllBuffersInWindow()
let g:indent_guides_guide_size = 1

" start load self defined vim scripts.
call LoadScriptName('ReplaceSpacesWithTabs.vim')
call LoadScriptName('FilesInDir.vim')
call LoadScriptName('CommandLineCompleteFileName.vim')
" end load

" the search file patterns
if s:dev_env == "csharpdev"
    let g:SearchFileExtensions = ["cs","xaml","resw"]
    let g:SearchIgnoreDirs = ["Bin","Debug","Obj",".git",".svn"]
    let NERDTreeIgnore = ['Bin[[dir]]','Debug[[dir]]','Obj[[dir]]','.git[[dir]]','.svn[[dir]]']
elseif s:dev_env == "iosdev"
    let g:SearchFileExtensions = ["m","h","mm"]
    let g:SearchIgnoreDirs = [".git",".svn"]
    let NERDTreeIgnore = ['.git[[dir]]','.svn[[dir]]']

    " we init a new ingnored dirs for the Non Autoreleased pattern search
    let g:NonAutoreleaseAllocIgnoreDirs = []
    call extend(g:NonAutoreleaseAllocIgnoreDirs,g:SearchIgnoreDirs)
    call extend(g:NonAutoreleaseAllocIgnoreDirs,["AQGridView","ASIHTTPRequest","SBJSON"])
    command! NonAutoreleaseAlloc silent! call g:PatternInDir('/\i\+\(\s\==\s\=\[\[\i\+ alloc\)\@=/',getcwd(),g:SearchFileExtensions,g:NonAutoreleaseAllocIgnoreDirs)<CR>
endif

" search word under the cursor.
map <S-F4> :call g:PatternInDir(expand('<cword>'),getcwd(),g:SearchFileExtensions,g:SearchIgnoreDirs)<CR>
