let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Docker/opcua
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 docker-compose.yml
badd +1 python-opcua-client/client.py
badd +1 python-opcua-client/Dockerfile
badd +3 python-opcua-server/Dockerfile
badd +1 python-opcua-server/server.py
badd +0 python-opcua-server/logger_conf.yml
argglobal
silent! argdel *
$argadd docker-compose.yml
$argadd python-opcua-client/client.py
$argadd python-opcua-client/Dockerfile
$argadd python-opcua-server/Dockerfile
$argadd python-opcua-server/server.py
edit python-opcua-client/Dockerfile
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winminwidth=1 winheight=1 winwidth=1
exe '1resize ' . ((&lines * 25 + 26) / 53)
exe '2resize ' . ((&lines * 25 + 26) / 53)
argglobal
if bufexists('python-opcua-client/Dockerfile') | buffer python-opcua-client/Dockerfile | else | edit python-opcua-client/Dockerfile | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 12) / 25)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
argglobal
if bufexists('python-opcua-server/logger_conf.yml') | buffer python-opcua-server/logger_conf.yml | else | edit python-opcua-server/logger_conf.yml | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 12) / 25)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 25 + 26) / 53)
exe '2resize ' . ((&lines * 25 + 26) / 53)
tabnext 1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
