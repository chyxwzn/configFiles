" .vimrc
set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'chyxwzn/dictionary.vim'
Plug 'Konfekt/FastFold'
Plug 'fholgado/minibufexpl.vim'
Plug 'majutsushi/tagbar'
Plug 'tomtom/tcomment_vim'
Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chyxwzn/vim-code2html'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'easymotion/vim-easymotion'
Plug 'chyxwzn/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'NLKNguyen/papercolor-theme'
Plug 'lifepillar/vim-solarized8'
Plug 'rakr/vim-one'
Plug 'jacoborus/tender.vim'
Plug 'KeitaNakamura/neodark.vim'
Plug 'joshdick/onedark.vim'
Plug 'chyxwzn/vim-snippets'
Plug 'kshenoy/vim-signature'
Plug 'gcmt/wildfire.vim'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/ZoomWin'
Plug 'sjl/gundo.vim'
Plug 'junkblocker/patchreview-vim'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'arakashic/chromatica.nvim', {'for': ['c', 'cpp']}
Plug 'tenfyzhong/CompleteParameter.vim', {'for': ['c', 'cpp']}
Plug 'edkolev/promptline.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'vimlab/split-term.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tmhedberg/SimpylFold'
Plug 'nvie/vim-flake8'
Plug 'vim-python/python-syntax'
Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'
Plug 'google/vim-codefmt'
Plug 'google/vim-searchindex'

" Initialize plugin system
" Reload .vimrc and :PlugInstall to install plugins.
call plug#end()
" the glaive#Install() should go after the "call vundle#end()"
call glaive#Install()

" Filetype
filetype plugin indent on
syntax enable
syntax on

" Load custom settings

" Color Settings
set background=dark
" set background=light

" let g:airline_theme='solarized8'
" color solarized8

" let g:airline_theme='papercolor'
" color PaperColor

" let g:airline_theme='onedark'
" color onedark

color one
let g:airline_theme='one'
call one#highlight('Visual', '282c34', 'e5c07b', 'none')

set termguicolors

" ======= functions =======
fun! PaperColorTheme()
    let g:airline_theme='papercolor'
    set notermguicolors
    color PaperColor
endfun

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

let g:autoSessionFile=".project.vim"
let g:viminfoFile=".viminfo.vim"
let g:origPwd=getcwd()
let g:projectDirs = '.'
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
    let l:ctagsFile = getcwd() . "/.projDirs"
    if filereadable(l:ctagsFile)
        let g:projectDirs = system("sed -e ':a' -e 'N' -e '$!ba' -e 's/\\n/ /g' " . l:ctagsFile)
    endif
    au filetype c,cpp exe "ChromaticStart"
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

"use foldlevel({lnum}) to tell if there's fold now
"use foldclosed({lnum}) to tell if fold is closed or not now
function! ToggleFold()
    if (foldlevel(".") > 0)
        if( foldclosed(".") == -1 )
            exec "normal! zazz"
        else
            exec "normal! zAzz"
        endif
    endif
endfunction

let t:centerfocused=0
function! ToggleCenterFocus()
    if (t:centerfocused)
        exec "wincmd h"
        exec "wincmd c"
        exec "highlight VertSplit guifg=black guibg=bg"
        let t:centerfocused=0
    else
        exec "leftabove 50vnew"
        setlocal nonumber
        setlocal norelativenumber
        exec "highlight VertSplit guifg=bg guibg=bg"
        exec "highlight NonText   guifg=bg"
        exec "wincmd l"
        let t:centerfocused=1
    endif
endfunction
nnoremap <silent><C-w>f :call ToggleCenterFocus()<CR>

"============== General Settings ===============
"Get out of VI's compatible mode..
set nocompatible
let g:mapleader = ","
" Switch from block-cursor to vertical-line-cursor when going into/out of
" insert mode
let &t_SI="\<Esc>]50;CursorShape=1\x7"
let &t_EI="\<Esc>]50;CursorShape=0\x7"
if has('win32')
    let dictDir=$HOME.'/AppData/Local/nvim/plugged/dictionary.vim/'
