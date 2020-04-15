"echom "hi"
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    "echom a:type
    let save_reg = @@
    if a:type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:type ==# 'char'
        execute "normal! `[v`]y"
    else
        return
    endif

    execute "grep! -R " . shellescape(@@) . " %"
    execute "normal! \<cr>"
    copen
    execute "normal! \<c-w>\<c-w>"

    let @@ = save_reg
endfunction

