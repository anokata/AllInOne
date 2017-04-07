proc syn    ; in edi-lexem
				;0040274D
cmp    [statesyn] , 0
je     .ss0
cmp    [statesyn] , 1
je     .ss1
cmp    [statesyn] , 2
je     .ss2
cmp    [statesyn] , 5
je     .ss5
cmp    [statesyn] , 6
je     .ss6
cmp    [statesyn] , 8
je     .ss8
cmp    [statesyn] , 9
je     .ss9
cmp    [statesyn] , 0Ah
je     .ss0Ah
;cmp    [statesyn] , 10h
;je     .ss10h
cmp    [statesyn] , 11h
je     .ss11h
cmp    [statesyn] , 12h
je     .ss12h
cmp    [statesyn] , 13h
je     .ss13h
cmp    [statesyn] , 14h
je     .ss14h
cmp    [statesyn] , 15h
je     .ss15h
cmp    [statesyn] , 16h
je     .ss16h

jmp	.exitsyn
;-----------------------------

;======================================   1+(30/(0a+6)+-2)  n o ( )
.ss0:
cmp	byte[edi] , T_ident
je	.ident
;cmp     byte[edi] , T_funs
;je      .funs0
cmp	byte[edi] , T_proc
je	.funs0
cmp	byte[edi] , T_key_word
je	.key_word
cmp	byte[edi] , T_skobk_2
je	.skobk_2


jmp	.exitsyn
;-----------------------
.ident:
 call	find1
 test	eax , eax
 jz	.not_def_ident
 ;def ident
 mov	[sfsyn] , edi
 mov	[statesyn] , 2

 jmp	 .exitsyn
 .not_def_ident:
 mov	[sfsyn] , edi
 mov	[statesyn] , 1
 jmp	 .exitsyn


jmp	.exitsyn
;-----------------------
.funs0:
mov	[statesyn] , 5
mov	[sfsyn] , nls;edi
push	8
push	se
call	CreateSG

push	se
call	AddSG
mov	[eax+4] , edi

jmp	.exitsyn
;-----------------------
.key_word:
inc	edi
invoke	lstrcmp,edi,k0;if ?
dec	edi
test	eax , eax
jnz	.noif

mov	[statesyn] , 8
push	8
push	se
call	CreateSG
mov	[sfsyn] , edi
push	se
call	AddSG
mov	[eax+4] , edi
jmp	.exitsyn

.noif:

inc	edi
invoke	lstrcmp,edi,k2;for ?
dec	edi
test	eax , eax
jnz	.nofor

mov	[statesyn] , 11h
push	8
push	se
call	CreateSG
mov	[sfsyn] , edi
push	se
call	AddSG
mov	[eax+4] , edi

push	esi
push	for_e
call	push_s
push	[line]
push	for_e
call	push_s

jmp	.exitsyn

.nofor:

jmp	.exitsyn
;-----------------------
.skobk_2:
mov	[statesyn] , 15h
jmp	.exitsyn
;-----------------------

jmp	.exitsyn
;======================================
.ss1:
cmp	byte[edi] , T_key_word
je	.key_word0
; error!
jmp	.ss0Ah
jmp	.exitsyn
;-----------------------
.key_word0:
 mov	ebx , ktyp
 call	findu
 test	eax , eax
 jz	.ntyp

 ; вывод объ€вл. перем.

 jmp	 .ss30h

 jmp	 .exitsyn
 .ntyp:
 ; error!
 jmp	 .ss0Ah
 jmp	 .exitsyn


jmp	.exitsyn
;======================================
.ss0Ah:
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,20h
mov	ebx , eax
inc	edi
invoke	wsprintf,ebx,mes0,[line],edi
add	esp , 10h
dec	edi

mov    [drw] , 0

invoke	MessageBox,[hwnd_m],ebx,0,0
invoke	GlobalHandle,ebx
invoke	GlobalFree,eax
xor	eax , eax
ret

jmp	.exitsyn
;======================================
.ss30h:
mov	[statesyn] , 0

   ;if
   push sif0
   push sif
   call read_s
   cmp	[rez] , 0
   jz	.exitsyn

invoke	lstrlen,[sfsyn]
mov	ebx , eax
invoke	lstrlen,edi
add	ebx , eax
inc	ebx
inc	ebx
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,ebx
mov	ebx , eax
invoke	lstrcpy,ebx,[sfsyn]
invoke	lstrcat,ebx,nnull
invoke	lstrcat,ebx,edi

push	sx
call	AddSG
mov	[eax+4] , ebx
;invoke SendMessage,[hwnd_l0],LB_ADDSTRING,0,ebx