else
    let dictDir=$HOME.'/.config/nvim/plugged/dictionary.vim/'
    " set thesaurus=~/.config/nvim/plugged/dictionary.vim/words
    " set dictionary=~/.config/nvim/plugged/dictionary.vim/words
endif
"set cursorline
set showcmd " Show (partial) command in the last line of the screen.
set noshowmode
set incsearch " While typing a search command, show where the pattern, as it was typed so far, matches.
set wildmenu " When 'wildmenu' is on, command-line completion operates in an enhanced mode.
if !has("gui_running")
    if !has("nvim")
        set term=xterm-256color " colored airline
        " Set this, so the background color will not change inside tmux (http://snk.tuxfamily.org/log/vim-256color-bce.html)
        set t_ut=
    endif
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

set nofoldenable
" set foldenable
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
nnoremap <silent>j gj
nnoremap <silent>k gk
" Use shift-H and shift-L for move to beginning/end
noremap H 0
noremap L $
noremap Y y$
" paster below current line
noremap gp o<Esc>p
nnoremap <silent>M :cal cursor(line("."), col("$")/2 + col(".")/2)<cr>
map <silent>K <PageUp>zz
map <silent>J <PageDown>zz
map <silent>F :call ToggleFold()<CR>

" CTRL-A to select all
nnoremap <silent><C-A> ggVG
inoremap <silent><C-A> <C-O>gg<C-O>V<C-O>G
vnoremap <silent><C-A> <C-C>ggVG

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

" Reselect text that was just pasted with
nnoremap <silent><C-y> `[v`]y

nnoremap <silent><leader><leader>f :call WriteFormat()<cr>:w!<cr>
nnoremap <silent><leader><leader>p :call PaperColorTheme()<cr>

nnoremap <silent><leader>h :tabprevious<CR>
nnoremap <silent><leader>l :tabnext<CR>
nnoremap <silent><leader>tn :tabnew %:p<CR>
nnoremap <silent><leader>tc :tabclose<CR>

" default to very magic
"no / /\v

" create a new line above and below cursor in normal mode
nnoremap <silent>go O<ESC>jo<ESC>k

"open tag in new window
map <silent><leader><C-]> :set splitbelow<CR>:exec("stag ".expand("<cword>"))<CR>:res 16<CR>

"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent>* :call VisualSearch('f')<CR>
vnoremap <silent># :call VisualSearch('b')<CR>

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
nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-h> <C-W>h
nnoremap <A-l> <C-W>l
" for ios termius app
nnoremap <A-J> <C-W>j
nnoremap <A-K> <C-W>k
nnoremap <A-H> <C-W>h
nnoremap <A-L> <C-W>l
nnoremap <silent><A-q> :q<CR>
nnoremap <silent><A-Q> :q<CR>

nnoremap <silent><leader>q <ESC>:wqa<CR>

nnoremap <silent><leader><leader>s :setlocal spell! spelllang=en_us<CR>
nnoremap <silent><leader><leader>u :set fileencoding=utf8<CR>:w<CR>

" auto save and load session
if filereadable(g:autoSessionFile)
    if argc() == 0
        au VimEnter * call EnterHandler()
        au VimLeave * call LeaveHandler()
    endif
endif

if has("win32")
    nnoremap <silent><leader>vr :e ~/AppData/Local/nvim/init.vim<CR>
    nnoremap <silent><leader>vs :source ~/AppData/Local/nvim/init.vim<CR>
else
    nnoremap <silent><leader>vr :e ~/.config/nvim/init.vim<CR>
    nnoremap <silent><leader>vs :source ~/.config/nvim/init.vim<CR>
endif

au BufRead,BufNewFile *.py,*.c,*.cpp,*.h match Error /\s\+$/
au BufRead,BufNewFile *.py set foldenable
au BufRead,BufNewFile *.py let python_highlight_all=1

" ==================plugins settings==============

" airline setting
"let g:airline_left_sep=''
"let g:airline_right_sep=''
let g:airline_powerline_fonts = 1
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
nmap f <Plug>(easymotion-sl)

