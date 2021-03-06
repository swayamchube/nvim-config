" VimTeX - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#view#mupdf#new() abort " {{{1
  " Check if the viewer is executable
  if !executable('mupdf')
    call vimtex#log#error(
          \ 'MuPDF is not executable!',
          \ '- VimTeX viewer will not work!')
    return {}
  endif

  " Add reverse search mapping
  nnoremap <buffer> <plug>(vimtex-reverse-search)
        \ :<c-u>call b:vimtex.viewer.reverse_search()<cr>

  return vimtex#view#_template_xwin#apply(deepcopy(s:mupdf))
endfunction

" }}}1


let s:mupdf = {
      \ 'name': 'MuPDF',
      \}

function! s:mupdf.start(outfile) dict abort " {{{1
  let l:cmd = 'mupdf'
  if !empty(g:vimtex_view_mupdf_options)
    let l:cmd .= ' ' . g:vimtex_view_mupdf_options
  endif
  let l:cmd .= ' ' . vimtex#util#shellescape(a:outfile)

  let self.job = vimtex#jobs#start(l:cmd)

  call self.xwin_get_id()
  call self.xwin_send_keys(g:vimtex_view_mupdf_send_keys)

  if g:vimtex_view_forward_search_on_start
    call self.forward_search(a:outfile)
  endif
endfunction

" }}}1
function! s:mupdf.forward_search(outfile) dict abort " {{{1
  if !executable('xdotool') | return | endif
  if !executable('synctex') | return | endif

  let self.cmd_synctex_view = 'synctex view -i '
        \ . (line('.') + 1) . ':'
        \ . (col('.') + 1) . ':'
        \ . vimtex#util#shellescape(expand('%:p'))
        \ . ' -o ' . vimtex#util#shellescape(a:outfile)
        \ . " | grep -m1 'Page:' | sed 's/Page://' | tr -d '\n'"
  let self.page = vimtex#jobs#capture(self.cmd_synctex_view)[0]

  if self.page > 0
    let self.cmd_forward_search = 'xdotool'
          \ . ' type --window ' . self.xwin_id
          \ . ' "' . self.page . 'g"'
    call vimtex#jobs#run(self.cmd_forward_search)
  endif

  call self.focus_viewer()
endfunction

" }}}1
function! s:mupdf.latexmk_append_argument() dict abort " {{{1
  if g:vimtex_view_use_temp_files
    let cmd = ' -view=none'
  else
    let cmd  = vimtex#compiler#latexmk#wrap_option('new_viewer_always', '0')
    let cmd .= vimtex#compiler#latexmk#wrap_option('pdf_update_method', '2')
    let cmd .= vimtex#compiler#latexmk#wrap_option('pdf_update_signal', 'SIGHUP')
    let cmd .= vimtex#compiler#latexmk#wrap_option('pdf_previewer',
          \ 'mupdf ' .  g:vimtex_view_mupdf_options)
  endif

  return cmd
endfunction

" }}}1
function! s:mupdf.reverse_search() dict abort " {{{1
  if !executable('xdotool') | return | endif
  if !executable('synctex') | return | endif

  let outfile = self.out()
  if vimtex#view#not_readable(outfile) | return | endif

  if !self.xwin_exists()
    call vimtex#log#warning('Reverse search failed (is MuPDF open?)')
    return
  endif

  " Get page number
  let self.cmd_getpage
        \ = 'xdotool getwindowname ' . self.xwin_id
        \ . "| sed 's:.* - \\([0-9]*\\)/.*:\\1:'"
        \ . "| tr -d '\n'"
  let self.page = vimtex#jobs#capture(self.cmd_getpage)[0]
  if self.page <= 0 | return | endif

  " Get file
  let self.cmd_getfile  = 'synctex edit '
        \ . "-o \"" . self.page . ':288:108:' . outfile . "\""
        \ . "| grep 'Input:' | sed 's/Input://' "
        \ . "| head -n1 | tr -d '\n' 2>/dev/null"
  let self.file = vimtex#jobs#capture(self.cmd_getfile)[0]

  " Get line
  let self.cmd_getline  = 'synctex edit '
        \ . "-o \"" . self.page . ':288:108:' . outfile . "\""
        \ . "| grep -m1 'Line:' | sed 's/Line://' "
        \ . "| head -n1 | tr -d '\n'"
  let self.line = vimtex#jobs#capture(self.cmd_getline)[0]

  " Go to file and line
  silent exec 'edit ' . fnameescape(self.file)
  if self.line > 0
    silent exec ':' . self.line
    " Unfold, move to top line to correspond to top pdf line, and go to end of
    " line in case the corresponding pdf line begins on previous pdf page.
    normal! zvztg_
  endif
endfunction

" }}}1
function! s:mupdf.compiler_callback() dict abort " {{{1
  call self.xwin_send_keys('r')
endfunction

" }}}1
