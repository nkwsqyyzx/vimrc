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

" this function return file list in the current directory
" thanks very much for seeing the following post.I got the useful function filter/split/fnamemodify
" http://vim.wikia.com/wiki/Searching_for_files_in_a_directory_listing
function! g:FilesInDir(currentDir, ...)
    let l:SearchFileExtensions = []
    let l:SearchIgnoreDirs = []

    " the results
    let l:Files = []

    " the sub directories
    let dirs = filter(split(globpath(a:currentDir, '*'), '\n'), 'isdirectory(v:val)')
    " the files
    let files = filter(split(globpath(a:currentDir, '*'), '\n'), '!isdirectory(v:val)')

    if a:0 == 1
        call extend(l:SearchFileExtensions, a:000[0])
    elseif a:0 == 2
        call extend(l:SearchFileExtensions, a:000[0])
        call extend(l:SearchIgnoreDirs, a:000[1])
    elseif a:0 >= 3
        echo "Usage FilesInDir(dir, SearchFileExtensions, SearchIgnoreDirs)"
        return
    endif

    " add current file extension
    call insert(l:SearchFileExtensions, expand('%:p:e'))
    echo l:SearchFileExtensions

    " add files to the result list
    for fl in files
        let ext = fnamemodify(fl, ":e")
        let doadd = 0
        if empty(l:SearchFileExtensions)
            let doadd = 1
        else
            for ss in l:SearchFileExtensions
                if ss == ext
                    let doadd = 1
                endif
            endfor
        endif
        if doadd == 1
            call add(l:Files, fl)
        endif
    endfor

    " add sub directories files
    for dir in dirs
        let ignore = 0
        let lastcomponet = fnamemodify(dir, ":t")
        if !empty(l:SearchIgnoreDirs)
            for igornedDir in l:SearchIgnoreDirs
                if lastcomponet == igornedDir
                    let ignore = 1
                    break
                endif
            endfor
        endif
        if ignore == 0
            let subFiles = g:FilesInDir(dir, l:SearchFileExtensions, l:SearchIgnoreDirs)
            call extend(l:Files, subFiles)
        endif
    endfor
    return l:Files
endfunction

" search pattern in dir
function! g:PatternInDir(pattern, ...)
    " if not provided extension and dirs, use the globle settings.
    let l:SearchFileExtensions = g:SearchFileExtensions
    let l:SearchIgnoreDirs = g:SearchIgnoreDirs

    if a:0 > 0
        let l:currentDir = a:000[0]
    else
        let l:currentDir = getcwd()
    endif

    if a:0 == 2
        let l:SearchFileExtensions = a:000[1]
    elseif a:0 == 3
        let l:SearchFileExtensions = a:000[1]
        let l:SearchIgnoreDirs = a:000[2]
    elseif a:0 >= 4
        echo "Usage PatternInDir(pattern, dir, SearchFileExtensions, SearchIgnoreDirs)"
        return
    endif

    let l:Files = g:FilesInDir(l:currentDir, l:SearchFileExtensions, l:SearchIgnoreDirs)
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

function! g:SrcRoot()
    let l:olddir = 1
    let l:current = 2
    let l:modifier = ":p:h"
    let l:filedir = fnamemodify('', ':p')
    while l:olddir != l:current
        let l:olddir = l:current
        let l:currentdir = fnamemodify(l:filedir, l:modifier)
        let l:current = len(l:currentdir)
        " don't care old version svn
        if isdirectory(l:currentdir . '/.git') || isdirectory(l:currentdir . '/.svn')
            return l:currentdir . '/'
        endif
        if exists("g:SRCROOT_DETECT_FILE_LIST") && len(g:SRCROOT_DETECT_FILE_LIST) > 0
            for f in g:SRCROOT_DETECT_FILE_LIST
                if !empty(glob(l:currentdir . '/' . f))
                    return l:currentdir
                endif
            endfor
        endif
        let l:modifier = l:modifier . ":h"
    endwhile
    return ''
endfunction