push	sv
call	AddSG
mov	ecx , [sfsyn]
inc	ecx
mov	[eax+4] , ecx
;mov     bl , [ecx-1]     ; определ€ть тип !!!
;mov     bl , [edi]
push	eax
inc	edi
invoke	lstrcmp,tstr,edi
 ;dec    edi
test	eax , eax
jnz	.num

pop	eax
mov	byte[eax+8] , T_str
jmp	.exitsyn
.num:

cmp	byte[edi] , 'f'       ; ≈—Ћ» Ѕ”ƒ≈Ў№ ƒќЅј¬Ћя“№
			      ;“»ѕџ Ё“ќ ћ≈—“ќ ѕ≈–≈ƒ≈Ћј…
jz	.fnum		      ; на поиск

pop	eax
mov	byte[eax+8] , T_hex_num;bl
jmp	.exitsyn

.fnum:
pop	eax
mov	byte[eax+8] , T_hex_f

jmp	.exitsyn
;======================================
.ss2:
cmp	byte[edi+1] , '='
jne	.ss0Ah
mov	[statesyn] , 5
push	8
push	se
call	CreateSG

push	se
call	AddSG
mov	[eax+4] , edi

jmp	.exitsyn
;======================================
.ss5:  ; var const oper+-*/() "str" 1 1.0 > < fun
call   podC    ;++++++++++++++++++++++++++++++++++++++
test   eax , eax
jnz    .podxodit


cmp    byte[edi] , T_tockkaz
je     .tz

cmp    byte[edi] , T_cm
je     .cm0


push	se
call	DestroySG
jmp	.ss0Ah
;--------------------
.podxodit:
push	se
call	AddSG
mov	[eax+4] , edi
jmp	.exitsyn
.tz:
;!!!!!!!!!!!!!!!!!!!считать
; in se
call	calc0
test	eax , eax
jnz	.no_error
jmp	.ss0Ah
.no_error:
push	ebx
mov	edi , [sfsyn]
	cmp	byte[edi] , T_ident
	je	.pident
mov	edi , [se]
mov	edi , [edi]
mov	edi , [edi+4]
	cmp	byte[edi] , T_proc
	je	.pproc

	jmp	.end_i_
.pident:
call	find_ident
pop	ebx
cmp	byte[ebx] , T_str
je	.strp

;cmp     byte[eax+8] , T_str ;результат число знач. перем. должна быть не сторока
;je      .ss0Ah
mov	cl , byte[ebx]
cmp	byte[eax+8] , cl
jne	.ss0Ah

   ;if
   push sif0
   push sif
   call read_s
   cmp	[rez] , 0
   jz	.no_exec0

mov	ecx , [ebx+1]
mov	[eax+9] , ecx
mov	cl , byte[ebx]
mov	byte[eax+8] , cl

.no_exec0:

jmp	.end_i_
.strp:
;cmp     byte[eax+8] , T_str ;результат сторока знач. перем. должна быть сторока
;jne     .ss0Ah
mov	cl , byte[ebx]
cmp	byte[eax+8] , cl
jne	.ss0Ah

   ;if
   push sif0
   push sif
   call read_s
   cmp	[rez] , 0
   jz	.no_exec1

mov	ecx , ebx
inc	ecx
mov	ecx , [ecx]
mov	[eax+9] , ecx
mov	cl , byte[ebx]
mov	byte[eax+8] , cl
;удалить результат ?
.no_exec1:
jmp	.end_i_

.pproc:

inc	edi
mov	eax , procs
mov	ebx , proca
call	getprocfun
pop	ebx		;402a70

   ;if
   push sif0
   push sif
   call read_s
   cmp	[rez] , 0
   jz	.no_exec2

call	dword[eax]

.no_exec2:
jmp	.end_i_

.cm0:
call	calc0
test	eax , eax
jnz	.no_error0
jmp	.ss0Ah
.no_error0:
mov	[save0] , ebx
mov	[statesyn] , 14h
push	se
call	DestroySG
push	8
push	se
call	CreateSG
push	se
call	AddSG
mov	[eax+4] , edi
jmp	.exitsyn


.end_i_:
;если = то найте перем. и присвоти , если фун. то ей

mov	[statesyn] , 0
call	view0

push	se
call	DestroySG
jmp	.exitsyn
;======================================
.ss6:
jmp	.exitsyn
;======================================
.ss8:
call   podC	  ;++++++++++++++++++++++++++++++++++++++
test   eax , eax
jnz    .podxodit0


cmp    byte[edi] , T_tockkaz
je     .tz0


push	se
call	DestroySG
jmp	.ss0Ah
;--------------------
.podxodit0:
push	se
call	AddSG
mov	[eax+4] , edi
jmp	.exitsyn
.tz0:

