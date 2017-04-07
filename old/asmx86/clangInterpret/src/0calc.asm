;---------------------------
proc calc0
push	esi edi
mov	[last_n] , 0
;mov     [endstr] , 0


invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,sz
mov	[sop0] , eax
add	eax , sz
mov	[sop] , eax

invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,sz
mov	[sod0] , eax
add	eax , sz
mov	[sod] , eax


invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,10h
mov	dword[eax] , 0h

mov	edi , eax

mov	edx , esp
mov	esp , [sop]
push	edi
mov	[sop] , esp
mov	esp , edx


mov	esi , [se]
mov	esi , [esi]
.next0:

mov	esi , [esi]
mov	edi , [esi+4]

;-----------------------------
cmp	byte[edi] , T_hex_num
jne	.nhex_num0
push	eax esi
inc	edi
invoke	lstrlen,edi
mov	esi , eax
mov	eax , edi
dec	edi
call	str_hex
mov	[edi+1] , eax
pop	esi eax
jmp	.nhex_f0
.nhex_num0:
;-----------------------------
cmp	byte[edi] , T_hex_f
jne	.nhex_f0
push	eax esi
inc	edi
invoke	lstrlen,edi
mov	esi , eax
mov	eax , edi
dec	edi
call	str_hexf
mov	[edi+1] , eax
pop	esi eax
.nhex_f0:
;-----------------------------
;если перем. то найти и взять значение
;mov     edi , [esi+4]
cmp	byte[edi] , T_ident
jne	.nident

call	find_ident
test	eax , eax
jnz	.no_error
.error0:
pop	edi esi
xor	eax , eax
ret
.no_error:

mov	ecx , [eax+9]
mov	[edi+1] , ecx
mov	cl , [eax+8]
mov	byte[edi] , cl ; T_hex_num
.nident:
;-----------------------------


.noexit1:
;------------------------------
cmp	byte[edi] , T_hex_num
je	.hnf
cmp	byte[edi] , T_hex_f
je	.hnf
cmp	byte[edi] , T_str
je	.hnf

jmp	.no_hn

.hnf:
mov	edx , esp
mov	esp , [sod]
push	edi
mov	[sod] , esp
mov	esp , edx

jmp	.exit0
;------------------------------
.no_hn:

movzx	ecx , byte[edi]
mov	ebx , [sop]
mov	ebx , [ebx]
movzx	edx , byte[ebx]

mov	eax , t0m
mul	edx
add	eax , ecx
mov	ebx , t0
add	ebx , eax
mov	dl , byte[ebx]

cmp	dl , 1
je	.op_1
cmp	dl , 2
je	.op_2
cmp	dl , 3
je	.op_3
cmp	dl , 4
je	.op_4
cmp	dl , 5
je	.op_5
cmp	dl , 6
je	.op_6
cmp	dl , 7
je	.op_7
cmp	dl , 8
je	.op_8

cmp	dl , 9
je	.op_9
cmp	dl , 10
je	.op_10

;------------------
.op_1:
mov	edx , esp
mov	esp , [sop]
push	edi
mov	[sop] , esp
mov	esp , edx
jmp	.exit0
;------------------
.op_2:
mov	edx , esp
mov	esp , [sod]
pop	eax
mov	[sod] , esp
mov	esp , edx

push	eax

mov	edx , esp
mov	esp , [sop]
pop	eax
mov	[sop] , esp
mov	esp , edx

push	eax

mov	edx , esp
mov	esp , [sod]
pop	eax
mov	[sod] , esp
mov	esp , edx

push	eax

mov	edx , esp
mov	esp , [sop]
push	edi
mov	[sop] , esp
mov	esp , edx

call	calc_2_1

test	eax , eax
jz	.errort



mov	edx , esp
mov	esp , [sod]
push	edi
mov	[sod] , esp
mov	esp , edx

jmp	.exit0
;------------------
.op_3:
mov	edx , esp
mov	esp , [sop]
pop	eax
mov	[sop] , esp
mov	esp , edx
jmp	.exit0
;------------------
.op_4:
push	edi

mov	edx , esp
mov	esp , [sod]
pop	eax
mov	[sod] , esp
mov	esp , edx

push	eax

mov	edx , esp
mov	esp , [sop]
pop	eax
mov	[sop] , esp
mov	esp , edx

push	eax

mov	edx , esp
mov	esp , [sod]
pop	eax
mov	[sod] , esp
mov	esp , edx

