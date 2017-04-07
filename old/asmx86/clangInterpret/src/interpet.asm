

proc interpet
local	b:DWORD
local	d:DWORD

push	esi edi

mov	esi , [source]
mov	[line] , 0
mov	[statesyn] , 0
mov	byte[last] , 0

push	4+1+4 ; адрес имени переменной , тип . 0-HET 1-bool 2-num 3-float 4-str
push	sv	  ; TODO !!! +4 (адр) её знач.
call	CreateSG ; создаем список переменных

push	4 ; адрес lexemi
push	sl
call	CreateSG ; создаем список lexem

push	4 ; адрес syntax
push	sx
call	CreateSG ; создаем список syntax


invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,sz
mov	[sif0] , eax
add	eax , sz
mov	[sif] , eax
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,sz
mov	[for_if0] , eax
add	eax , sz
mov	[for_if] , eax
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,sz
mov	[for_e0] , eax
add	eax , sz
mov	[for_e] , eax


..next:

call   lex
test   eax , eax
jz     .no_addlex

inc    eax
invoke SendMessage,[hwnd_l],LB_ADDSTRING,0,eax

push	sl
call	AddSG
mov	[eax+4] , edi
.no_addlex:


cmp    [hilg] , 1
je     .is_hilg

;push   eax edi

test   eax , eax
jz     .no_syn

call   syn

test	eax , eax
jz	..exit

.no_syn:

;pop    edi eax
.is_hilg:

cmp	byte[esi] , 0
jnz	..next
;-------------------------

..exit:
pop	edi esi

cmp    [hilg] , 1
je     .noview
push	[sv]
call	vvar
.noview:

push	sv
call	DestroySG

push	sl
call	DestroySG4

push	sx
call	DestroySG4

invoke GlobalHandle,[sif0]
invoke GlobalFree,eax
invoke GlobalHandle,[for_if0]
invoke GlobalFree,eax
invoke GlobalHandle,[for_e0]
invoke GlobalFree,eax

ret
endp

;------------------------------------------

;push
proc push_s s_,a:DWORD
mov	edx , esp
mov	eax , [s_]
mov	esp , [eax]
push	[a]
mov	ecx , esp
mov	esp , edx
mov	[eax] , ecx
ret
endp
;pop
proc pop_s s_:DWORD
mov	edx , esp
mov	eax , [s_]
mov	esp , [eax]
pop	ebx
mov	ecx , esp
mov	esp , edx
mov	[eax] , ecx
ret
endp
proc read_s s_,l:DWORD
push	edx eax ebx
mov	edx , esp
mov	eax , [s_]

mov	ecx , [l]
mov	ecx , [ecx]
add	ecx , sz

mov	esp , [eax]
sub	esp , 4
.next:
add	esp , 4
mov	ebx , [esp]
mov	[rez] , ebx
test	ebx , ebx
jz	.exit0

cmp	esp , ecx
jl	.next

.exit0:
mov	esp , edx
pop	ebx eax edx
ret
endp
proc read_s0 s_:DWORD
push	edx eax ebx
mov	edx , esp
mov	eax , [s_]
mov	esp , [eax]
mov	ebx , [esp]
mov	[rez] , ebx
mov	esp , edx
pop	ebx eax edx
ret
endp

proc read_s4 s_:DWORD
push	edx eax ebx
mov	edx , esp
mov	eax , [s_]
mov	esp , [eax]
add	esp , ecx
mov	ebx , [esp]
mov	[rez] , ebx
mov	esp , edx
pop	ebx eax edx
ret
endp

proc not_s s_:DWORD
mov	edx , esp
mov	eax , [s_]
mov	esp , [eax]

cmp	dword[esp] , 0
jnz	.to0
inc	dword[esp]
jmp	.to
.to0:
mov	dword[esp] , 0
.to:
mov	esp , edx
ret
endp
