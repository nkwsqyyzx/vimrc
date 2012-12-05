"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This vimrc is most frequent used by wsq.
" You can find the latest version on:
"       http://github.com/nkwsqyyzx/vimrc/
"
" Maintainer:  wsq
" Last Change: 2012-9-25 16:12:50
" Email:       nk.wangshuangquan@gmail.com
" Version:     0.1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" default all extensions included
let s:SearchFileExtensions = []
" default all file included
let s:SearchIgnoreDirs = []

" this function return file list in the current directory
" thanks very much for seeing the following post.I got the useful function filter/split/fnamemodify
" http://vim.wikia.com/wiki/Searching_for_files_in_a_directory_listing
function! g:FilesInDir(currentDir,...)
    let s:SearchFileExtensions = []
    let s:SearchIgnoreDirs = []

    " the results
    let l:Files=[]

    " the sub directories
    let dirs = filter(split(globpath(a:currentDir, '*'), '\n'), 'isdirectory(v:val)')
    " the files
    let files = filter(split(globpath(a:currentDir, '*'), '\n'), '!isdirectory(v:val)')

    if a:0 == 1
        let s:SearchFileExtensions = a:000[0]
    elseif a:0 == 2
        let s:SearchFileExtensions = a:000[0]
        let s:SearchIgnoreDirs = a:000[1]
    elseif a:0 >= 3
        echo "Usage FilesInDir(dir,SearchFileExtensions,SearchIgnoreDirs)"
        return
    endif

    " add files to the result list
    for fl in files
        let ext = fnamemodify(fl,":e")
        let doadd = 0
        if empty(s:SearchFileExtensions)
            let doadd = 1
        else
            for ss in s:SearchFileExtensions
                if ss == ext
                    let doadd = 1
                endif
            endfor
        endif
        if doadd == 1
            call add(l:Files,fl)
        endif
    endfor

    " add sub directories files
    for dir in dirs
        let ignore = 0
        let lastcomponet = fnamemodify(dir,":t")
        if !empty(s:SearchIgnoreDirs)
            for igornedDir in s:SearchIgnoreDirs
                if lastcomponet == igornedDir
                    let ignore = 1
                    break
                endif
            endfor
        endif
        if ignore == 0
            let subFiles = g:FilesInDir(dir,s:SearchFileExtensions,s:SearchIgnoreDirs)
            call extend(l:Files,subFiles)
        endif
    endfor
    return l:Files
endfunction

" search pattern in dir
function! g:PatternInDir(pattern,...)
    " if not provided extension and dirs,use the globle settings.
    let s:SearchFileExtensions = g:SearchFileExtensions
    let s:SearchIgnoreDirs = g:SearchIgnoreDirs

    if a:0 > 0
        let l:currentDir=a:000[0]
    else
        let l:currentDir=getcwd()
    endif

    if a:0 == 2
        let s:SearchFileExtensions = a:000[1]
    elseif a:0 == 3
        let s:SearchFileExtensions = a:000[1]
        let s:SearchIgnoreDirs = a:000[2]
    elseif a:0 >= 4
        echo "Usage PatternInDir(pattern,dir,SearchFileExtensions,SearchIgnoreDirs)"
        return
    endif

    let l:Files = g:FilesInDir(l:currentDir,s:SearchFileExtensions,s:SearchIgnoreDirs)
    call setqflist([])
    for fl in l:Files
        silent! execute ":vimgrepadd " a:pattern . " " . fl
    endfor

    " open the error list if we has search results.
    if !empty(getqflist())
        cwindow
    else
        echo a:pattern . " has no results."
    endif
endfunction
