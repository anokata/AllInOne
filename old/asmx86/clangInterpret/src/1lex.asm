;---------------------------
proc lex ;IN esi - str  ; OUT edi - type,str
mov	[state] , 0

.next:

cmp	[state] , 0
je	.st_0
cmp	[state] , 1
je	.st_1
cmp	[state] , 2
je	.st_2
cmp	[state] , 3
je	.st_3
cmp	[state] , 6
je	.st_6
cmp	[state] , 7
je	.st_7
cmp	[state] , 9
je	.st_9
cmp	[state] , 10h
je	.st_10h
cmp	[state] , 11h
je	.st_11h
cmp	[state] , 12h
je	.st_12h
cmp	[state] , 13h
je	.st_13h

jmp	.end_st
;--------------
.st_0:
cmp	byte[esi] , ' '
je	.end_st

  cmp	  byte[esi] , '0'
  jl	  .set_st_3
  cmp	  byte[esi] , '9'
  jg	  .set_st_3

  mov	  [state] , 1
  mov	  [n] , esi
  jmp	  .end_st

  .set_st_3:
  mov	  [state] , 3
  dec	  esi


jmp	.end_st
;--------------
.st_1:
  cmp	  byte[esi] , '0'
  jl	  .set_st_6
  cmp	  byte[esi] , '9'
  jle	  .end_st

  cmp	  byte[esi] , 'A'
  jl	  .set_st_6
  cmp	  byte[esi] , 'F'
  jle	  .end_st
  cmp	  byte[esi] , 'a'
  jl	  .set_st_6
  cmp	  byte[esi] , 'f'
  jle	  .end_st



  ;jmp     .end_st

  .set_st_6:
  ;mov     eax , T_hex_num;66 ; type hex num
  mov	  [state] , 6;2
  dec	  esi


jmp	.end_st
;--------------
.st_2:	;IN eax - type lexem
mov	[last] , al
push	eax

;----------------------
cmp    al , T_hex_num
je     .JCT_hex_num
cmp    al , T_hex_f
je     .JCT_hex_f
cmp    al , T_comment
je     .JCT_comment
cmp    al , T_str
je     .JCT_str


mov    [cf.crTextColor] , 0h
jmp    .JC0

.JCT_hex_num:
mov    [cf.crTextColor] , C_hex
jmp    .JC0
.JCT_hex_f:
mov    [cf.crTextColor] , C_hexf
jmp    .JC0
.JCT_comment:
mov    [cf.crTextColor] , C_com
jmp    .JC0
.JCT_str:
mov    [cf.crTextColor] , C_str
jmp    .JC0


.JC0:
;----------------------
cmp    al , T_comment
je     .the_comment

mov	edi , esi
sub	edi , [n]
inc	edi ; end null
inc	edi ; type lexem
inc	edi ; to min 4 bytes
inc	edi ; to min 5 bytes

invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,edi
mov	edx , esi

mov	ecx , edi
dec	ecx
dec	ecx
dec	ecx
dec	ecx
mov	esi , [n]
mov	edi , eax

pop	ebx

  cmp	bl , T_str
  je	.tstr


mov	byte[edi] , bl ; type

inc	edi ; +0 - type , then str
rep movsb

jmp	.0
.tstr:
inc	esi
push	edi
dec	ecx
dec	ecx
rep movsb
pop	edi
push	edx
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,6
mov	byte[eax] , T_str
mov	[eax+1] , edi
pop	edx
jmp	.0
.0:



mov	esi , edx

mov	edi , eax

push	eax

;--------------------
call	find0
test	eax , eax
jz	.no_key
mov	[cf.crTextColor] , C_key
mov	byte[edi] , T_key_word ; type key
.no_key:
;--------------------
;--------------------
mov	ebx , funs
call	findu
test	eax , eax
jz	.no_f
mov	[cf.crTextColor] , C_key
mov	byte[edi] , T_funs ; type fun
.no_f:
;--------------------
;--------------------
mov	ebx , procs
call	findu
test	eax , eax
jz	.no_p
mov	[cf.crTextColor] , C_proc
mov	byte[edi] , T_proc ; type fun
.no_p:
;--------------------
jmp	.no_comment
.the_comment:
pop	eax
push	dword 0
inc	[n]
.no_comment:

mov	eax , [n]
sub	eax , [source]

mov	ebx , esi
sub	ebx , [source];[n]
;add     ebx , eax

sub	eax , [line]
sub	ebx , [line]

invoke SendMessage,[hwndRichEdit],EM_SETSEL,eax,ebx
invoke SendMessage, [hwndRichEdit], EM_SETCHARFORMAT, SCF_SELECTION, cf
pop	eax

