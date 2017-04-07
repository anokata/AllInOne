proc vvar s:DWORD;sv
push ebx edi
mov	ebx , [s]

invoke SendMessage,[hwnd_l1],LB_RESETCONTENT,0,0

invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,sz
mov	edi , eax

test	ebx , ebx
jz	.exit
mov	ebx , [ebx]
test	ebx , ebx
jz	.exit
.next:
invoke	lstrcpy,edi,dword[ebx+4]
invoke	lstrcat,edi,spc

cmp	byte[ebx+8] , T_hex_num
je	.hn
cmp	byte[ebx+8] , T_hex_f
je	.hf
cmp	byte[ebx+8] , T_str
je	.str

.hn:
mov	edx , dword[ebx+9]
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
invoke	lstrcat,edi,appname
jmp	.view
.hf:
;-------------------------
finit
fld	dword[ebx+9]
;------------------
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
;----
cmp	[S] , 0
jz	.nominus

invoke	wsprintf,appname+1,fmt,[b]
add	esp , 0Ch
mov	byte[appname] , '-'
jmp	.exit0

.nominus:
invoke	wsprintf,appname,fmt,[b]
add	esp , 0Ch
.exit0:

invoke	lstrcat,appname,sep
fld	[G];dword[ebx+9]
fxch	st1
fsubp	st1 , st
fild	[f10]
fmulp	st1 , st
frndint
fist	[b]
invoke	wsprintf,appnam0,fmt,[b]
add	esp , 0Ch
invoke	lstrcat,appname,appnam0

invoke	lstrcat,edi,appname

jmp	.view
;-------------------------
.str:
invoke	lstrcat,edi,dword[ebx+9]

.view:
invoke SendMessage,[hwnd_l1],LB_ADDSTRING,0,edi

mov	ebx , [ebx]
test	ebx , ebx
jnz	.next


.exit:
invoke	GlobalHandle,edi
invoke	GlobalFree,eax
pop	edi ebx
ret
endp