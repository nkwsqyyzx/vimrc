"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This vimrc is for the command line edit file.it enumerate the
" files in the current directory.You can find the latest version:
"       http://github.com/nkwsqyyzx/vimrc/
"
" Maintainer:  wsq
" Last Change: 2013-01-09 21:17:27
" Email:       nk.wangshuangquan@gmail.com
" Version:     0.1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! -nargs=* -complete=customlist,FileNameComplete E call E(<f-args>)

let g:Files = g:FilesInDir(getcwd())

function! E(...)
  exec 'e ' . a:000[0]
endfunction

function! FileNameComplete(current_arg, command_line, cursor_position)
    let parts = split(a:command_line, '\s\+')
    if len(parts) > 2
        return FirstCompletion(parts[len(parts)-1])
    else
        return FirstCompletion()
    endif
endfunction

function! FirstCompletion(...)
    let Files = []
    let i = 0
    while i < len(g:Files)
		let line = g:Files[i]
        let parts = split(line,'[\/]')
        let filename = parts[len(parts) - 1]
        if a:0 == 1
            let regexp = a:000[0]
            let start = match(filename, regexp)
            if start > -1
                call insert(Files,line)
            endif
        else
            call insert(Files,line)
        endif
        let i += 1
    endwhile
    return Files
endfunction