mov	[state] , 0

;dec     esi
ret
jmp	.end_st
;--------------
.st_3:
  cmp	  byte[esi] , '+'
  je	  .set_st_2p
  cmp	  byte[esi] , '-'
  je	  .set_st_2m
  cmp	  byte[esi] , '*'
  je	  .set_st_2l
  cmp	  byte[esi] , '/'
  je	  .set_st_2d
  cmp	  byte[esi] , '('
  je	  .set_st_2s
  cmp	  byte[esi] , ')'
  je	  .set_st_2c
			;=   > < !> !< != ?=

  cmp	  byte[esi] , '='
  je	  .set_st_2r
  cmp	  byte[esi] , '>'
  je	  .set_st_2bol
  cmp	  byte[esi] , '<'
  je	  .set_st_2men
  ;------------------------
  cmp	  byte[esi] , '!'
  jne	  .n0
  ;inc     esi

  cmp	  byte[esi+1] , '>'
  je	  .set_st_2_Hebol
  cmp	  byte[esi+1] , '<'
  je	  .set_st_2_Hemen
  cmp	  byte[esi+1] , '='
  je	  .set_st_2_Her
  ;dec     esi
  jmp	  .set_st_2not
  .n0:
  ;------------------------
  cmp	  byte[esi] , '?'
  jne	  .n1
  ;inc     esi

  cmp	  byte[esi+1] , '='
  je	  .set_st_2_rr
  ;dec     esi
  .n1:
  ;------------------------

  cmp	  byte[esi] , '{'
  je	  .set_st_2s1
  cmp	  byte[esi] , '}'
  je	  .set_st_2s2
  cmp	  byte[esi] , ';'
  je	  .set_st_2tz

  cmp	  byte[esi] , '&'
  je	  .set_st_2and
  cmp	  byte[esi] , '|'
  je	  .set_st_2or
  cmp	  byte[esi] , '?'
  je	  .set_st_2cm


   mov	   [state] , 10h
   dec	   esi
  jmp	  .end_st

  .set_st_2p:
  mov	  eax , T_plus ; type +
  jmp	  .set_st_20
  .set_st_2m:
  cmp	  [last] , T_zakr
  je	  .min
  cmp	  [last] ,  T_hex_num
  je	  .min
  cmp	  [last] ,  T_hex_f
  je	  .min
  cmp	  [last] ,  T_ident
  je	  .min
  cmp	  [last] ,  T_key_word
  je	  .min
  cmp	  [last] ,  T_funs
  je	  .min
  mov	  eax , T_minus;T_fminus ; type fun -
  jmp	  .set_st_20

  .min:
  mov	  eax , T_minus ; type -
  jmp	  .set_st_20
  .set_st_2l:
  mov	  eax , T_mul ; type *
  jmp	  .set_st_20
  .set_st_2d:
  mov	  eax , T_div ; type /
  jmp	  .set_st_20
  .set_st_2s:
  mov	  eax , T_otkr ; type (
  jmp	  .set_st_20
  .set_st_2c:
  mov	  eax , T_zakr ; type )
  jmp	  .set_st_20

  .set_st_2r:
  mov	  eax , T_pris ; type =
  jmp	  .set_st_20
  .set_st_2bol:
  mov	  eax , T_big ; type >
  jmp	  .set_st_20
  .set_st_2men:
  mov	  eax , T_men ; type <
  jmp	  .set_st_20

  .set_st_2_Hebol:
  mov	  eax , T_nbig ; type !>
  jmp	  .set_st_200
  .set_st_2_Hemen:
  mov	  eax , T_nmen ; type !<
  jmp	  .set_st_200
  .set_st_2_Her:
  mov	  eax , T_nequ ; type !=
  jmp	  .set_st_200
  .set_st_2_rr:
  mov	  eax , T_equl ; type ?=
  jmp	  .set_st_200

  .set_st_2s1:
  mov	  eax , T_skobk_1 ; type {
  jmp	  .set_st_20
  .set_st_2s2:
  mov	  eax , T_skobk_2 ; type }
  jmp	  .set_st_20
  .set_st_2tz:
  mov	  eax , T_tockkaz ; type ;
  jmp	  .set_st_20
  .set_st_2and:
  mov	  eax , T_and ; type and
  jmp	  .set_st_20
  .set_st_2or:
  mov	  eax , T_or ; type or
  jmp	  .set_st_20
  .set_st_2not:
  mov	  eax , T_not ; type not
  jmp	  .set_st_20
  .set_st_2cm:
  mov	  eax , T_cm
  jmp	  .set_st_20


  .set_st_20:
  mov	  [n] , esi
  mov	  [state] , 2
  jmp	  .end_st
  .set_st_200:
  mov	  [n] , esi
  inc	  esi
  mov	  [state] , 2
  jmp	  .end_st


