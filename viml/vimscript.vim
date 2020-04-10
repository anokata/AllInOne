function DisplayName(name)
    echom "hi my name is:"
    echom a:name
endfunction

call DisplayName("Danny")


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



