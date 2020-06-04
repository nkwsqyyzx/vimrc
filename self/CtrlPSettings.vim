if !exists(':CtrlP')
    finish
endif

nnoremap <leader>fu :CtrlPFunky<CR>
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<CR>
let g:ctrlp_funky_matchtype = 'path'
let g:ctrlp_working_path_mode = 'wra'

map <C-M> :CtrlPMRUFiles<CR>
map <leader><leader> :CtrlPBookmarkDir<CR>

function! CtrlPSrcRoot()
    let src = g:SrcRoot()
    execute ':CtrlP ' . src
endfunction
nmap <C-Z> :call CtrlPSrcRoot()<CR>

let g:ctrlp_ignore_dirs = ["build", "res", "bin", "Bin", "obj", "Obj", "debug", "Debug", "__pycache__", "gen", "drawable.\+", "\.git", "\.svn"]
let g:ctrlp_custom_ignore = ''
let s:sperator = ''
for dir in g:ctrlp_ignore_dirs
    let g:ctrlp_custom_ignore = g:ctrlp_custom_ignore . s:sperator . '\<' . dir . '\>'
    let s:sperator = '\|'
endfor

