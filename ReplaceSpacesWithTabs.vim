" switch the space and tab
	" test line. it is a tab.
	 " test line. it is a tab and a space.

function! ReplaceSpacesWithTabs(string,spaceToTab,tabstop)
    let mpattern = '^\s\+'
    let str = matchstr(a:string,mpattern)
    if strlen(str) == 0
        return
    endif
    if a:spaceToTab == 1
        let rpattern = '\t'
    elseif a:spaceToTab == 0
        let rpattern = repeat(' ',a:tabstop)
    elseif
        echo 'you have a invalid parameter spaceToTab,it should be 0 or 1.'
        return
    endif

    let tabspaces = repeat(' ',a:tabstop)
    
    let ret = substitute(a:string,'\t',tabspaces,'g')
    echo 'result is:'.ret


endfunction

function! Test()
    let line = 1
    while line <= line('$')
        call ReplaceSpacesWithTabs(getline(line),0,4)
        let line = line + 1
    endwhile
endfunction