push	eax

call	calc_2_1
test	eax , eax
jnz	.nerrort

pop	edi
jmp	.errort
.nerrort:

mov	edx , esp
mov	esp , [sod]
push	edi
mov	[sod] , esp
mov	esp , edx

pop	edi

jmp	.no_hn
;------------------
.op_5:
inc	[drw]
invoke	MessageBox,0,0,0,0
dec	[drw]
jmp	.exit0
;------------------
.op_6:
jmp	.exit1
;------------------
.op_7:
call	one_operand
jmp	.exit0
;------------------
.op_8:
call	one_operand
jmp	.no_hn
;------------------
.op_9:
call	one_operand_fun
jmp	.exit0
;------------------
.op_10:
call	one_operand_fun
jmp	.no_hn
;------------------

.exit0:
.next00:
cmp	dword[esi] , 0	 ; esi -1 ???!
jnz	.next0
mov	edi , nl
jmp	.no_hn
.exit1:

mov	edx , esp
mov	esp , [sod]
pop	eax
mov	[sod] , esp
mov	esp , edx

push	eax
;call    view_rez
pop	ebx

invoke GlobalHandle,[sop0]
invoke GlobalFree,eax
invoke GlobalHandle,[sod0]
invoke GlobalFree,eax

xor	eax , eax
inc	eax
.errort:
pop	edi esi
ret
endp


view_rez:
cmp	byte[eax] , T_hex_f
je	.nhn0
cmp	byte[eax] , T_hex_num
je	.hn0
cmp	byte[eax] , T_str
je	.str0

.hn0:
inc	eax
invoke	wsprintf,appname,fmt,dword[eax]
add	esp , 0Ch
inc	[drw]
invoke	MessageBox,[hwnd_m],appname,0,0
dec	[drw]
jmp	.exit00


.nhn0:
push	ebx edi esi
mov	ebx , eax
inc	ebx
finit
fld	dword[ebx]
fstcw	[CR]
and	[CR],not 110000000000b
or	[CR],010000000000b
fldcw	[CR]
frndint
fstcw	[CR]
and	[CR],not 110000000000b
fldcw	[CR]
fist	[b]
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,40h
mov	esi , eax
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,20h
mov	edi , eax
invoke	wsprintf,esi,fmt,[b]
add	esp , 0Ch
invoke	lstrcat,esi,sep
fld	dword[ebx]
fxch	st1
fsubp	st1 , st
fild	[f10]
fmulp	st1 , st
frndint
fist	[b]
invoke	wsprintf,edi,fmt,[b]
add	esp , 0Ch
invoke	lstrcat,esi,edi
inc	[drw]
invoke	MessageBox,[hwnd_m],esi,0,0
dec	[drw]
pop	esi edi ebx
jmp	.exit00


.str0:
;inc     eax
;inc     [drw]
;invoke  MessageBox,[hwnd_m],dword[eax],0,0
;dec     [drw]
jmp	.exit00

.exit00:
ret


one_operand:
		push	edi
mov	edx , esp
mov	esp , [sod]
pop	eax
mov	[sod] , esp
mov	esp , edx

push	eax

mov	edx , esp
mov	esp , [sop]
pop	edi
mov	[sop] , esp
mov	esp , edx

pop	eax
mov	eax , [eax+1]

xor	edi , edi
test	eax , eax
jnz	.sN1
inc	edi
.sN1:


invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,10h
mov	byte[eax] , T_hex_num
mov	[eax+1] , edi
mov	edi , eax

mov	edx , esp
mov	esp , [sod]
push	edi
mov	[sod] , esp
mov	esp , edx
		pop    edi
ret


one_operand_fun:
		push	edi
mov	edx , esp
mov	esp , [sod]
pop	eax
mov	[sod] , esp
mov	esp , edx

push	eax

mov	edx , esp
mov	esp , [sop]
pop	edi
mov	[sop] , esp
mov	esp , edx

pop	eax
;mov     ebx , [eax+1]
push	eax
;find fun
mov	eax , funs
mov	ebx , funa
inc	edi
call	getprocfun
pop	ebx
call	dword[eax]

;invoke  GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,10h
;mov     [eax+1] , edi
;mov     edi , eax

mov	edx , esp
mov	esp , [sod]
push	edi
mov	[sod] , esp
mov	esp , edx
		pop    edi
ret
