"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This file was written to complete filename in command line.
"
" Thanks Yuheng Xie <xie_yuheng@yahoo.com.cn> very much because
" I get most codes from his cmdline-complete.vim script at url:
" http://www.vim.org/scripts/script.php?script_id=2222
"
" You can find the latest version on:
"       http://github.com/nkwsqyyzx/vimrc/
"
" Maintainer:  wsq
" Last Change: 2013-01-10 11:00:49
" Email:       nk.wangshuangquan@gmail.com
" Version:     0.1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Anti reinclusion guards
if exists('g:loaded_cmdline_complete') && !exists('g:force_reload_cmdline_complete')
	finish
endif

" Support for |line-continuation|
let s:save_cpo = &cpo
set cpo&vim

" Default bindings

if !hasmapto('<Plug>CmdLineFileNameBackward', 'c')
	cmap <unique> <silent> <c-up> <Plug>CmdLineFileNameBackward
endif
if !hasmapto('<Plug>CmdLineFileNameForward', 'c')
	cmap <unique> <silent> <c-down> <Plug>CmdLineFileNameForward
endif

cnoremap <silent> <Plug>CmdLineFileNameBackward <c-r>=<sid>CmdLineFileName(1)<cr>
cnoremap <silent> <Plug>CmdLineFileNameForward  <c-r>=<sid>CmdLineFileName(0)<cr>

" Functions

" define variables if they don't exist
function! s:InitVariables()
	if !exists("s:seed")
        " make file list global so we can check it when needed
        let g:FilesForEditing = g:FilesInDir(getcwd(),g:SearchFileExtensions,g:SearchIgnoreDirs)
		let s:seed = ""
		let s:completions = [""]
		let s:completions_set = {}
		let s:comp_i = 0
        let s:search_cursor = [0,1,0,0]
		let s:sought_bw = 0
		let s:sought_fw = 0
		let s:last_cmdline = ""
		let s:last_pos = 0
	endif
endfunction

" generate completion list
function! s:GenerateCompletions(seed, back)
	let regexp = '\<' . a:seed . '\k\+'
	if empty(a:seed)
		let regexp = '\<\k\k\+'
	elseif a:seed =~ '\K'
		let regexp = '\<\(\V' . a:seed . '\)\k\+'
	endif
	if &ignorecase && !(&smartcase && a:seed =~ '\C[A-Z]')
		let regexp = '\c' . regexp
	endif

	" backup 'ignorecase', do searching with 'noignorecase'
	let save_ignorecase = &ignorecase
	set noignorecase

	let r = []
	if s:sought_bw < s:search_cursor[1]
		let r1 = s:search_cursor[1] - s:sought_bw
		let r2 = 1
		if s:sought_fw > len(g:FilesForEditing) - s:search_cursor[1] + 1
			let r2 = s:sought_fw - len(g:FilesForEditing) + s:search_cursor[1]
		endif
		if a:back
			let r = [r1, r2]
		else
			let r = [r2, r1]
		endif
	endif
	if s:sought_fw < len(g:FilesForEditing) - s:search_cursor[1] + 1
		let r1 = len(g:FilesForEditing)
		let r2 = s:search_cursor[1] + s:sought_fw
		if s:sought_bw > s:search_cursor[1]
			let r1 = len(g:FilesForEditing) - s:sought_bw + s:search_cursor[1]
		endif
		if a:back
			let r = r + [r1, r2]
		else
			let r = [r2, r1] + r
		endif
	endif

	while len(r)
        if r[0] == len(g:FilesForEditing)
            break
        endif
		let candidates = []
		let line = g:FilesForEditing[r[0]]
		let start = match(line, regexp)
		while start != -1
			let candidate = matchstr(line, '\k\+', start)
			let next = start + len(candidate)
			if r[0] != s:search_cursor[1]
					\ || a:back && (!s:sought_bw && start < s:search_cursor[2]
						\ || s:sought_bw && start >= s:search_cursor[2])
					\ || !a:back && (s:sought_fw && next < s:search_cursor[2]
						\ || !s:sought_fw && next >= s:search_cursor[2])
				call add(candidates, line)
                break
			endif
			let start = match(line, regexp, next)
		endwhile

		let found = 0

		if !empty(candidates)
			if a:back
				let i = len(candidates) - 1
				while i >= 0
					if !has_key(s:completions_set, candidates[i])
						let s:completions_set[candidates[i]] = 1
						call insert(s:completions, candidates[i])
						let s:comp_i = s:comp_i + 1
						let found = 1
					endif
					let i = i - 1
				endwhile
			else
				let i = 0
				while i < len(candidates)
					if !has_key(s:completions_set, candidates[i])
						let s:completions_set[candidates[i]] = 1
						call add(s:completions, candidates[i])
						let found = 1
					endif
					let i = i + 1
				endwhile
			endif
		endif

		if a:back
			let s:sought_bw += 1
		else
			let s:sought_fw += 1
		endif

		if found
			break
		endif

		if r[1] > r[0]
			let r[0] += 1
		elseif r[1] < r[0]
			let r[0] -= 1
		else
			call remove(r, 0, 1)
		endif
	endwhile

	" restore 'ignorecase'
	let &ignorecase = save_ignorecase

	return 1
endfunction

" return next completion, to be used in c_CTRL-R =
function! s:CmdLineFileName(back)
	" define variables if they don't exist
	call s:InitVariables()

	let cmdline = getcmdline()
	let pos = getcmdpos()

	" if cmdline, cmdpos or cursor changed since last call,
	" re-generate the completion list
	if cmdline != s:last_cmdline || pos != s:last_pos
		let s:last_cmdline = cmdline
		let s:last_pos = pos

		let s = match(strpart(cmdline, 0, pos - 1), '\k*$')
		let s:seed = strpart(cmdline, s, pos - 1 - s)
		let s:completions = [s:seed]
		let s:completions_set = {}
		let s:comp_i = 0
        let s:search_cursor = [0,1,0,0]
		let s:sought_bw = 0
		let s:sought_fw = 0
	endif

	if s:sought_bw + s:sought_fw <= len(g:FilesForEditing) && (
			\  a:back && s:comp_i == 0 ||
			\ !a:back && s:comp_i == len(s:completions) - 1)
       call s:GenerateCompletions(s:seed, a:back)
	endif

	let old = s:completions[s:comp_i]

	if a:back
		if s:comp_i == 0
			let s:comp_i = len(s:completions) - 1
		else
			let s:comp_i = s:comp_i - 1
		endif
	else
		if s:comp_i == len(s:completions) - 1
			let s:comp_i = 0
		else
			let s:comp_i = s:comp_i + 1
		endif
	endif

	let new = s:completions[s:comp_i]

	" remember the last cmdline, cmdpos and cursor for next call
	let s:last_cmdline = strpart(s:last_cmdline, 0, s:last_pos - 1 - strlen(old))
			\ . new . strpart(s:last_cmdline, s:last_pos - 1)
	let s:last_pos = s:last_pos - len(old) + len(new)

	" feed some keys to overcome map-<silent>
	call feedkeys(" \<bs>")

	return substitute(old, ".", "\<c-h>", "g") . new
endfunction
