" pathogen install
call pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on


" do not save temporary files
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp


" Remap the tab key to do autocompletion or indentation depending on the
" " context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
     let col = col('.') - 1
     if !col || getline('.')[col - 1] !~ '\k'
	return "\<tab>"
     else
        return "\<c-p>"
     endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-r>

" ,r returns to file explorer
map ,r :Rexplore<CR> 

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set textwidth=72

" show line numbers
set number


set encoding=utf-8
