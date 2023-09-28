nmap j gj
nmap k gk
vnoremap v $h
nmap <Esc><Esc> :nohlsearch<CR>

" Yank to system clipboard
set clipboard=unnamed

exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }

" NOTE: must use 'map' and not 'nmap'
map [[ :surround_wiki
nunmap s
vunmap s
map s" :surround_double_quotes
map s' :surround_single_quotes
map s` :surround_backticks
map sb :surround_brackets
map s( :surround_brackets
map s) :surround_brackets
map s[ :surround_square_brackets
map s[ :surround_square_brackets
map s{ :surround_curly_brackets
map s} :surround_curly_brackets

" Emulate Tab Switching https://vimhelp.org/tabpage.txt.html#gt
" requires Cycle Through Panes Plugins https://obsidian.md/plugins?id=cycle-through-panes
exmap tabnext obcommand cycle-through-panes:cycle-through-panes
nmap tl :tabnext
exmap tabprev obcommand cycle-through-panes:cycle-through-panes-reverse
nmap th :tabprev

" Vim-like pane moving
exmap focusRight obcommand editor:focus-right
nmap <C-w>l :focusRight
exmap focusLeft obcommand editor:focus-left
nmap <C-w>h :focusLeft
exmap focusTop obcommand editor:focus-top
nmap <C-w>k :focusTop
exmap focusBottom obcommand editor:focus-bottom
nmap <C-w>j :focusBottom
