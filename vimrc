" .vimrc
"Pathogen
call pathogen#infect()

"============== Filetype stuff ===============
filetype plugin on
filetype indent on


" Load custom settings

" Color Settings
" color wombat256
"color xterm16
" color railscasts
" color molokai
" color skittles_dark
set background=dark
" set background=light
color skittles_berry
" color desert_my
" color badwolf
" let g:solarized_termcolors=256
" color solarized

" """ FocusMode
" function! ToggleFocusMode()
" 	if (&foldcolumn != 12)
" 		set laststatus=0
" 		set numberwidth=10
" 		set foldcolumn=12
" 		set noruler
" 		hi FoldColumn ctermbg=none
" 		hi LineNr ctermfg=0 ctermbg=none
" 		hi NonText ctermfg=0
" 	else
" 		set laststatus=2
" 		set numberwidth=4
" 		set foldcolumn=0
" 		set ruler
" 		colorscheme skittles_berry "re-call your colorscheme
" 	endif
" endfunc

""""""""""""""""""""""""""""""
" Visual
""""""""""""""""""""""""""""""
" From an idea by Michael Naumann
function! VisualSearch(direction) range
	let l:saved_reg = @"
	execute "normal! vgvy"
	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")
	if a:direction == 'b'
		execute "normal ?" . l:pattern . "^M"
	else
		execute "normal /" . l:pattern . "^M"
	endif
	let @/ = l:pattern
	let @" = l:saved_reg
endfunction

func! WriteFormat()
	:%s/\v[^[:print:]]*$//g
	:%s/\v\s*$//g
endfunc

func! EnterHandler()
	exe "source ".g:autoSessionFile
	exe "rviminfo ".g:autoViminfoFile
	if filereadable("tags")
		set tags+=tags
	endif
	if filereadable(".projectx.vim")
		exe "source .projectx.vim"
	endif
endfunction
func! LeaveHandler()
	exec "NERDTreeClose"
	exec "mks! ".g:origPwd."/".g:autoSessionFile
	exec "wviminfo! ".g:origPwd."/".g:autoViminfoFile
endfunction

command! BcloseOthers call <SID>BufCloseOthers()  
function! <SID>BufCloseOthers()  
	let l:currentBufNum   = bufnr("%")  
	let l:alternateBufNum = bufnr("#")  
	for i in range(1,bufnr("$"))  
		if buflisted(i)  
			if i!=l:currentBufNum  
				execute("MBEbw ".i)  
			endif  
		endif  
	endfor  
endfunction


"============== General Settings ===============
"Get out of VI's compatible mode..
set nocompatible
let g:mapleader = ","
"let mapleader = '\'
set dict=/usr/share/dict/words
"set cursorline
" setlocal spell spelllang=en_us
set showcmd
set ruler
set incsearch
set wildmenu
syntax on
set synmaxcol=0
"set term=xterm-256color
set shortmess=aAIsT
set cmdheight=2
set nowrap
let &scrolloff=999-&scrolloff
set smartcase
set autoread                    " read open files again when changed outside Vim
set autowrite

