if !exists(':Leaderf')
    finish
endif

let g:Lf_ShowDevIcons = 0

nnoremap <leader>fu :LeaderfLine<CR>
nnoremap <Leader>fU :execute 'Leaderf line --cword'<CR>
nnoremap zz :execute 'Leaderf line --cword'<CR>

map <C-M> :Leaderf mru<CR>
map <leader><leader> :Leaderf self<CR>

function! CtrlPSrcRoot()
    let src = g:SrcRoot()
    execute ':LeaderfFile ' . src
endfunction
nmap <C-Z> :execute CtrlPSrcRoot()<CR>

noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
noremap <leader>f0 :<C-U><C-R>=printf("Leaderf gtags --all")<CR><CR>
