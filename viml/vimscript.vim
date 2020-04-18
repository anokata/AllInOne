function DisplayName(name)
echom "hi my name is:"
echom a:name
endfunction

call DisplayName("Danny foo")


function UDisplayName(name)
echom "hi my name is:"
echom name
endfunction

call UDisplayName("Danny")

function! Varg(...)
"len
echom a:0 
" first arg
echom a:1 
" all
echo a:000 
endfunction

call Varg("a", "b")

function! Varg2(x, ...)
echom a:x 
"len
echom a:0 
" first arg
echom a:1 
" all
echo a:000 
endfunction

call Varg2("a", "b", "C")

function! Assign(x)
let a:x = "some"
echom a:x
endfunction

call Assign("none")


function! Assign2(x)
let y = a:x
let y = "some"
echom a:x
echom y
endfunction

call Assign2("none")

echom 0xff
echom 010
echom 100.1
echo 100.1
echo 3.14e-3
echo 2.7e2
echo 2 * 3.0
echo 3/2
echo 3/2.0

not echom "Hello " + "many worlds"
echom "Hello " . "many worlds"
echom 10 . " some"
echom "abc\"def\"/\\"
echo "new\nline"
" exact that with ''
echom '\\ab''\n'
echo "a\tb"

<c-v> in insert will insert special key as is
ÿ

echom strlen("asklfjas;fjsdlfjsdlfjasklf")
echom len("asklfjas;fjsdlfjsdlfjasklf")
echom len(123)
echo split('ab cd ef gh')
echo split('ab|cd|ef|g|h', '|')
echo join(['a','b','c'], '/')
echo join(split("some len with words in the middle"), ".")
echo tolower("DLFjsdlfjsdlfjLJDLJFL")
echo toupper("DLFjsdlfjsdlfjLJDLJFL")
echo split('a,b', ',')
echo split('1 2')
echo split('1,,,2', ',')
echo split("abdasf123", '\zs')

execute "echom 'Hi there!'"
execute "rightbelow vsplit " . bufname("#")
normal ggdd
" exe normal mode key withou any mappings
normal! G
"execute "normal! /foo\<cr\>"
nnoremap <leader>d dddd
nnoremap <leader>d :execute "normal! dd" <cr>:exe "normal! dd" <cr>
nnoremap <leader>d :normal! dd <cr> :normal! dd <cr>

execute "normal! gg/foo\<cr>dd"
execute "normal! mqA;\<esc>`q"

let a=':execute "normal! mqA;\<esc>`q"'
echo a
execute a

let b=":echo 'hi'"
echo b
execute b
" ?
nnoremap aa :execute ':execute "normal! mqA;\<esc>`q"'
nnoremap aa :let a=':execute "normal! mqA;\<esc>`q"';
nnoremap aa :normal! mqA;<esc>a`q

function! _Add_semi()
let cmd=':execute "normal! mqA;\<esc>`q"'
echo cmd
execute cmd
endfunction
nnoremap aa :call _Add_semi()<cr>


max = 10

print "Starting"

for i in range(max):
print "Counter:", i

print "Done"

set hlsearch incsearch
execute "normal! gg/print\<cr>"
execute "normal! G?print\<cr>"
" Regexp
execute "normal! gg/for .+ in .+:\<cr>"
execute "normal! gg/for .\\+ in .\\+:\<cr>"
execute 'normal! gg/for .\+ in .\+:\<cr>'
execute "normal! gg" . '/for .\+ in .\+:' . "\<cr>"
execute "normal! gg" . '/\vfor .+ in .+:' . "\<cr>"  

" highlight trailing spaces     
match Error /\v +$/
match none
nnoremap / /\\v
grep some %
cope

nnoremap <leader>g :grep -R something .<cr>
nnoremap <leader>g :grep -R <cword> %<cr>
nnoremap <leader>g :grep -R '<cword>' %<cr><cr>:cope<cr>
foo;ls that's

nnoremap <leader>g :execute "grep -R " . shellescape("<cWORD>") . " %"<cr><cr>:cope<cr>
echom shellescape("<cword>")
echom shellescape(expand("<cword>"))
nnoremap <leader>g :execute "grep! -R " . shellescape(expand("<cWORD>")) . " %"<cr><cr>:cope<cr>

nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " %"<cr>:cope<cr>
nnoremap <leader>g :execute "grep! -R " . shellescape(expand("<cWORD>")) . " %"<cr><cr>:cope<cr><c-w><c-w>
nnoremap <leader>n :cnext<cr>
nnoremap <leader>l :cclose<cr>
"plugin

let b = ['foo', 3, 'bar', ['some']]
echo b
echo ['foo', 3, 'bar', ['some']][0]
echo ['foo', 3, 'bar', ['some']][3]
echo ['foo', 3, 'bar', ['some']][-1][0]
echo a[2]
let a = split("abcdef", '\zs')
echo a[0:2]
echo a[-2:-1]
echo a[-1:-1]
echo "abcd"[1]
echo a[:3]
echo a[3:]
echo "abcd"[1:2]
echo "abcd"[-1:]
echo a + b
echo [1,2] + ['c', 'd']
call add(a, 'e') | echo a
echo len(a)
echo get(a, 1, 'default')
echo get(a, 100, 'default')
echo index(a, 'f')
echo index(a, 'no')
echo join(a)
echo join(a, '-')
echo join([1,2,3], '')
call reverse(a) | echo a

python print("hi")

let c = 0
for i in [1,2,3,4]
    let c += i
endfor
echom c

let c = 0
let total = 0
while c <= 4
    let total += c
    let c += 1
endwhile
echom total

echo {'a': 34, 100: 'abc'}
echo {'a': 34, 100: 'abc',}
let d = {'a': 34, 100: 'abc', 18:'add', 'a2':'dd'}
echo d
echo d['18']
echo d[123]
echo d.a
echo d.18
echo d.a2
let d.a = 8 | echo d
let d.b = 9 | echo d
unlet d.a | echo d
let x = remove(d, 'b') | echo x

echom get(d, 'a', 'def')
echom has_key(d, 'a')
echo items(d)
echo keys(d)
echo values(d)

nnoremap <leader>f :call FoldColumnToggle()<cr>

function! FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction

nnoremap <leader>q :call <SID>QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! s:QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

" Paths
echom expand('%')
echom expand('%:p')
echom fnamemodify('foo.txt', ':p')

echo globpath('.', '*')
echo split(globpath('.', '*'), '\n')
echo split(globpath('~', '*.png'), '\n')
" recursive
echo split(globpath('/boot', '**'), '\n')

source test.vim
let filename="test.vim"
execute "source ". filename

echom &runtimepath
let &runtimepath=&runtimepath . "," . "/home/ksi/dev/allInOne/viml"
color mycolor

function! Insertpwd()
    let p = expand("%:p:h")
    execute "normal! i" . p
endfunction

nnoremap <leader>d :execute "normal! a" . expand("%:p:h")<cr>



