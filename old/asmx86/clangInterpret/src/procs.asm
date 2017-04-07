P_out: ; in ebx
mov	eax , ebx

cmp	byte[eax] , T_hex_f
je	.nhn0
cmp	byte[eax] , T_hex_num
je	.hn0
cmp	byte[eax] , T_str
je	.str0

.hn0:
inc	eax

;signed
mov	edx , dword[eax]
cmp	edx , imax
jb	.neotr	;   below
not	edx
inc	edx
invoke	wsprintf,appname+1,fmt,edx
add	esp , 0Ch
mov	byte[appname] , '-'
jmp	.send
.neotr:
invoke	wsprintf,appname,fmt,edx
add	esp , 0Ch
.send:

inc	[drw]
invoke	SendMessage,[hwnd_l0],LB_ADDSTRING,0,appname
dec	[drw]
jmp	.exit00


.nhn0:		    ;из 0 вычесть
push	esi edi
mov	ebx , eax
inc	ebx
finit
fld	dword[ebx]
;------------------
;fld     [fmax]
fcom   [fmax]
fstsw	ax
sahf
 jae	 .menf0
 mov	 [S] , 1
 fldz
 fsub	 st , st1
 fst	 dword[G]
 jmp	 .nmenf
.menf0:
mov	[S] , 0
fst	dword[G]
.nmenf:
;------------------
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
;----
cmp	[S] , 0
jz	.nominus

inc	esi
invoke	wsprintf,esi,fmt,[b]
add	esp , 0Ch
dec	esi
mov	byte[esi] , '-'
jmp	.exit

.nominus:
invoke	wsprintf,esi,fmt,[b]
add	esp , 0Ch
.exit:

invoke	lstrcat,esi,sep
fld	[G];dword[ebx]
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
invoke SendMessage,[hwnd_l0],LB_ADDSTRING,0,esi
dec	[drw]
pop	edi esi
jmp	.exit00


.str0:
inc	eax
invoke	SendMessage,[hwnd_l0],LB_ADDSTRING,0,dword[eax]
jmp	.exit00

.exit00:

ret

P_in:


ret

;========================
F_sqrt:
cmp	byte[ebx] , T_hex_num
je	.hns
cmp	byte[ebx] , T_hex_f
je	.hfs


.hfs:
fld	dword[ebx+1]
fsqrt
fst	dword[ebx+1]
jmp	.exits
.hns:
fild	dword[ebx+1]
fsqrt
fst	dword[ebx+1]
mov	byte[ebx] , T_hex_f
;jmp     .exits

.exits:
mov	edi , ebx
ret


F_min:

ret
;========================

getprocfun: ;in eax - procs or funs ebx - proca or funa edi - name
push	esi
mov	esi , ebx
mov	ebx , eax

.nextfind:

invoke	lstrcmp,ebx,edi
test	eax , eax
jz	.find

invoke	lstrlen,ebx
inc	eax
add	ebx , eax
add	esi , 4

cmp	byte[ebx],0
jnz	.nextfind

.find:
mov	eax , esi
pop	esi

ret