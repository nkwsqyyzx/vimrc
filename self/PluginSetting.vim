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

" android NERDTree setting
let NERDTreeIgnore=['^libs$[[dir]]','^exlibs$[[dir]]','^.settings$[[dir]]' , '^bin$[[dir]]', '^gen$[[dir]]','^drawable.\+[[dir]]',  ]

" yankring
let g:yankring_history_file = '.yankring_history_file'
