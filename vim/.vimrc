call plug#begin()
Plug 'davidhalter/jedi-vim'
Plug 'tpope/vim-sensible'
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ervandew/supertab'
call plug#end()

set number
set nowrap
set winheight=45

" On-demand loading
nmap <F8> :TagbarToggle<CR>
nmap <F7> :NERDTreeToggle<CR>

inoremap ññ <ESC>
nnoremap <SPACE> viw
vnoremap <SPACE> iw
vnoremap ññ <ESC>
inoremap ñl <ESC>l%%a
nnoremap ñl l%%a
inoremap ñh <ESC>%i

vnoremap // y/<C-R>"<CR>N

inoremap ( ()<ESC>i
inoremap { {}<ESC>i
inoremap [ []<ESC>i
inoremap " ""<ESC>i
inoremap ' ''<ESC>i
inoremap <lt> <lt>><ESC>i

let s:lsp_ft_maps = 'gdscript,go,python,c'
let g:tagbar_sort = 0

autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

function ScrollPopup(up=0)
  if (len(popup_list()) >= 1)
    let popid = popup_list()[0]
    let firstline = popup_getoptions(popid)['firstline']
    if (a:up)
      call popup_setoptions(popid, {'firstline': max([1, firstline-1])})
    else
      call popup_setoptions(popid, {'firstline': firstline+1})
    endif
  endif
endfunc

nnoremap , :call ScrollPopup()<CR>
nnoremap _ :call ScrollPopup(1)<CR>

def WipeoutTerminals()
    for buf_nr in term_list()
        exe "bw! " .. buf_nr
    endfor
enddef

augroup enter_vim
	autocmd!
	autocmd VimEnter * NERDTree | wincmd p
	autocmd VimEnter * TagbarToggle
	autocmd VimEnter * bo term ++close
augroup END

function ExitVim(session=0)
  call WipeoutTerminals()
  NERDTreeClose
  TagbarToggle
  if (a:session)
    mks!
  endif
  wqa
endfunc

command Qs call ExitVim(1)
command Qns call ExitVim(0)

let &winheight = float2nr(winheight(0)/1.5)
let g:nerdtree_tabs_synchronize_view=0
let g:nerdtree_tabs_open_on_console_startup=1
let g:nerdtree_tabs_open_on_new_tab=1
let g:nerdtree_tabs_meaningful_tab_names=1
let g:nerdtree_tabs_toggle=1
let g:nerdtree_tabs_autoclose=1
let g:SuperTabDefaultCompletionType = "<c-n>"
