set nocompatible

filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'derekwyatt/vim-scala'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'briandoll/change-inside-surroundings.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'tpope/vim-markdown.git'
Plugin 'avakhov/vim-yaml.git'
Plugin 'markcornick/vim-terraform'
Plugin 'kchmck/vim-coffee-script'
Plugin 'fatih/vim-go'
" All of your Plugins must be added before the following line
call vundle#end()            " required



syntax on
filetype plugin indent on

" fix madness with rbenv
set shell=/bin/bash

" do not save temporary files
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp


let mapleader=","

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


" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

"autocmd VimEnter * RainbowParenthesesToggle
"autocmd VimEnter * RainbowParenthesesLoadRound
"autocmd VimEnter * RainbowParenthesesLoadSquare
"autocmd VimEnter * RainbowParenthesesLoadBraces

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

"set textwidth=72
"set formatoptions-=c

" ,r returns to file explorer
map ,r :Rexplore<CR> 

" turn on and off search highlighting
map ,s :set hlsearch!<CR>

" go to next nd previous buffer
map ,b :bp<CR>
map ,n :bn<CR>

"move lines up and down
map - ddp
map _ ddkP

"make current word uppercase
imap <c-u> <esc>viwUea
set encoding=utf-8

"edit my vimrc-file
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
syntax enable
set t_Co=256
set background=dark
colorscheme grb256

" show line numbers
set number
" disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" navigate splits with c-hjkl
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  if match(a:filename, '\.feature$') != -1
    exec ":!script/features " .  a:filename
  else
    if filereadable("script/test")
      exec ":!script/test " .  a:filename
    elseif filereadable("Gemfile")
      exec ":!bundle exec rspec --color " .  a:filename
    else
      exec ":!rspec --color " .  a:filename
    end
  end
endfunction

function! SetTestFile()
  "  Set  the  spec  file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif
  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file .  command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" .  spec_line_number . " -b")
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>


map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
" map <leader>l :w\|:!script/features<cr>
" map <leader>w :w\|:!script/features --profile wip<cr>
