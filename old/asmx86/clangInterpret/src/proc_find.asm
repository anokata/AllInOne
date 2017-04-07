;----------------------------------------------------
proc find1 ;in edi-str sv  out eax bool
push    esi edi

mov     esi , [sv]

mov     esi , [esi]
test    esi , esi
jz      .nofind1

inc     edi

.nextfind:

invoke  lstrcmp,dword[esi+4],edi
test    eax , eax
jz      .find

mov     esi , [esi]
test    esi , esi
jnz     .nextfind

.nofind1:

xor     eax , eax
dec     eax
.find:
not     eax

dec     edi

pop     edi esi
ret
endp

proc findu ;in edi-str ebx funs,ktyp  out eax bool

mov     ebx , ebx
inc     edi

.nextfind:

invoke  lstrcmp,ebx,edi
test    eax , eax
jz      .find

invoke  lstrlen,ebx
inc     eax
add     ebx , eax

cmp     byte[ebx],0
jnz     .nextfind

xor     eax , eax
dec     eax
.find:
not     eax

dec     edi
ret
endp


                          