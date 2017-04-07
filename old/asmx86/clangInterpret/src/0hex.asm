proc str_hex
;in - eax str  , esi - len
;out - eax num
push	edi
mov	edi , eax
xor	eax , eax
cld
;al - 0
mov	ecx , esi
repnz scasb

dec	edi
xor	ecx , ecx

mov	edx , esi
;------------------------
mov	ebx , edi
sub	ebx , edx
inc	ebx
mov	bl , byte[ebx]
cmp	bl , '-'
jne	.no_otr
push	dword 0
dec	edx
jmp	.end_otr
.no_otr:
push	dword 1
.end_otr:
;------------------------

_next_hdig:
movzx	ebx , byte[edi]

  cmp	  bl , 40h
  jg	  _abcdef
   sub	   bl , 30h
  jmp	   _0123
  _abcdef:

  cmp	  bl , 60h
  jl	  _noABCDEF
  sub	  bl , 57h
  jmp	   _0123
  _noABCDEF:
  sub	  bl , 37h


  _0123:
shl	ebx , cl
add	ecx , 4
add	eax , ebx
dec	edi

dec	edx
jnz	_next_hdig

;--------------------
pop	edx
test	edx , edx
jnz	.no_set_otr
sub	edx , eax
mov	eax , edx

.no_set_otr:
;--------------------

pop	edi
ret
endp