" set hidden
" set completeopt=preview
set completeopt=menu
set mousemodel=popup
set backspace=indent,eol,start  " backspacing over everything in insert mode
set wildignore+=*.bak,*.o,*.e,*~,*/tmp/*,*.so,*.swp,*.zip " wildmenu: ignore these extensions
set number
set cinoptions+=g0

set enc=utf-8
" Chinese
" multi-encoding setting
if has("multi_byte")
  "set bomb 
  set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,sjis,euc-kr,ucs-2le,latin1 
  " CJK environment detection and corresponding setting 
  if v:lang =~ "^zh_CN" 
    " Use cp936 to support GBK, euc-cn == gb2312 
    set encoding=chinese 
    set termencoding=chinese 
    set fileencoding=chinese 
  endif 
  " Detect UTF-8 locale, and replace CJK setting if needed 
  if v:lang =~ "utf8$" || v:lang =~ "UTF-8$" 
    set encoding=utf-8 
    set termencoding=utf-8 
    set fileencoding=utf-8 
  endif 
endif 
set fileformat=unix
" set fillchars=vert:|

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab

set linespace=0
set history=1000

set laststatus=2
set ffs=unix,dos
if has("gui_running")
    if has("win32")
        set guifont=Courier\ New:h12
    else
        set guifont=Monospace\ 13
        set mouse=a
        set guioptions-=T
        "set guioptions-=m
    endif
endif

"set wrap

"if version > 720
"	set undofile
"	set undodir=~/vimundo/
"endif

"Do not redraw, when running macros.. lazyredraw
set lz

"Highlight search things
set hlsearch

"Set magic on
set magic

"show matching bracets
set showmatch

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
set sessionoptions-=curdir
set sessionoptions+=sesdir

"Turn backup off
set nobackup
set nowb
set noswapfile

"Enable folding, I find it very useful
set fen
set fdl=0
"set foldmethod=indent

"C-style indeting
set cindent

set previewheight=10
" set splitbelow

if has("win32")
    let g:tagbar_ctags_bin = 'F:\Program\ Files\Vim\vim74\ctags.exe'
endif

" airline setting
let g:airline_left_sep=''
let g:airline_right_sep=''

" NERDTree setting
let NERDTreeMinimalUI=1
let NERDTreeChDirMode=1
let NERDTreeWinPos = "left"
if has("win32")
    let NERDTreeDirArrows = 0
else
    let NERDTreeDirArrows=1
endif

let g:EasyMotion_leader_key = '<Leader>'

" let g:loaded_youcompleteme=1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_auto_start_csharp_server = 0
let g:ycm_key_invoke_completion = '<Alt-/>'
" let g:curWorkingDir=getcwd()
let g:ycm_global_ycm_extra_conf = '.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_always_populate_location_list = 1

let g:loaded_syntastic_plugin = 1

let g:syntastic_auto_jump = 2

let g:syntastic_c_checkers = ['make']
let g:syntastic_cpp_checkers = ['gcc']
let g:syntastic_check_on_open = 1
"
" auto save and load session and viminfo
let g:autoSessionFile=".project.vim"
let g:autoViminfoFile=".project.viminfo"
let g:origPwd=getcwd()
if filereadable(g:autoSessionFile) && filereadable(g:autoViminfoFile)
	if argc() == 0
		au VimEnter * call EnterHandler()
		au VimLeave * call LeaveHandler()
	endif
endif

autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo

let g:did_UltiSnips_plugin=1
let g:UltiSnipsExpandTrigger="<C-f>"
let g:UltiSnipsJumpForwardTrigger="<C-f>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
let g:UltiSnipsSnippetDirectories=["mySnippets"]

" let g:tagbar_show_linenumbers = 1
" let g:tagbar_autopreview = 1

" let g:indentLine_color_gui = '#A4E57E'
" let g:indentLine_color_term = 239
let g:indentLine_loaded=1

"Eclim
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimLocationListHeight=5
" let g:EclimJavaSearchSingleResult='lopen'
" let g:EclimJavaDocSearchSingleResult='lopen'


" make type colon easily 
no ; :

"Fast remove highlight search
nmap <silent> <leader>nh :noh<cr>

" move current line
nno <C-Down> ddp
nno <C-Up> ddkP

" fast save
nmap <silent><leader>s :w<CR>
nmap <silent><leader><leader>wf :call WriteFormat()<cr>:w<cr>

"============== Custom Mappings ===============
" general mapping
nno <Leader>h :tabprevious<CR>
nno <Leader>l :tabnext<CR>
nmap <Leader>tn :tabnew %:p<CR>
nmap <leader>tc :tabclose<CR>

" diff
nmap ]c ]czz
nmap [c [czz

" default to very magic
"no / /\v

" gO to create a new line below cursor in normal mode
nmap go O<ESC>jo<ESC>k

"I really hate that things don't auto-center
nmap G Gzz
nmap n nzz
nmap N Nzz
nmap } }zz
nmap { {zz

"open tag in new tab
map <leader><C-]> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

"noremap <F1> :call ToggleFocusMode()<cr>

"Smart way to move btw. windows
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l
" nmap <C-C> <C-W>c

nmap <silent> <leader>tl :TlistToggle<cr>

nnoremap <silent> <leader>tb :TagbarToggle<CR>

nmap <silent> <Leader>mt :MBEToggle<cr>

" NERDTree setting
nnoremap <silent> <leader>nt :NERDTreeToggle<cr>
nnoremap <silent> <leader>nf :NERDTreeFind<CR>

if has("win32")
    noremap <silent> <leader>vr :e $VIM/_vimrc<CR>
else
    nnoremap <silent> <leader>vr :e ~/.vimrc<CR>
endif

""""""""""""""""""""""""""""""
" mark setting
""""""""""""""""""""""""""""""
" nmap <silent> <leader>ms <Plug>MarkSet
" vmap <silent> <leader>ms <Plug>MarkSet
" nmap <silent> <leader>mc <Plug>MarkClear
" vmap <silent> <leader>mc <Plug>MarkClear

""""""""""""""""""""""""""""""
" C/C++
"""""""""""""""""""""""""""""""
autocmd FileType c,cpp map <buffer> <F5> :make<cr>:cw 10<CR>

"Quickfix
nmap <leader>cn :cn<CR>
nmap <leader>cp :cp<CR>
nmap <leader>cw :cw 10<CR>

nmap <silent><Left> :bp<CR>
nmap <silent><Right> :bn<CR>
nmap <silent><C-c> :MBEbw<CR>
nmap <silent><C-W>c :MBEbw<cr>:wincmd c<cr>

nmap <silent><leader>mi :set foldmethod=indent<CR>
nmap <silent><leader>ms :set foldmethod=syntax<CR>
nmap <silent><F6> <ESC>:YcmDiags<CR>
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>

map <silent><leader>bdo :BcloseOthers<cr>

map <leader>= gg=G<C-O><C-O>:w<CR>

nnoremap <leader>q <ESC>:wqa<CR>
"
inoremap <buffer> >> <Space>>><Space>
inoremap <buffer> << <Space><<<Space>
inoremap <buffer> <<" <Space><< ""<Space><Left><Left>
inoremap <buffer> <<; <Space><< "\n";<Left><Left><Left><Left>

" nnoremap <C-[> <Esc>:exec("ptjump ".expand("<cword>"))<Esc>

nnoremap <silent> <leader>il :IndentLinesToggle<CR>

noremap <silent> <leader>dt :diffthis<CR>

noremap <silent> <leader>ct :ConqueTermTab bash<CR>

vmap <Enter> <Plug>(EasyAlign)
cnoremap <C-a>  <Home>
cnoremap <C-e>  <End>

nnoremap <silent> <leader>pt :ProjectTreeToggle<cr>
nnoremap <silent> <leader>jio :JavaImportOrganize<cr>
" nnoremap <silent> <leader>ds :JavaDocSearch -x declarations<cr>
nnoremap <silent> <leader>jsc :JavaSearchContext<cr>
nnoremap <silent> <Leader>jc :JavaCorrect<cr>
nnoremap <silent> <leader>dp :JavaDocPreview<cr>
nnoremap <silent> <leader>jf :%JavaFormat<cr>
nnoremap <silent> <leader>jg :JavaGet<cr> 
nnoremap <silent> <leader>js :JavaSet<cr>
nnoremap <silent> <leader><leader>ji :JavaImpl<cr>