mov	ebx , 1
push	ebx
push	for_if
call	push_s	;!!!!!!!! LAST IF !!!!!!!

;!!!!!!!!!!!!!!!!!!!считать  , результат в стек    IFIFIFIFIFIFIF
call	calc0
test	eax , eax
jnz	.no_error3
jmp	.ss0Ah
.no_error3:

mov	ebx , [ebx+1]
push	ebx
push	sif
call	push_s

.no_exec4:

push	se
call	DestroySG

push	8
push	se
call	CreateSG

mov	[statesyn] , 9
jmp	.exitsyn

jmp	.exitsyn
;======================================
.ss9:
cmp	byte[edi] , T_skobk_1
je	.nextifo

mov	[statesyn] , 0
;call    view0

push	se
call	DestroySG
  jmp	  .ss0Ah
jmp	.exitsyn

.nextifo:
push	se
call	AddSG
mov	[eax+4] , edi
;mov     [statesyn] , 10h
;теперь любой оператор , ?(но если if то .ss8), —“≈  всегд провер€ть!
mov	[statesyn] , 0
call	view0
push	se
call	DestroySG
jmp	.exitsyn
jmp	.exitsyn
;======================================
;.ss10h:
;теперь любой оператор , ?(но если if то .ss8), —“≈  всегд провер€ть!
mov	[statesyn] , 0
call	view0
push	se
call	DestroySG
jmp	.exitsyn
;======================================
.ss11h:
cmp	byte[edi] , T_skobk_1; T_tockkaz
jne	.ntockkaz1

mov	ebx , 2
push	ebx
push	for_if
call	push_s ;!!!!!!!! LAST FOR !!!!!!!

;выполнить иниц. оператор        FOR FOR FOR FOR FOR FOR FOR FOR FOR
;          условие
mov	[statesyn] , 0;12h

call	calc0
test	eax , eax
jnz	.no_error1
jmp	.ss0Ah
.no_error1:

mov	ebx , [ebx+1]
push	ebx
push	sif
call	push_s

;call    view0
push	se
call	DestroySG


jmp	.exitsyn
.ntockkaz1:
push	se
call	AddSG
mov	[eax+4] , edi
jmp	.exitsyn
;======================================
.ss12h:
call   podC	    ;++++++++++++++++++++++++++++++++++++++
test   eax , eax
jnz    .podxodit1


cmp    byte[edi] , T_tockkaz
je     .tz1

push	se
call	DestroySG
jmp	.ss0Ah
;--------------------
.podxodit1:
push	se
call	AddSG
mov	[eax+4] , edi
jmp	.exitsyn
.tz1:
;!!!!!!!!!!!!!!!!!!!считать  , результат в стек  , при нахождении конца }
;и 0 в стеке   , то не переходить а извлеч.
mov	[statesyn] , 13h
jmp	.exitsyn
;======================================
.ss13h:
; инкремент
cmp	byte[edi] , T_skobk_1
jne	.ss0Ah;.n0

;выполнить инкремент оператор
mov	[statesyn] , 0
call	view0
push	se
call	DestroySG

jmp	.exitsyn
.n0:
push	se
call	AddSG
mov	[eax+4] , edi
jmp	.exitsyn
;======================================
.ss14h:
call   podC	     ;++++++++++++++++++++++++++++++++++++++
test   eax , eax
jnz    .podxodit3

cmp    byte[edi] , T_tockkaz
je     .tz5

push	se
call	DestroySG
jmp	.ss0Ah
;--------------------
.podxodit3:
push	se
call	AddSG
mov	[eax+4] , edi
jmp	.exitsyn
.tz5:

   ;if
   push sif0
   push sif
   call read_s
   cmp	[rez] , 0
   jz	.end_i_0

call	calc0
test	eax , eax
jnz	.no_error4
jmp	.ss0Ah
.no_error4:

cmp	dword[ebx+1] , 0
jz	.end_i_0

mov	ebx , [save0]
push	ebx
mov	edi , [sfsyn]
	cmp	byte[edi] , T_ident
	je	.pident0

	jmp	.end_i_0
.pident0:
call	find_ident
pop	ebx
cmp	byte[ebx] , T_str
je	.strp0

cmp	byte[eax+8] , T_str
je	.ss0Ah

mov	ecx , [ebx+1]
mov	[eax+9] , ecx
mov	cl , byte[ebx]
mov	byte[eax+8] , cl
jmp	.end_i_0
.strp0:
cmp	byte[eax+8] , T_str
jne	.ss0Ah

mov	ecx , ebx
inc	ecx
mov	ecx , [ecx]
mov	[eax+9] , ecx
mov	cl , byte[ebx]
mov	byte[eax+8] , cl
;удалить результат ?
jmp	.end_i_0

