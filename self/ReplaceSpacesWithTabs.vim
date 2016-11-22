"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This script is useful for replace spaces between tabs.
" You can find the latest version on:
"       http://github.com/nkwsqyyzx/vimrc/
"
" Maintainer:  wsq
" Last Change: 2012-8-14 11:18:05
" Email:       nk.wangshuangquan@gmail.com
" Version:     0.1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! ReplaceSpacesWithTabs(string, spaceToTab, tabstop)
    let mpattern = '^\s\+'
    let str = matchstr(a:string, mpattern)
    if strlen(str) == 0
        return [1, '']
    endif

    " get the second part.
    let secondpart = strpart(a:string, strlen(str))

    if a:spaceToTab == 1
        let rpattern = '\t'
    elseif a:spaceToTab == 0
        let rpattern = repeat(' ', a:tabstop)
    elseif
        "echo 'you have a invalid parameter spaceToTab, it should be 0 or 1.'
        return [1, '']
    endif

    let tabspaces = repeat(' ', a:tabstop)
    let spaces = substitute(str, '\t', tabspaces, 'g')
    let spacescount = strlen(spaces)
    let success = spacescount - (spacescount / a:tabstop) * a:tabstop

    if success == 0
        if a:spaceToTab == 1
            let tabs = substitute(spaces, tabspaces, '\t', 'g')
            let result = tabs . secondpart
        else
            let result = spaces . secondpart
        endif
        return [0, result]
    else
        return [2, '']
    endif
endfunction

" format current buffer use self defined tabstop
function! FormatBuffer(spaceToTab, tabstop)
    let line = 1
    while line <= line('$')
        let [ok, result] = ReplaceSpacesWithTabs(getline(line), a:spaceToTab, a:tabstop)
        if ok <= 0
            call setline(line, result)
        endif
        let line = line + 1
    endwhile
endfunction

" change spaces to tabs use the default tabstop
" usage:call SpacesToTabs()
function! SpacesToTabs()
    call FormatBuffer(1, &tabstop)
endfunction

" change tabs to spaces use the default tabstop
" usage:call TabsToSpaces()
function! TabsToSpaces()
    call FormatBuffer(0, &tabstop)
endfunction
