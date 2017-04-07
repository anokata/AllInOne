proc str_hexf
;in - eax str  , esi - len
;out - eax num
push	edi esi
mov	edi , eax
push	eax

;------------------------
mov	bl , byte[edi]
cmp	bl , '-'
jne	.no_otr
mov	byte[m] , 1
jmp	.end_otr
.no_otr:
mov	byte[m] , 0
.end_otr:
;------------------------

mov	eax , '.'
cld
mov	ecx , esi
repnz scasb
dec	edi
mov	byte[edi] , 0

pop	eax
push	eax
push	ecx
push	esi
sub	esi , ecx
dec	esi

call	str_hex

pop	esi
pop	ecx
pop	edi
push	ecx
mov	ecx , esi

finit
mov	[b] , eax
fild	[b]

xor	eax , eax
cld
repnz scasb
mov	byte[edi-1] , '.'

mov	eax , edi
pop	esi

call	str_hexf0
;fild    [b]

;fadd    st , st1



pop	esi edi
ret
endp


;-------------------
str_hexf0:
push	edi
mov	edi , eax
xor	ecx , ecx
xor	eax , eax
mov	[b] , eax
fild	[b]

._next_hdig:
movzx	ebx , byte[edi]
test	ebx , ebx
jz	.exit0

  cmp	  bl , 40h
  jg	  ._abcdef
   sub	   bl , 30h
  jmp	  ._0123
  ._abcdef:

  cmp	  bl , 60h
  jl	  ._noABCDEF
  sub	  bl , 57h
  jmp	  ._0123
  ._noABCDEF:
  sub	  bl , 37h


  ._0123:

mov	[b] , ebx
fild	[b]

fld	[f1]
fld	[f16]
mov	ebx , ecx

.div16:
test	ebx , ebx
jz	.div16exit

fdiv	st1 , st
dec	ebx
jmp	.div16

.div16exit:
fdivp	st1 , st

fmulp	st1 , st

faddp	st1 , st

inc	ecx
inc	edi

jmp	._next_hdig
.exit0:
;--------------------
cmp	byte[m] , 0
jz	.nom1
fld	[fm1]
fmulp	st1 , st
;--------------------
.nom1:
fadd	st ,st1
fst	[b]
mov	eax , [b]
;--------------------
pop	edi
ret
