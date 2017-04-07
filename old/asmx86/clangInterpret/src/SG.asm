;struct
;  next 4b head = elem size

proc CreateSG S:DWORD,E:DWORD; addres of Head Spiska
mov	eax , [E]
add	eax , 4
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,eax
mov	ebx , [S]
mov	[ebx] , eax
mov	ecx , [E]
mov	[eax+4] , ecx
mov    dword[eax] , 0
ret
endp

proc DestroySG S:DWORD
mov  eax , [S]
mov  eax , [eax]
nextelemun:
push	dword[eax]
invoke	GlobalHandle,eax
invoke	GlobalFree,eax
pop	eax
cmp	eax , 0
jnz nextelemun


mov  eax , [S]
mov  dword[eax] , 0

ret
endp

proc DestroySG4 S:DWORD
mov  eax , [S]
mov  eax , [eax]
mov  eax , [eax]
test eax , eax
jz   .exit
.nextelemun:
push	dword[eax]
mov	ebx , eax
invoke	GlobalHandle,dword[eax+4]
invoke	GlobalFree,eax
invoke	GlobalHandle,ebx
invoke	GlobalFree,eax
pop	eax
cmp	eax , 0
jnz .nextelemun

.exit:
mov  eax , [S]
mov  eax , [eax]
invoke	GlobalHandle,eax
invoke	GlobalFree,eax

ret
endp

proc AddSG1 S:DWORD
push	esi
mov	eax , [S]
mov	eax , [eax]
mov	esi , [eax+4]
add	esi , 4
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,esi
mov	ebx , [S]  ;addres spk
mov	ebx , [ebx];pointer to first elem
mov	ecx , [ebx];ecx = to 2 elem
mov	[ebx] , eax;S.next = new
mov	[eax] , ecx;new = 2 elem or 0
;user data peek user

pop	esi
ret
endp

proc AddSG S:DWORD
push	esi ebx
mov	eax , [S]
mov	eax , [eax]
mov	esi , [eax+4]
add	esi , 4
invoke	GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,esi
mov	dword[eax] , 0
mov	ebx , [S]  ;addres spk
mov	ebx , [ebx];pointer to first elem
.next:
cmp	dword[ebx] , 0
je	.find
mov	ebx , [ebx]
jmp	.next
.find:

mov	[ebx] , eax;S.next = new

pop	ebx esi
ret
endp

proc DelSG S:DWORD , E:DWORD ;addr
mov	eax , [S]
mov	eax , [eax]
mov	ebx , [E]
nextfindpredun:
push	dword[eax]
cmp	[eax] , ebx
je	findun
pop	eax
test	eax , eax
jnz	nextfindpredun
jmp	no_predun
findun: ; eax - pred [E]  ebx - [E]
;del
mov	ecx , [ebx] ; ecx - next [E]
mov	[eax] , ecx ; E->pred->next=E->next
invoke	GlobalHandle,ebx
invoke	GlobalFree,eax

no_predun:
ret
endp


