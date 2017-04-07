proc calc_2_1 b,o,a:DWORD ; OUT edi
push	esi

mov	eax , [a]
cmp	byte[eax] , T_str
je	._str
cmp	byte[eax] , T_hex_f
je	.h
mov	eax , [eax+1]
mov	edx , [b]
cmp	byte[edx] , T_str
je	erroro
cmp	byte[edx] , T_hex_f
je	.h
mov	edx , [edx+1]


mov	ecx , [o]
cmp	byte[ecx] , T_plus
je	.oper_p
cmp	byte[ecx] , T_minus
je	.oper_m
cmp	byte[ecx] , T_mul
je	.oper_l
cmp	byte[ecx] , T_div
je	.oper_d
cmp	byte[ecx] , T_big
je	.oper_big
cmp	byte[ecx] , T_men
je	.oper_men
cmp	byte[ecx] , T_nbig
je	.oper_nbig
cmp	byte[ecx] , T_nmen
je	.oper_nmen
cmp	byte[ecx] , T_equl
je	.oper_equl
cmp	byte[ecx] , T_nequ
je	.oper_nequ
cmp	byte[ecx] , T_and
je	.oper_and
cmp	byte[ecx] , T_or
je	.oper_or


.oper_p:
add	eax , edx
mov	edi , eax
jmp	.exit_21
.oper_m:
sub	edx , eax
mov	edi , edx
jmp	.exit_21
.oper_l:
xchg	eax , edx
mul	edx
mov	edi , eax
jmp	.exit_21
.oper_d:
xchg	eax , edx
mov	ecx , edx
xor	edx , edx
div	ecx
mov	edi , eax
jmp	.exit_21
.oper_big:
xor	edi , edi
cmp	edx , eax
jng	.exit_21
inc	edi
jmp	.exit_21
.oper_men:
xor	edi , edi
cmp	edx , eax
jnl	.exit_21
inc	edi
jmp	.exit_21
.oper_nbig:
xor	edi , edi
cmp	eax , edx
jl	.exit_21
inc	edi
jmp	.exit_21
.oper_nmen:
xor	edi , edi
cmp	eax , edx
jg	.exit_21
inc	edi
jmp	.exit_21
.oper_equl:
xor	edi , edi
cmp	edx , eax
jne	.exit_21
inc	edi
jmp	.exit_21
.oper_nequ:
xor	edi , edi
cmp	edx , eax
je	.exit_21
inc	edi
jmp	.exit_21
.oper_and:
xor	edi , edi
test	eax , eax
jz	.exit_21
test	edx , edx
jz	.exit_21
inc	edi
jmp	.exit_21
.oper_or:
xor	edi , edi
test	eax , eax
jnz	.ne0
test	edx , edx
jnz	.ne0
jmp	.exit_21
.ne0:
inc	edi
jmp	.exit_21

.exit_21:


invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,10h
mov	byte[eax] , T_hex_num
mov	[eax+1] , edi
mov	edi , eax

jmp	.exit_end
;----------------------------------
.h:
finit

mov	eax , [a]
cmp	byte[eax] , T_hex_f
je	.ha
fild	dword[eax+1]
jmp	.nha
.ha:
fld	dword[eax+1]
.nha:

mov	eax , [b]
cmp	byte[eax] , T_hex_f
je	.ha0
fild	dword[eax+1]
jmp	.nha0
.ha0:
fld	dword[eax+1]
.nha0:

mov	ecx , [o]
cmp	byte[ecx] , T_plus
je	.oper_p0
cmp	byte[ecx] , T_minus
je	.oper_m0
cmp	byte[ecx] , T_mul
je	.oper_l0
cmp	byte[ecx] , T_div
je	.oper_d0
cmp	byte[ecx] , T_big
je	.foper_big
cmp	byte[ecx] , T_men
je	.foper_men
cmp	byte[ecx] , T_nbig
je	.foper_nbig
cmp	byte[ecx] , T_nmen
je	.foper_nmen
cmp	byte[ecx] , T_equl
je	.foper_equl
cmp	byte[ecx] , T_nequ
je	.foper_nequ

xor	eax , eax
jmp	erroro


.oper_p0:
fadd	st , st1
fstp	[b]
mov	edi , [b]
jmp	.exit_22
.oper_m0:
fsub	st , st1
fstp	[b]
mov	edi , [b]
jmp	.exit_22
.oper_l0:
fmul	st , st1
fstp	[b]
mov	edi , [b]
jmp	.exit_22
.oper_d0:
fdiv	st , st1
fstp	[b]
mov	edi , [b]
jmp	.exit_22

.foper_big:
xor	edi , edi
fcom
fstsw	ax
sahf
jz	 .exit_21
 jnc	 .bigf
 jmp	 .exit_21
.bigf:
inc	edi
jmp	.exit_21 ; Результат целое

.foper_men:
xor	edi , edi
fcom
fstsw	ax
sahf
 jc	.menf
 jmp	 .exit_21
.menf:
inc	edi
jmp	.exit_21

.foper_equl:
xor	edi , edi
fcom
fstsw	ax
sahf
jz	.equf
jmp	.exit_21
.equf:
inc	edi
jmp	.exit_21

.foper_nequ:
xor	edi , edi
fcom
fstsw	ax
sahf
jnz	.nequf
jmp	.exit_21
.nequf:
inc	edi
jmp	.exit_21

.foper_nbig:
xor	edi , edi
fcom
fstsw	ax
sahf
jz	 .nbigf
 jc	.nbigf
 jmp	 .exit_21
.nbigf:
inc	edi
jmp	.exit_21

.foper_nmen:
xor	edi , edi
fcom
fstsw	ax
sahf
 jnc	 .nmenf
 jmp	 .exit_21
.nmenf:
inc	edi
jmp	.exit_21


.exit_22:
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,6h
mov	byte[eax] , T_hex_f
mov	[eax+1] , edi
mov	edi , eax

jmp	.exit_23

._str:
mov	eax , [b]
cmp	byte[eax] , T_str
jne	erroro

mov	ecx , [o]
cmp	byte[ecx] , T_plus
je	.str_plus
xor	eax , eax
jmp	erroro
.str_plus:
xor	edi , edi
mov	eax , [a]
invoke	lstrlen,dword[eax+1]
add	edi , eax
mov	eax , [b]
invoke	lstrlen,dword[eax+1]
add	edi , eax
inc	edi
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,5
mov	esi , eax
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,edi
mov	byte[esi] , T_str
mov	edi , eax
mov	eax , [b]
mov	eax , dword[eax+1]
invoke	lstrcat,edi,eax
mov	eax , [a]
mov	eax , dword[eax+1]
invoke	lstrcat,edi,eax
mov	dword[esi+1] , edi
mov	edi , esi
;jmp     .exit_23
.exit_23:



jmp	.exit_end
;----------------------------------

.exit_end:

;invoke  GlobalHandle,[a]
;invoke  GlobalFree,eax
;invoke  GlobalHandle,[b]
;invoke  GlobalFree,eax
;invoke  GlobalHandle,[o]
;invoke  GlobalFree,eax


xor	eax , eax
inc	eax
jmp	exit
erroro:
xor	eax , eax
exit:
pop	esi
ret
endp
