" ftplugin/markdown.vim - maps for Markdown files
" Maintainer:   Jeff Pitblado <jpitblado at stata.com>
" Last Change:  25jun2019

if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" run my Markdown to HTML script (uses pandoc)
nnoremap <buffer> <localleader>mh :! m2h.sh %<cr>

" end: ftplugin/markdown.vim
