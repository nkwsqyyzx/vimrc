if !exists(':Leaderf')
    finish
endif

let g:Lf_ShowDevIcons = 0

nnoremap <leader>fu :LeaderfLine<CR>
nnoremap <Leader>fU :execute 'Leaderf line --cword'<CR>

map <C-M> :Leaderf mru<CR>
map <leader><leader> :Leaderf self<CR>

function! CtrlPSrcRoot()
    let src = g:SrcRoot()
    execute ':LeaderfFile ' . src
endfunction
nmap <C-Z> :execute CtrlPSrcRoot()<CR>
