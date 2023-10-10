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
" requires Pane Relief: https://github.com/pjeby/pane-relief
exmap tabnext obcommand pane-relief:go-next
nmap tl :tabnext
exmap tabprev obcommand pane-relief:go-prev
nmap th :tabprev

" Vim-like pane moving
exmap focusRight obcommand editor:focus-right
exmap focusLeft obcommand editor:focus-left
exmap focusTop obcommand editor:focus-top
exmap focusBottom obcommand editor:focus-bottom
nmap <C-w>l :focusRight
nmap <C-w>h :focusLeft
nmap <C-w>k :focusTop
nmap <C-w>j :focusBottom
nmap <C-w><C-l> :focusRight
nmap <C-w><C-h> :focusLeft
nmap <C-w><C-k> :focusTop
nmap <C-w><C-j> :focusBottom

" :wq and :q to close
exmap wq obcommand workspace:close
exmap q obcommand workspace:close

" Follow link under cursor
exmap followLinkUnderCursor obcommand editor:follow-link
nmap go :followLinkUnderCursor
exmap goBack obcommand app:go-back
nmap <C-o> :goBack
exmap goForward obcommand app:go-forward
nmap <C-i> :goForward

" Split pane
exmap vsplit obcommand workspace:split-vertical
exmap vsp obcommand workspace:split-vertical
exmap hsplit obcommand workspace:split-horizontal
exmap split obcommand workspace:split-horizontal
exmap sp obcommand workspace:split-vertical
