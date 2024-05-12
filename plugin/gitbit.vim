" gitbit.vim
if exists('g:loaded_gitbit') | finish | endif

command! Gitbit lua require'gitbit'.show_remote_path()
command! GitbitOpenRemote lua require'gitbit'.open_url()

let g:loaded_gitbit = 1
