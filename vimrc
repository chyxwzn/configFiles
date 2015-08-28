" .vimrc
" Pathogen
call pathogen#infect()
call pathogen#helptags()

" Filetype
filetype plugin indent on
syntax enable
syntax on

" Load custom settings

" Color Settings
set background=dark
" set background=light
color skittles_berry
" let g:solarized_termcolors=256
" color solarized

" ======= functions =======
fun! VisualReplace() 
	let l:saved_reg = @"
	execute "normal! vgvy"
	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")
    let l:word = input("Replace " . l:pattern . " with:") 
    :exe '%s/' . l:pattern . '/' . l:word . '/gc' 
endfun 

fun! Replace() 
    let l:word = input("Replace " . expand('<cword>') . " with:") 
    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . l:word . '/gc' 
endfun

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

func! AgSearch(mode, scope)
    let l:cscopeFile = getcwd() . "/cscope.files"
    if filereadable(l:cscopeFile)
        if a:scope == 'cscope'
            let l:files = system("sed ':a;N;$!ba;s/\\n/ /g' " . l:cscopeFile)
        else
            let l:files = bufname("%")
        endif
    else
        if a:scope == 'cscope'
            echom "there is no cscope.files"
            return 1
        else
            let l:files = bufname("%")
        endif
    endif
    if a:mode == 'n'
        let l:pattern = expand('<cword>')
    else
        let l:saved_reg = @"
        execute "normal! vgvy"
        let l:pattern = escape(@", '\\/.*$^~[]')
        let l:pattern = substitute(l:pattern, "\n$", "", "")
    endif
    silent! execute 'Ag -Q ' . l:pattern . ' ' . l:files
endfunc

let g:autoSessionFile=".project.vim"
let g:viminfoFile=".viminfo.vim"
let g:origPwd=getcwd()
func! EnterHandler()
	if filereadable(g:autoSessionFile)
        exe "source ".g:autoSessionFile
	endif
	if filereadable(g:viminfoFile)
		exe "rviminfo ".g:viminfoFile
	endif
	if filereadable("tags")
		set tags+=tags
	endif
endfunction

func! LeaveHandler()
	exec "NERDTreeClose"
	exec "mksession! ".g:origPwd."/".g:autoSessionFile
	exec "wviminfo ".g:origPwd."/".g:viminfoFile
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
" Switch from block-cursor to vertical-line-cursor when going into/out of
" insert mode
let &t_SI="\<Esc>]50;CursorShape=1\x7"
let &t_EI="\<Esc>]50;CursorShape=0\x7"
set dict=/usr/share/dict/words
"set cursorline
" setlocal spell spelllang=en_us
set showcmd " Show (partial) command in the last line of the screen.
set ruler " Show the line and column number of the cursor position, separated by a comma.
set incsearch " While typing a search command, show where the pattern, as it was typed so far, matches.
set wildmenu " When 'wildmenu' is on, command-line completion operates in an enhanced mode.
if !has("win32")
    set term=xterm-256color " colored airline
    " Set this, so the background color will not change inside tmux (http://snk.tuxfamily.org/log/vim-256color-bce.html)
    set t_ut=
endif
set shortmess=aAIsT
set cmdheight=2
" set nowrap
set wrap " When on, lines longer than the width of the window will wrap and displaying continues on the next line.
" let &scrolloff=999 " the cursor line will always be in the middle of the window
set smartcase
set autoread " read open files again when changed outside Vim
set autowrite

set hidden " hide buffers instead of closing them this
           " means that the current buffer can be put
           " to background without being written; and
           " that marks and undo history are preserved
set completeopt=menu
set mousemodel=popup " Sets the model to use for the mouse.
set backspace=indent,eol,start  " backspacing over everything in insert mode
set wildignore+=*.bak,*.bk,*/.git/*,*/.svn/*,*.o,*.e,*~,*.pyc,*/tmp/*,*.so,*.swp,*.zip " wildmenu: ignore these extensions
set number
set cinoptions+=g0 " Place C++ scope declarations 0 characters from the indent of the block they are in.

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
" set fileformat=unix
set fileformats=unix,dos
" set fillchars=vert:|

let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" indent options
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab

set linespace=0
set history=1000

set laststatus=2
if has("gui_running")
    if has("win32")
        set guifont=Courier\ New:h12
        set guioptions-=T
    else
        set guifont=Monospace\ 13
        set mouse=a
        set guioptions-=T
        "set guioptions-=m
    endif
endif

"Do not redraw, when running macros.. lazyredraw
set lz

"Highlight search things
set hlsearch
"Set magic on
set magic
"show matching bracets
set showmatch

"Restore cursor to file position in previous editing session
" set viminfo='10,\"100,:20,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
au GUIEnter * simalt ~x " Maximize gvim window
set sessionoptions-=curdir
set sessionoptions+=sesdir

"Turn backup off
set nobackup
set nowritebackup
set noswapfile

"Enable folding, I find it very useful
set foldenable
set foldlevel=0
set foldmethod=syntax

"C-style indeting
set cindent

set previewheight=10
" set splitbelow

set clipboard=unnamed	" yank to the system register (*) by default
set pastetoggle=<F6>

" if has("win32")
"     let g:tagbar_ctags_bin = 'F:\Program\ Files\Vim\vim74\ctags.exe'
" endif

" => Turn persistent undo on 
"    means that you can undo even when you close a buffer/VIM
try
    set undodir=~/.temp_dirs/undodir
    set undofile
catch
endtry


" make type colon easily 
nnoremap ; :
vnoremap ; :
" Quickly get out of insert mode without your fingers having to leave the
" home row (either use 'jj' or 'jk')
inoremap jj <ESC>
" Treat long lines as break lines (useful when moving around in them)
nnoremap j gj
nnoremap k gk
" Use shift-H and shift-L for move to beginning/end
noremap H 0
noremap L $
noremap Y y$
noremap gp o<Esc>p " paster below current line
nnoremap <silent>m :cal cursor(line("."), col("$")/2 + col(".")/2)<cr>
nnoremap <silent>M :cal cursor(line("."), (col(".") - col("^"))/2)<cr>
map <silent>K <C-u>zz
map <silent>J <C-d>zz

inoremap <silent><C-j> <Down>
inoremap <silent><C-k> <Up>
inoremap <silent><C-h> <Left>
inoremap <silent><C-l> <Right>

"Fast remove highlight search
nnoremap <silent><leader><cr> :noh<cr>

" move current line
nno <C-Down> ddp
nno <C-Up> ddkP

" Reselect text that was just pasted with ,v
nnoremap <silent><leader>v V`]

" fast save
nnoremap <silent><leader>s :w!<CR>
nnoremap <silent><leader>W :call WriteFormat()<cr>:w!<cr>

" nno <Leader>h :tabprevious<CR>
" nno <Leader>l :tabnext<CR>
" nnoremap <Leader>tn :tabnew %:p<CR>
" nnoremap <silent><leader>tc :tabclose<CR>

" diff
nnoremap ]c ]czz
nnoremap [c [czz

" default to very magic
"no / /\v

" gO to create a new line above and below cursor in normal mode
nnoremap go O<ESC>jo<ESC>k

"When searching for words with * and navigating with N/n, keep line centered vertically
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
nnoremap { {zz

"open tag in new window
map <silent><leader><C-]> :set splitbelow<CR>:exec("stag ".expand("<cword>"))<CR>:res 16<CR>

"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

"replace the current word in all opened buffers
nmap <silent><leader>r :call Replace()<CR>
vmap <silent><leader>r :call VisualReplace()<CR>

" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv

"noremap <F1> :call ToggleFocusMode()<cr>
"Smart way to move btw. windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <silent><leader>= gg=G<C-O><C-O>:w<CR>
nnoremap <silent><leader>q <ESC>:wqa<CR>
" nnoremap <C-[> <Esc>:exec("ptjump ".expand("<cword>"))<Esc>
noremap <silent><leader>dt :diffthis<CR>

nnoremap <silent><leader><leader>s :setlocal spell! spelllang=en_US<CR>

" auto save and load session
if filereadable(g:autoSessionFile)
	if argc() == 0
		au VimEnter * call EnterHandler()
		au VimLeave * call LeaveHandler()
	endif
endif

if has("win32")
    noremap <silent><leader>vr :e ~/_vimrc<CR>
else
    nnoremap <silent><leader>vr :e ~/.vimrc<CR>
endif

"Quickfix and Locationlist
nnoremap <silent><F8> :lne<CR>
nnoremap <silent><F7> :lp<CR>
" let g:lt_location_list_toggle_map = '<leader><leader>l'
" let g:lt_quickfix_list_toggle_map = '<leader><leader>q'

autocmd Filetype java setlocal omnifunc=javacomplete#Complete
autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
au BufRead,BufNewFile *.js set ft=javascript syntax=jquery
" autocmd FileType c,cpp map <buffer> <F5> :make<cr>:cw 10<CR>



" ==================plugins settings==============

" airline setting
let g:airline_left_sep=''
let g:airline_right_sep=''

" NERDTree setting
let NERDTreeMinimalUI=1
let NERDTreeChDirMode=1
let NERDTreeWinPos = "left"
let NERDTreeDirArrows = 0
nnoremap <silent><F5> :NERDTreeToggle<cr>
nnoremap <silent><leader>nf :NERDTreeFind<CR>

" EasyMotion setting
let g:EasyMotion_leader_key = '<leader>'

" youcompleteme setting
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_show_diagnostics_ui = 0
let g:ycm_auto_start_csharp_server = 0
let g:ycm_key_invoke_completion = '<C-/>'
" let g:curWorkingDir=getcwd()
let g:ycm_global_ycm_extra_conf = g:origPwd.'/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_always_populate_location_list = 1
if !filereadable(g:ycm_global_ycm_extra_conf)
    let g:loaded_youcompleteme=1
endif
" nnoremap <silent><F7> <ESC>:YcmDiags<CR>
" nnoremap <silent><leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>

" UltiSnips setting
let g:did_UltiSnips_plugin=1
let g:UltiSnipsExpandTrigger="<C-f>"
let g:UltiSnipsJumpForwardTrigger="<C-f>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
let g:UltiSnipsSnippetDirectories=["mySnippets"]

" tagbar setting
let g:tagbar_show_linenumbers = 1
" let g:tagbar_autopreview = 1
nnoremap <silent><F2> :TagbarToggle<CR>

" minibuffer setting
let g:miniBufExplVSplit = 14   " column width in chars
" Put new window above current or on the left for vertical split
let g:miniBufExplBRSplit = 0   
let g:miniBufExplorerAutoStart = 0
nnoremap <silent><F3> :MBEToggle<cr>
nnoremap <silent><Left> :bp<CR>
nnoremap <silent><Right> :bn<CR>
nnoremap <silent><C-c> :MBEbw<CR>
nnoremap <silent><C-W>c :MBEbw<cr>:wincmd c<cr>
nnoremap <silent><leader>bdo :BcloseOthers<cr>

" EasyAlign setting
vmap <Enter> <Plug>(EasyAlign)

" ctrlp setting
let g:ctrlp_map = '<leader><c-p>'
let g:ctrlp_use_caching = 1
let g:ctrlp_by_filename = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = g:origPwd
let g:ctrlp_user_command = 'ag --nocolor --depth 0 -g cscope.files %s | xargs cat'
if !filereadable(g:autoSessionFile)
    let g:loaded_ctrlp = 1
endif
nnoremap <C-p> :exec("CtrlP ".g:origPwd)<CR>

" ag (the silver searcher) setting
let g:ag_highlight=1
let g:ag_qhandler="copen 14"
nmap <silent><leader>* :call AgSearch('n', 'cscope')<CR>
vmap <silent><leader>* :call AgSearch('v', 'cscope')<CR>
nmap <silent><leader># :call AgSearch('n', 'current')<CR>
vmap <silent><leader># :call AgSearch('v', 'current')<CR>
