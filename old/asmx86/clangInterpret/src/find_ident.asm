proc find_ident
inc	edi

mov	ebx , [sv]

.next:
mov	ebx , [ebx]
test	ebx , ebx
jz	.no_find
invoke	lstrcmp,edi,dword[ebx+4]
test	eax , eax
jz	.findit
jmp	.next

.no_find:
xor	eax , eax
ret

.findit:
mov	eax , ebx

dec	edi
ret
endp