jmp	.end_st
;--------------
.st_6:
  cmp	  byte[esi] , '.'
  jne	  .set_st_2

  mov	  [state] , 7
  jmp	  .end_st

  .set_st_2:
  mov	  eax , T_hex_num;66 ; type hex num
  mov	  [state] , 2
  dec	  esi


jmp	.end_st
;--------------
.st_7:
  cmp	  byte[esi] , '0'
  jl	  .set_st_9
  cmp	  byte[esi] , '9'
  jle	  .end_st

  cmp	  byte[esi] , 'A'
  jl	  .set_st_9
  cmp	  byte[esi] , 'F'
  jle	  .end_st
  cmp	  byte[esi] , 'a'
  jl	  .set_st_9
  cmp	  byte[esi] , 'f'
  jle	  .end_st

  mov	  [state] , 8
  jmp	  .end_st

  .set_st_9:
  mov	  [state] , 9
  dec	  esi


jmp	.end_st
;--------------
.st_9:
  cmp	  byte[esi] , '0'
  jl	  .set_st_21
  cmp	  byte[esi] , '9'
  jle	  .end_st

  cmp	  byte[esi] , 'A'
  jl	  .set_st_21
  cmp	  byte[esi] , 'F'
  jle	  .end_st
  cmp	  byte[esi] , 'a'
  jl	  .set_st_21
  cmp	  byte[esi] , 'f'
  jle	  .end_st
  jmp	  .end_st

  .set_st_21:
    mov     eax , T_hex_f; type hex float
  mov	  [state] , 2
  dec	  esi


jmp	.end_st
;--------------
.st_10h:
  cmp	  byte[esi] , '_'
  je	  .set_st_11
  cmp	  byte[esi] , 'A'
  jl	  .set_st_0
  cmp	  byte[esi] , 'Z'
  jle	  .set_st_11
  cmp	  byte[esi] , 'a'
  jl	  .set_st_0
  cmp	  byte[esi] , 'z'
  jle	  .set_st_11

  jmp	  .set_st_0

  .set_st_11:
  mov	  [state] , 11h
  mov	  [n] , esi
  jmp	  .end_st

  .set_st_0:
  ;------------------
  cmp	  byte[esi] , '"'
  jne	  .nkk
  mov	  [state] , 12h
  mov	  [n] , esi
  jmp	  .end_st
  .nkk:
  ;------------------
  cmp	  byte[esi] , '\'
  jne	  .nkko
  mov	  [state] , 13h
  mov	  [n] , esi
  jmp	  .end_st
  .nkko:
  ;------------------


  mov	  [state] , 0;!!!

cmp	word[esi] , 0A0Dh
jne	.nnl0
inc	[line]
.nnl0:

  jmp	  .end_st


jmp	.end_st
;--------------
.st_11h:
  cmp	  byte[esi] , '_'
  je	  .end_st
  cmp	  byte[esi] , '0'
  jl	  .set_st_2000
  cmp	  byte[esi] , '9'
  jle	  .end_st
  cmp	  byte[esi] , 'A'
  jl	  .set_st_2000
  cmp	  byte[esi] , 'Z'
  jle	  .end_st
  cmp	  byte[esi] , 'a'
  jl	  .set_st_2000
  cmp	  byte[esi] , 'z'
  jle	  .end_st

  .set_st_2000:
  mov	  [state] , 2
  mov	  eax , T_ident
  dec	  esi
  jmp	  .end_st


jmp	.end_st
;--------------
.st_12h:
  cmp	  byte[esi] , '"'
  jne	  .end_st

  mov	  [state] , 2
  mov	  eax , T_str

jmp	.end_st
;--------------
.st_13h:
cmp	word[esi] , 0A0Dh
jne	.nnl1
inc	[line]
mov	eax , T_comment
mov	[state] , 2
.nnl1:
jmp	.end_st
;--------------

.end_st:
inc	esi
cmp	byte[esi] , 0
jnz	.next

xor	eax , eax

ret
endp
;---------------------------


proc find0 ;in edi-str k0  out eax bool

mov	ebx , k0
inc	edi

.nextfind:

invoke	lstrcmp,ebx,edi
test	eax , eax
jz	.find

invoke	lstrlen,ebx
inc	eax
add	ebx , eax

cmp	byte[ebx],0
jnz	.nextfind

xor	eax , eax
dec	eax
.find:
not	eax

dec	edi
ret
endp