.end_i_0:

mov	[statesyn] , 0
call	view0

push	se
call	DestroySG
jmp	.exitsyn
;======================================
.ss15h: 	 ;00402E88
cmp	byte[edi] , T_tockkaz
je	.pop0
cmp	byte[edi] , T_key_word
je	.not0

jmp	.ss0Ah
.pop0:


   push for_if
   call read_s0

cmp	[rez] , 1
je	.lastif0
cmp	[rez] , 2
je	.lastfor0

jmp	.ss0Ah

.lastif0:

push	sif
call	pop_s
mov	[statesyn] , 0

push	for_if
call	pop_s

jmp	.exitsyn
.not0:
   push for_if
   call read_s0
cmp	[rez] , 1
je	.lastif1

jmp	.ss0Ah

.lastif1:		   ; когдато инвертировать надо , но когда?
				 ; считать кол-во не выполненых ифов и если оно 0 то можно инвертировать
   ;cmp  [rez] , 0      ; ERROR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   ;jz   .exitsyn             ;     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

inc	edi
invoke	lstrcmp,edi,k1;else ?
dec	edi
test	eax , eax
jnz	.ss0Ah

push	sif
call	not_s
mov	[statesyn] , 16h

jmp	.exitsyn

.lastfor0:

   ;for
   push sif0
   push sif
   call read_s

push	sif
call	pop_s
mov	[statesyn] , 0

   cmp	[rez] , 0
   jnz	.return_to_for

   push    for_if
   call    pop_s
push	for_e
call	pop_s

push	for_e
call	pop_s

   jmp	   .exitsyn
.return_to_for:

push	for_e
call	read_s0
push	[rez]
pop	[line]

mov	ecx , 4
push	for_e
call	read_s4
mov	esi , [rez]


mov	[statesyn] , 11h
push	8
push	se
call	CreateSG
mov	[sfsyn] , edi
push	se
call	AddSG
mov	[eax+4] , edi

jmp	.exitsyn
;======================================
.ss16h:
cmp	byte[edi] , T_skobk_1
jne	.ss0Ah
mov	[statesyn] , 0
jmp	.exitsyn
;======================================


.exitsyn:
xor	eax , eax
inc	eax
ret
endp


;----------------------------------------------------
view0:
push	esi

xor	esi , esi

invoke	lstrlen,[sfsyn]
inc	eax
add	esi , eax

mov	ebx , [se]
mov	ebx , [ebx]
test	ebx , ebx
jz	.noadd0
.next000:
invoke	lstrlen,dword[ebx+4]
inc	eax
add	esi , eax
mov	ebx , [ebx]
test	ebx , ebx
jnz	.next000
.noadd0:

inc	esi
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,esi
mov	esi , eax

invoke	lstrcat,esi,[sfsyn]
invoke	lstrcat,esi,nnull
;invoke  lstrcat,esi,pppp
;invoke  lstrcat,esi,nnull

mov	ebx , [se]
mov	ebx , [ebx]
test	ebx , ebx
jz	.noadd

.next:
 invoke  lstrcat,esi,dword[ebx+4]
invoke	lstrcat,esi,nnull

mov	ebx , [ebx]
test	ebx , ebx
jnz	.next

.noadd:

push	sx
call	AddSG
mov	[eax+4] , esi
;invoke SendMessage,[hwnd_l0],LB_ADDSTRING,0,esi

pop	esi
ret

;++++++++++++++++++++++++++++++++++++++
podC:
xor    eax , eax
cmp    byte[edi] , T_hex_num
je     .pod
cmp    byte[edi] , T_hex_f
je     .pod
cmp    byte[edi] , T_ident
je     .pod
cmp    byte[edi] , T_str
je     .pod
cmp    byte[edi] , T_and
je     .pod
cmp    byte[edi] , T_or
je     .pod
cmp    byte[edi] , T_not
je     .pod
cmp    byte[edi] , T_plus
je     .pod
cmp    byte[edi] , T_minus
je     .pod
cmp    byte[edi] , T_mul
je     .pod
cmp    byte[edi] , T_div
je     .pod
cmp    byte[edi] , T_otkr
je     .pod
cmp    byte[edi] , T_zakr
je     .pod

cmp    byte[edi] , T_big
je     .pod
cmp    byte[edi] , T_men
je     .pod
cmp    byte[edi] , T_nbig
je     .pod
cmp    byte[edi] , T_nmen
je     .pod
cmp    byte[edi] , T_equl
je     .pod
cmp    byte[edi] , T_nequ
je     .pod
cmp    byte[edi] , T_funs
je     .pod
ret
.pod:
inc    eax
ret



include "proc_find.asm"