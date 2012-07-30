" 配置文件的文件名
let $f=expand('%:')

" 设置文件类型 2012年6月29日
au BufRead,BufNewFile *.xaml set filetype=xml

filetype on

" 常用工程文件路径配置
let workPath='d:\work\baidumap_wp7\trunk\Com.Baidu.Map\'
exec "cd ".workPath

set backspace=indent,eol,start whichwrap+=<,>,[,]
set fileencodings=utf-8,gb2312,gbk,gb18030,ucs-bom,default,chinese
syntax on

if filereadable('c:\private.vim')
    source c:\private.vim
endif

" Sun Aug 21 00:05:50 CST 2011
" 在使用gg＝G格式化代码时更方便智能。
" C语音格式的自动缩进
set cindent
set tabstop=4
set shiftwidth=4
set colorcolumn=81
" 自动将tab键转换为4个空格
set expandtab
set autoindent

" Mon Aug 29 23:11:06 CST 2011 有感于代码格式化总进行重复操作，创建
" Tue Aug 30 22:24:56 CST 2011 有感于格式化后光标乱跑，加一个标签，格式化后返回到原来的位置。
" Shift-Tab设置为自动格式化一个函数块;
:nmap <S-Tab> ma=a{`a
"}

" 2012年7月16日 快速格式化代码
" From:http://wiki.hotoo.me/Vim.html
nmap <tab> v>
vmap <tab> >gv
vmap <s-tab> <gv

" 禁用备份
set nobackup
" 禁用swp文件 记得实时写入
set nowb

" 解决E303 不能打开临时文件的问题
set directory=.,$TEMP

" 设置行号
set number

" 设置下方标尺
set ruler

" 搜索设置
set incsearch
set hlsearch
set ignorecase
" 按ESC键取消搜索高亮，同时指定<silent>选项不在命令行显示:noh
nnoremap <silent> <ESC> :noh<CR><ESC>

" 设置path变量，用于结构化的项目之中的跳转和find
" set path +=.,../,../*/,../*/*/,../*/*/*/,../../*/
set path+=.\*\,.\*\*\,.\*\*\*\
" set path=,,

" 当文件被外部程序更改时自动读取
set autoread

" 启动时自动最大化
autocmd GUIEnter * simalt ~x

" 设置mapleader
let mapleader = ","

" CTRL－t用在tags中
" :nmap <C-t> :tabnew<CR>
" Mon Sep 19 10:49:18 CST 2011
:nmap <Leader>t :tabnew<CR>
:imap <C-t> <C-o>:tabnew<CR>

" Tue Sep 27 09:07:03 CST 2011 tab导航，1第一个，4最后一个
:nmap <Leader>1 :tabfirst<CR>
:nmap <Leader>2 :tabprevious<CR>
:nmap <Leader>3 :tabnext<CR>
:nmap <Leader>4 :tablast<CR>

" Wed Dec 21 17:19:37 CST 2011 MiniBufExplorer使用的按键绑定
:nmap <silent> <Leader>y :TMiniBufExplorer<CR>

" Tue Sep 27 10:51:41 CST 2011 退出所有
:nmap <Leader>Q :qall<CR>

:nmap <Leader>ss :source %<CR>

" 在搜索结果中快速移动
:nmap <S-F3> :cnext<CR>
:nmap <S-F1> :cNext<CR>

" 从剪贴板粘贴数据
" 由于CTRL－V在普通模式下是块操作必须的按键，于是在此模式下使用<Leader>v来粘贴 Tue Sep 13 16:33:43 CST 2011
:nmap <Leader>v "*p
:imap <C-v> <C-o>"*p
:imap <Leader>v <C-r>"*

" Fri Oct 28 09:25:26 CST 2011
" 新增加在buffer中切换的快捷键
:nmap <Leader>n :bNext<CR>
:nmap <Leader>p :bprevious<CR>
:nmap <C-tab> :bNext<CR>
:nmap <C-S-tab> :bprevious<CR>

:nmap <C-l> <C-w><C-l>
:nmap <C-h> <C-w><C-h>
:nmap <C-j> <C-w><C-j>
:nmap <C-k> <C-w><C-k>

:nmap <A-j> ]c
:nmap <A-k> [c

" Tue Sep 13 16:34:01 CST 2011
" 新增保存文件的快捷键
:nmap <Leader>w :w<CR>

" Wed Sep 14 09:54:35 CST 2011
" 新增退出编辑的快捷键
:nmap <Leader>q :bd<CR>

" Tue Sep 13 16:34:01 CST 2011
" 新增删除所有行的快捷键
:nmap <Leader>d :%d<CR>

" 跳到当前文件的目录
:nmap <Leader>Z :call ChangeToDirectory()<CR>

" 编辑当前文件的目录
:nmap <Leader>z :call EditFileDirectory()<CR>

" Wed Sep 14 14:41:51 CST 2011
" 新增加折叠代码的快捷键
:nmap <Leader>f zfa}

" Thu Aug 25 08:51:46 CST 2011
" 数据复制到剪贴板
:vmap <C-x> "*d
:vmap <C-c> "*y

" gui字体
if has('win32')
    set guifont=Courier_New:h13:cANSI
else
    set guifont=Monaco:h14
endif

" 搜索光标下的单词
map <S-F4> :call Search_Word()<CR>:copen<CR>
function! Search_Word()
let w = expand("<cword>") " 在当前光标位置抓词
silent execute ":vimgrep " w " **/*.cs **/*.xaml *.cs *.xaml"
endfunction

" Shift-F5 切换到对应的m文件或h文件。写ios程序专用。
" Thu Aug 25 17:46:04 CST 2011 此版本在连续切换多次后会失效。不知为何。使用的是bufexists判断文件是否被加载；
" Sun Aug 28 23:18:55 CST 2011 经过易水博客的提点，问题变得简单了许多；
" 问题：如果不停的按，将会打开多次。这个问题很严重，啊啊啊。
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

" 一般模式下，将Space映射为向下翻页
" 一般模式下，将Shift-Space映射为向上翻页
:map <Space> <C-F>
:map <S-Space> <C-B>

" 插入模式下，两个连续的,,被映射为Esc，即回到Normal模式
" Wed Aug 24 09:05:44 CST 2011
im  ,, <ESC>

" 将dc映射为关闭下一个窗口页，一般是不常用的，如quickfix页或者临时查看文件的页。
:nmap <silent> dc <C-W><C-W>:close<CR>

" Sun Aug 28 23:20:58 CST 2011 from易水博客 在文件之中切换
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

" 编辑当前文件的目录
:nmap <Leader>z :call EditFileDirectory()<CR>
function! EditFileDirectory()
    let path = expand('%:p:h')
    exec ":e ". fnameescape(path)
endfunction

" 跳到当前文件的目录
:nmap <Leader>Z :call ChangeToDirectory()<CR>
function! ChangeToDirectory()
    let path = expand('%:p:h')
    exec ":e ". fnameescape(path)
    exec ":cd ". fnameescape(path)
endfunction

" 将command执行的结果导出到文件
function! TabMessage(cmd)
    redir => message
    silent execute a:cmd
    redir END
    tabnew
    silent put=message
    set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

" 2012年6月5日添加 删除当前buffer外的所有buffer
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
