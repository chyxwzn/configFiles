" .vimrc
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
if has("win32")
    set rtp+=$HOME/vimfiles/bundle/Vundle.vim
    call vundle#begin('$USERPROFILE/vimfiles/bundle/')
else
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
endif
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'rking/ag.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'chyxwzn/dictionary.vim'
Plugin 'Konfekt/FastFold'
Plugin 'davidhalter/jedi-vim'
Plugin 'tikhomirov/vim-glsl'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'tomtom/tcomment_vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'chyxwzn/vim-code2html'
Plugin 'altercation/vim-colors-solarized'
Plugin 'chrisbra/vim-diff-enhanced'
Plugin 'junegunn/vim-easy-align'
Plugin 'easymotion/vim-easymotion'
Plugin 'chyxwzn/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'chyxwzn/skittles_berry.vim'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'chyxwzn/vim-snippets'
" Plugin 'chyxwzn/vim-stardict'
Plugin 'kshenoy/vim-signature'
Plugin 'gcmt/wildfire.vim'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/ZoomWin'
Plugin 'aklt/plantuml-syntax'
Plugin 'sjl/gundo.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" To install from command line: vim +PluginInstall +qall
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" Filetype
filetype plugin indent on
syntax enable
syntax on

" Load custom settings

" Color Settings
set background=dark
" set background=light

" color skittles_berry

" let g:solarized_termcolors=256
" color solarized
" let g:airline_theme='solarized'

color PaperColor
let g:airline_theme='papercolor'

" ======= functions =======
fun! VisualReplace() 
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    let l:word = input("Replace " . l:pattern . " with:") 
    :exe '%s/' . l:pattern . '/' . l:word . '/gc' 
    let @" = l:saved_reg
endfun 

fun! Replace() 
    let l:word = input("Replace " . expand('<cword>') . " with:") 
    :exe '%s/\<' . expand('<cword>') . '\>/' . l:word . '/gc' 
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
    " a simple list of ctags file list
    let l:ctagsFile = getcwd() . "/.projDirs"
    if filereadable(l:ctagsFile)
        if a:scope == 'ctags'
            let l:files = system("sed -e ':a' -e 'N' -e '$!ba' -e 's/\\n/ /g' " . l:ctagsFile)
        else
            let l:files = bufname("%")
        endif
    else
        if a:scope == 'ctags'
            echom "there is no ctags.files"
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
    silent! execute 'LAg -Q ' . l:pattern . ' ' . l:files
endfunc

let g:autoSessionFile=".project.vim"
let g:viminfoFile=".viminfo.vim"
let g:origPwd=getcwd()
if filereadable("tags")
    setglobal tags=tags
endif
func! EnterHandler()
    if filereadable(g:autoSessionFile)
        exe "source ".g:autoSessionFile
    endif
    if filereadable(g:viminfoFile)
        exe "rviminfo! ".g:viminfoFile
    endif
endfunction

func! LeaveHandler()
    exec "NERDTreeClose"
    exec "mksession! ".g:origPwd."/".g:autoSessionFile
    exec "wviminfo! ".g:origPwd."/".g:viminfoFile
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

"use foldclosed({lnum}) to tell if fold is closed or not now
function! ToggleFold()
    if( foldclosed(".") == -1 )
        exec "normal! zazz"
    else
        exec "normal! zAzz"
    endif
endfunction

"============== General Settings ===============
"Get out of VI's compatible mode..
set nocompatible
let g:mapleader = ","
" Switch from block-cursor to vertical-line-cursor when going into/out of
" insert mode
let &t_SI="\<Esc>]50;CursorShape=1\x7"
let &t_EI="\<Esc>]50;CursorShape=0\x7"
if has('win32')
    let dictDir=$HOME.'/vimfiles/bundle/dictionary.vim/'
    set thesaurus=~/vimfiles/bundle/dictionary.vim/words
    set dictionary=~/vimfiles/bundle/dictionary.vim/words
