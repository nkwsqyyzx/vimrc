" add tag to tag search path
function! s:AddTag(path)
    let cp = fnamemodify(a:path,':p:h')
    let p = fnamemodify(cp,':p:h') . '/tags'
    if filereadable(p) && index(split(&tags,','),p) < 0
        let &tags = &tags . ',' . p
    endif
    let pp = fnamemodify(cp,':p:h:h')
    if cp != pp
        call s:AddTag(pp)
    endif
endfunction

autocmd BufEnter *.java call s:AddTag('.')
autocmd BufEnter *.c call s:AddTag('.')
autocmd BufEnter *.cpp call s:AddTag('.')

" yankring
let g:yankring_history_file = '.yankring_history_file'

let g:pymode_lint_ignore = "E128"

map <C-M> :CtrlP<CR>

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v(\.(git|svn)|((bin|gen|[oO]bj|[dD]ebug|__pycache__|drawable.+)[/\]))',
  \ 'file': '\v\.(class|exe|so|dll)$',
  \ }


let g:NERDTreeIgnore = []
" common dot files
call extend(g:NERDTreeIgnore,['.git[[dir]]'])
call extend(g:NERDTreeIgnore,['.svn[[dir]]'])
" C#/CPP project build files
call extend(g:NERDTreeIgnore,['^bin$[[dir]]'])
call extend(g:NERDTreeIgnore,['obj[[dir]]'])
call extend(g:NERDTreeIgnore,['Obj[[dir]]'])
call extend(g:NERDTreeIgnore,['Debug[[dir]]'])
" python project
call extend(g:NERDTreeIgnore,['__pycache__[[dir]]'])
call extend(g:NERDTreeIgnore,['.pyc[[file]]'])
" android NERDTree setting
call extend(g:NERDTreeIgnore,['^.settings$[[dir]]'])
call extend(g:NERDTreeIgnore,['^drawable.\+[[dir]]'])
call extend(g:NERDTreeIgnore,['^exlibs$[[dir]]'])
call extend(g:NERDTreeIgnore,['^gen$[[dir]]'])
call extend(g:NERDTreeIgnore,['^libs$[[dir]]'])