" youcompleteme setting
" let g:ycm_global_ycm_extra_conf = g:origPwd.'/.ycm_extra_conf.py'
" if filereadable(g:ycm_global_ycm_extra_conf)
if has("win32")
    let g:loaded_youcompleteme=1
else
    let g:ycm_python_binary_path = 'python3'
    let g:ycm_collect_identifiers_from_tags_files = 1
    " let g:ycm_show_diagnostics_ui = 0
    let g:ycm_key_list_stop_completion = ['<C-y>']
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_semantic_triggers =  {
                \ 'c,cpp,python': ['re!\w{2}'],
                \ }
    let g:ycm_add_preview_to_completeopt = 0
    let g:ycm_min_num_identifier_candidate_chars = 2
    let g:ycm_complete_in_strings=1
    let g:ycm_filetype_blacklist = {
                \ 'tagbar' : 1,
                \ 'qf' : 1,
                \ 'notes' : 1,
                \ 'markdown' : 1,
                \ 'unite' : 1,
                \ 'text' : 1,
                \ 'vimwiki' : 1,
                \ 'pandoc' : 1,
                \ 'infolog' : 1,
                \ 'gitcommit' : 1,
                \ 'mail' : 1
                \}
    "nnoremap <silent><F7> <ESC>:YcmDiags<CR>
    au FileType c,cpp,python nnoremap <buffer> <A-]> :YcmCompleter GoTo<CR>
    au FileType c,cpp,python nnoremap <buffer> <A-d> :YcmCompleter GetDoc<CR>
    au FileType c,cpp,python nnoremap <buffer> <A-r> :YcmCompleter GoToReferences<CR>
    au FileType c,cpp,python nnoremap <buffer> <A-D> :YcmCompleter GetDoc<CR>
    au FileType c,cpp,python nnoremap <buffer> <A-R> :YcmCompleter GoToReferences<CR>
endif

" UltiSnips setting
let g:UltiSnipsExpandTrigger="<C-f>"
let g:UltiSnipsJumpForwardTrigger="<C-f>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
let g:UltiSnipsSnippetDirectories=["plugged/vim-snippets/UltiSnips"]

" tagbar setting
let g:tagbar_show_linenumbers = 1
let g:tagbar_autofocus = 1
let g:tagbar_foldlevel = 1
let g:tagbar_vertical = 20
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
nnoremap <silent><leader><leader>d :BcloseOthers<cr>

" EasyAlign setting
vmap <silent><leader><Enter> <Plug>(EasyAlign)

" ctrlp setting
let g:ctrlp_by_filename = 1
" Fast CtrlP matcher based on python, performance difference is up to x22
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_extensions = ['buffertag', 'tag']
nnoremap <silent><leader>f :CtrlPBufTag<cr>
" disable default ctrlp action and always ctrlp project directory
let g:ctrlp_map = '<leader><C-p>'
let g:ctrlp_use_caching = 1
if filereadable(g:autoSessionFile)
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_cache_dir = g:origPwd
    nnoremap <C-p> :exec("CtrlP ".g:origPwd)<CR>
    if has("win32")
        let g:ctrlp_user_command = 'type %s\.projDirs'
    else
        let g:ctrlp_user_command = 'cat %s/.projDirs'
    endif
else
    let g:ctrlp_clear_cache_on_exit = 1
    nnoremap <C-p> :CtrlPCurWD<CR>
    let g:ctrlp_user_command = 'rg -g "" %s --files --color never'
endif

" GitGutter setting
let g:gitgutter_highlight_lines = 0
let g:gitgutter_eager = 0
let g:gitgutter_realtime = 0
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
nmap <leader>a <Plug>GitGutterStageHunk
nmap <leader>u <Plug>GitGutterUndoHunk

" wildfire
nmap <leader>s <Plug>(wildfire-quick-select)

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

"diff enhenced
" started In Diff-Mode set diffexpr (plugin not loaded yet)
if &diff
    let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
endif

if has('macunix')
    let g:clanglib='libclang.dylib'
else
    let g:clanglib='libclang.so.6'
endif
let g:chromatica#libclang_path=$HOME.'/.config/nvim/plugged/YouCompleteMe/third_party/ycmd/'.g:clanglib
let g:chromatica#enable_at_startup=1