else
    let dictDir=$HOME.'/.vim/bundle/dictionary.vim/'
    set thesaurus=~/.vim/bundle/dictionary.vim/words
    set dictionary=~/.vim/bundle/dictionary.vim/words
endif
"set cursorline
" setlocal spell spelllang=en_us
set showcmd " Show (partial) command in the last line of the screen.
set ruler " Show the line and column number of the cursor position, separated by a comma.
set incsearch " While typing a search command, show where the pattern, as it was typed so far, matches.
set wildmenu " When 'wildmenu' is on, command-line completion operates in an enhanced mode.
if !has("gui_running")
    set term=xterm-256color " colored airline
    " Set this, so the background color will not change inside tmux (http://snk.tuxfamily.org/log/vim-256color-bce.html)
    set t_ut=
endif
set shortmess=aAIsT
set cmdheight=2
" set nowrap
set wrap " When on, lines longer than the width of the window will wrap and displaying continues on the next line.
set smartcase
set autoread " read open files again when changed outside Vim
set autowrite

set hidden " hide buffers instead of closing them this
" means that the current buffer can be put
" to background without being written; and
" that marks and undo history are preserved
set complete-=i
set completeopt=menu
set mousemodel=popup " Sets the model to use for the mouse.
set backspace=indent,eol,start  " backspacing over everything in insert mode
set wildignore+=tags,*.bak,*.bk,*/.git/*,*/.svn/*,*.o,*.e,*~,*.pyc,*/tmp/*,*.so,*.swp,*.zip " wildmenu: ignore these extensions
set number
set relativenumber
set cinoptions+=g0 " Place C++ scope declarations 0 characters from the indent of the block they are in.

set encoding=utf-8 
set termencoding=utf-8 
set fileencoding=utf-8 
" multi-encoding setting
if has("multi_byte")
    set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-jp,sjis,euc-kr,ucs-2le,latin1 
endif 
set fileformats=unix,dos

let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" indent options
set shiftwidth=4
set softtabstop=4
set expandtab
" allow toggling between local and default mode
function! ToggleTab()
  if &expandtab
    set shiftwidth=8
    set softtabstop=0
    set noexpandtab
  else
    set shiftwidth=4
    set softtabstop=4
    set expandtab
  endif
endfunction
nmap <F9> :call ToggleTab()<CR>

set linespace=0
set history=200

set laststatus=2
if has("gui_running")
    if has("win32")
        set guifont=Courier\ New:h12
        set guioptions-=T
    else
        set guifont=Monaco:h14
        " set guifont=Menlo:h14
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

set sessionoptions=buffers,globals,localoptions,sesdir,tabpages,winsize,winpos,resize

"Turn backup off
set nobackup
set nowritebackup
set noswapfile

" set nofoldenable
set foldenable
set foldlevel=1
set foldmethod=syntax

"C-style indeting
set cindent

set previewheight=10
set splitbelow
set diffopt=filler,vertical

set clipboard=unnamed	" yank to the system register (*) by default
set pastetoggle=<F10>

" au GUIEnter * simalt ~x " Maximize gvim window

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
" paster below current line
noremap gp o<Esc>p
nnoremap <silent>M :cal cursor(line("."), col("$")/2 + col(".")/2)<cr>
" nnoremap <silent>M :cal cursor(line("."), (col(".") - col("^"))/2)<cr>
map <silent>K <PageUp>zz
map <silent>J <PageDown>zz
map <silent>F :call ToggleFold()<CR>

" CTRL-A to select all
nnoremap <C-A> ggVG
inoremap <C-A> <C-O>gg<C-O>V<C-O>G
vnoremap <C-A> <C-C>ggVG

" Use CTRL-S for saving, also in Insert mode
noremap  <silent><C-S> :update<CR>
vnoremap <silent><C-S> <C-C>:update<CR>
inoremap <silent><C-S> <C-O>:update<CR>

inoremap <silent><C-j> <Down>
inoremap <silent><C-k> <Up>
inoremap <silent><C-h> <Left>
inoremap <silent><C-l> <Right>

"Fast remove highlight search
nnoremap <silent><leader><Enter> :noh<cr>

"toggle line number
nnoremap <silent><C-n> :set number!<cr>:set relativenumber!<cr>

" move current line
nnoremap <C-Down> ddp
nnoremap <C-Up> ddkP

" Reselect text that was just pasted with ,v
nnoremap <silent><leader>v `[v`]

nnoremap <silent><leader>wf :call WriteFormat()<cr>:w!<cr>

nnoremap <silent><leader>h :tabprevious<CR>
nnoremap <silent><leader>l :tabnext<CR>
nnoremap <silent><leader>tn :tabnew %:p<CR>
nnoremap <silent><leader>tc :tabclose<CR>

" default to very magic
"no / /\v

" create a new line above and below cursor in normal mode
nnoremap go O<ESC>jo<ESC>k

"open tag in new window
map <silent><leader><C-]> :set splitbelow<CR>:exec("stag ".expand("<cword>"))<CR>:res 16<CR>

"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

"When searching for words with * and navigating with N/n, keep line centered vertically
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz
nnoremap } }zz
nnoremap { {zz

"replace the current word in all opened buffers
nmap <silent><leader>r :call Replace()<CR>
vmap <silent><leader>r :call VisualReplace()<CR>

" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv

"Smart way to move btw. windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <silent><leader>= gg=G<C-O><C-O>:w<CR>
nnoremap <silent><leader>q <ESC>:wqa<CR>

nnoremap <silent><leader><leader>s :setlocal spell! spelllang=en_us<CR>
nnoremap <silent><leader>cf :set fileencoding=utf8<CR>:w<CR>

" auto save and load session
if filereadable(g:autoSessionFile)
    if argc() == 0
        au VimEnter * call EnterHandler()
        au VimLeave * call LeaveHandler()
    endif
endif

if has("win32")
    nnoremap <silent><leader>vr :e ~/_vimrc<CR>
    nnoremap <silent><leader>vs :source ~/_vimrc<CR>
else
    nnoremap <silent><leader>vr :e ~/.vimrc<CR>
    nnoremap <silent><leader>vs :source ~/.vimrc<CR>
endif

"Quickfix and Locationlist
nnoremap <silent><F8> :lne<CR>
nnoremap <silent><F7> :lp<CR>

if has("cscope")
    set csprg=/usr/local/bin/cscope
    set csto=0
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

" ==================plugins settings==============

" airline setting
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr = 0

" NERDTree setting
let NERDTreeMinimalUI=1
let NERDTreeShowLineNumbers=1
let NERDTreeChDirMode=1
let NERDTreeWinPos = "left"
let NERDTreeDirArrows = 0
nnoremap <silent><F5> :NERDTreeToggle<cr>
nnoremap <silent><leader>nf :NERDTreeFind<CR>

" EasyMotion setting
let g:EasyMotion_leader_key = '<leader>'

" youcompleteme setting
" let g:ycm_global_ycm_extra_conf = g:origPwd.'/.ycm_extra_conf.py'
" if filereadable(g:ycm_global_ycm_extra_conf)
if has("win32")
    let g:loaded_youcompleteme=1
    " neocomplete Settings
    if has('lua')
        let g:neocomplete#enable_at_startup = 1
        let g:neocomplete#enable_ignore_case = 1
        let g:neocomplete#data_directory = "~/.cache/neocomplete"
        inoremap <expr><C-e>     neocomplete#cancel_popup()
		inoremap <expr><C-g>     neocomplete#undo_completion()
		nnoremap <silent><leader>nt :NeoCompleteTagMakeCache<CR>
        " for thesaurus completion
        inoremap <silent><C-t> <C-e><C-x><C-t>
        inoremap <silent><C-o> <C-e><C-x><C-o>
    endif

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
else
    let g:neocomplete#enable_at_startup = 0
    let g:ycm_collect_identifiers_from_tags_files = 1
    " let g:ycm_show_diagnostics_ui = 0
    let g:ycm_key_invoke_completion = '<C-y>'
    let g:ycm_confirm_extra_conf = 0
    " nnoremap <silent><F7> <ESC>:YcmDiags<CR>
    nnoremap <silent><C-\>] :YcmCompleter GoTo<CR>
endif

" UltiSnips setting
let g:UltiSnipsExpandTrigger="<C-f>"
let g:UltiSnipsJumpForwardTrigger="<C-f>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
let g:UltiSnipsSnippetDirectories=["bundle/vim-snippets/UltiSnips"]

" jedi-vim
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = 0
let g:jedi#auto_vim_configuration = 0
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python =
            \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" alternative pattern: '\h\w*\|[^. \t]\.\w*'
let g:jedi#goto_command = "<leader>g"
let g:jedi#goto_assignments_command = "<leader>a"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "<leader>d"
let g:jedi#usages_command = "<leader>u"
let g:jedi#completions_command = ""
let g:jedi#rename_command = ""

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTagsmnifunc=syntaxcomplete#Complete

" tagbar setting
let g:tagbar_show_linenumbers = 1
let g:tagbar_autofocus = 1
let g:tagbar_foldlevel = 1
nnoremap <silent><F2> :TagbarToggle<CR>

" minibuffer setting
" Put new window above current or on the left for vertical split
let g:miniBufExplBRSplit = 0   
let g:miniBufExplorerAutoStart = 1
nnoremap <silent><F3> :MBEToggle<cr>
nnoremap <silent><Left> :bp<CR>
nnoremap <silent><Right> :bn<CR>
nnoremap <silent><C-c> :MBEbw<CR>
nnoremap <silent><C-W>c :MBEbw<cr>:wincmd c<cr>
nnoremap <silent><leader>bdo :BcloseOthers<cr>

" EasyAlign setting
vmap <silent><leader><Enter> <Plug>(EasyAlign)

" ctrlp setting
let g:ctrlp_by_filename = 1
" Fast CtrlP matcher based on python, performance difference is up to x22
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
if filereadable(g:autoSessionFile)
    " disable default ctrlp action and always ctrlp project directory
    let g:ctrlp_map = '<leader><C-p>'
    let g:ctrlp_use_caching = 1
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_cache_dir = g:origPwd
    nnoremap <C-p> :exec("CtrlP ".g:origPwd)<CR>
    if has("win32")
        let g:ctrlp_user_command = 'type %s\ctags.files'
    else
        let g:ctrlp_user_command = 'cat %s/ctags.files'
    endif
else
    let g:ctrlp_use_caching = 0
    let g:ctrlp_user_command = 'ag -l --nocolor --depth 0 -g "" %s'
endif

" ag (the silver searcher) setting
let g:ag_qhandler="copen 14"
nmap <silent><leader>* :call AgSearch('n', 'ctags')<CR>
vmap <silent><leader>* :call AgSearch('v', 'ctags')<CR>
nmap <silent><leader># :call AgSearch('n', 'current')<CR>
vmap <silent><leader># :call AgSearch('v', 'current')<CR>

" GitGutter setting
let g:gitgutter_highlight_lines = 0
let g:gitgutter_eager = 0
let g:gitgutter_realtime = 0
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
nmap <Leader>ha <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUndoHunk

" StarDict
" Need sdcv, console version of StarDict
let g:stardict_data_dir = dictDir
" nmap <silent><leader>sd :StarDictCursor<CR>
" vmap <silent><leader>sd :StarDictSelect<CR>

" wildfire
nmap <leader>s <Plug>(wildfire-quick-select)

" cscope map
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

let g:jedi#documentation_command = ""
nmap T :call jedi#show_documentation()<CR>

" vim-signature: Plugin to toggle, display and navigate marks
" m.           If no mark on line, place the next available mark. 
"              Otherwise, remove (first) existing mark.
" ]'           Jump to start of next line containing a mark
" ['           Jump to start of prev line containing a mark
" m/           Open location list and display marks from current buffer
" m<Space>     Delete all marks from the current buffer

" code2html
" convert to html without line number
" map <silent><leader>y :CodeToHtml<CR>
" convert to html with line number
" map <silent><leader>ny :NCodeToHtml<CR>
