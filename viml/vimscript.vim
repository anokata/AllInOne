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
nnoremap <leader>d :exe "normal! dd" <cr>:exe "normal! dd" <cr>
nnoremap <leader>d :normal! dd <cr> :normal! dd <cr>