au FileType c,cpp inoremap <silent><expr> ( complete_parameter#pre_complete("()")
let g:complete_parameter_use_ultisnips_mapping = 1

let g:asyncrun_rootmarks = ['.svn', '.git', '.root', '_darcs', 'build.xml']
let g:asyncrun_open = 10
let g:asyncrun_status = ''
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
nnoremap <silent> <F6> :AsyncRun -cwd=<root> make<cr>

" neovim terminal
tnoremap <Esc> <C-\><C-n>
tnoremap <A-q> <C-\><C-n><C-W>c
tnoremap <A-Q> <C-\><C-n><C-W>c
tnoremap <A-j> <C-\><C-n><C-W>j
tnoremap <A-k> <C-\><C-n><C-W>k
tnoremap <A-h> <C-\><C-n><C-W>h
tnoremap <A-l> <C-\><C-n><C-W>l
inoremap <A-j> <C-\><C-n><C-W>j
inoremap <A-k> <C-\><C-n><C-W>k
inoremap <A-h> <C-\><C-n><C-W>h
inoremap <A-l> <C-\><C-n><C-W>l
tnoremap <A-J> <C-\><C-n><C-W>j
tnoremap <A-K> <C-\><C-n><C-W>k
tnoremap <A-H> <C-\><C-n><C-W>h
tnoremap <A-L> <C-\><C-n><C-W>l
inoremap <A-J> <C-\><C-n><C-W>j
inoremap <A-K> <C-\><C-n><C-W>k
inoremap <A-H> <C-\><C-n><C-W>h
inoremap <A-L> <C-\><C-n><C-W>l

nnoremap <A-/> :BLines<CR>
nnoremap <A-b> :Buffers<CR>
nnoremap <A-B> :Buffers<CR>

"   :F  - Start fzf with hidden preview window that can be enabled with "?" key
"   :F! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* F
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)

"   :Fp  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Fp! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Fp
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>)." ".g:projectDirs, 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)

function! VisualProjectSearch() range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    :exe "Fp ".l:pattern
endfunction

function! VisualBufferSearch() range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    :exe "BLines ".l:pattern
endfunction

nmap <silent><leader>* :exe "Fp ".expand('<cword>')<CR>
vmap <silent><leader>* :call VisualProjectSearch()<CR>
nmap <silent><leader># :exe "BLines ".expand('<cword>')<CR>
vmap <silent><leader># :call VisualBufferSearch()<CR>

" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* Gg
            \ call fzf#vim#grep(
            \   'git grep --line-number '.shellescape(<q-args>), 0,
            \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

inoremap <expr> <c-x><c-k> fzf#vim#complete(
            \ {'source': 'cat '.dictDir.'words',
            \ 'options': ["--bind=alt-y:execute(echo {1} \| pbcopy)"],
            \ 'left': '20%'})

function! InsertWord()
    let l:pattern = escape(@+, '\\/.*$^~[]')
    let @+ = substitute(l:pattern, "\n$", " ", "")
    normal! "+p
    :exe "wincmd h"
    startinsert
    call feedkeys("\<A-BS>")
endfunction

tmap <silent><A-i> <C-\><C-n><C-W>l:call InsertWord()<CR>
imap <c-x><c-f> <plug>(fzf-complete-path)

let g:SimpylFold_docstring_preview=1

Glaive codefmt clang_format_style="{
            \ BasedOnStyle: google,
            \ Language : Cpp,
            \ AlignAfterOpenBracket : Align,
            \ AllowShortIfStatementsOnASingleLine : false,
            \ AlignConsecutiveAssignments : true,
            \ AlignConsecutiveDeclarations : true,
            \ BinPackArguments : false,
            \ BreakBeforeBraces : Stroustrup,
            \ IndentWidth : 4,
            \ ColumnLimit : 100,
            \ ReflowComments : true}"
autocmd FileType python AutoFormatBuffer yapf

vnoremap <silent>= :FormatLines<CR>:w<CR>
nnoremap <silent><leader>= :FormatCode<CR>:w<CR>
