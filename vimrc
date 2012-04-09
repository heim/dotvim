" pathogen install
call pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on


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

" ,r returns to file explorer
map ,r :Rexplore<CR> 

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

"set textwidth=72
"set formatoptions-=c
" show line numbers
set number

" turn on and off search highlighting
map ,s :set hlsearch!<CR>

" go to next nd previous buffer
map ,b :bp<CR>
map ,n :bn<CR>

set encoding=utf-8


syntax enable
set t_Co=256
set background=dark
colorscheme grb256

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

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
" map <leader>l :w\|:!script/features<cr>
" map <leader>w :w\|:!script/features --profile wip<cr>
