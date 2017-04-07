format PE GUI 4.0

entry start

include 'win32ax.inc'

struct CHARFORMATA
    cbSize	       dd ?
    dwMask	       dd ?
    dwEffects	       dd ?
    YHeight	       dd ?
    YOffset	       dd ?
    crTextColor        dd ?
    BCharSet	       db ?
    BPitchAndFamily    db ?
    SzFaceName	       db 32 dup(?)
    _wPad2	       dw ?
ends
cfa_s		       equ 24+32+4

; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
section '.data' data readable writeable
  ; a dd
classname db "testclass",0
appname db "fasm application test        ",0
appnam0 db "                             ",0
buttonclass db "button",0
lbclass db "listbox",0

RichEditDLL	db "RichEd20.dll", 0
RichEditClass	db "RichEdit20A", 0
RichEditID	equ 300
hRichEditDLL	dd ?
hwndRichEdit	dd ?
hpold		dd ?
p0		dd 0
p1		dd 0
drw		dd 0
EM_SETBKGNDCOLOR equ WM_USER + 67
CFM_COLOR	 equ 0x40000000
SCF_ALL 	 equ 0x0004
EM_SETCHARFORMAT equ WM_USER + 68
SF_TEXT 	 equ 1
EM_STREAMIN	 equ WM_USER + 73
EM_STREAMOUT	 equ WM_USER + 74
SCF_SELECTION	 equ 0x0001


; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


hInstance dd ?
hwnd_m dd ?
hwnd_b dd ?
hwnd_l dd ?
hwnd_l0 dd ?
hwnd_l1 dd ?
wc WNDCLASSEX <?>
umsg8 MSG <?>
ps PAINTSTRUCT <?>
hdc dd ?

bOK	db "Load source",0
idOK	equ 0115h
blex	db "(lexic & syntax analys)+interpret",0
idlex	equ 0116h

cf CHARFORMATA <0>

ofn OPENFILENAME <?>
sizeof_ofn	 equ 76
ASMFilterString db "ASM Исходники (*.asm)",0,"*.asm",0
		db "Все файлы (*.*)",0,"*.*",0,0

x	dd 1
y	dd 80
hFile	dd ?
FileName db 200h dup (0)
bt0r	 dd ?

NL	equ ,0Dh,0Ah,

tests	 db "a num; a=1; ",\
	 " \out dd;",0 NL\
	     ""NL "dd=sqrt dd ; dd= sqrt 2*(b); dd=0?0>2;"NL\
	     "  { }  1 12 | &  ! 0\asdf 213 bool " NL\
	     "_a_  num 12.03 11 "\
	     NL " str 12 %%  float  ",22h,"str 123d",22h NL\
  "+ 1 -5 66 */ () =   > < !> !< != ?="NL ""NL\
"if 1>0;{ dd=0;}; if 1>0; {dd=0;} else {dd=1;} if 1>0; {if 0?=1; {dd=dd*3;};};"\
NL "i num  for i=1;i<3;i=i+1{ dd=dd*2;} ",0
errorm	 db "Error!",0
cccccc	 db 0Dh,0Ah,0;" ",0
;key words
k0 db "if",0
k1 db "else",0
k2 db "for",0
k3 db "forr",0 ;"data",0,"code",0,"true",0,"false",0,

ktyp db "num",0,"float",0,"str",0,0  ;00 00 end    ;"bool",0,
funs db "sqrt",0,"min",0,0
funa dd F_sqrt,F_min
procs db "out",0,"in",0,0
proca dd P_out,P_in
tstr  db "str",0
spc   db " = ",0



;colors
bkg_color	equ 0EEEEEEh
tex_color	equ 0111111h
;BGR
C_key		equ 0AA00AAh
C_str		equ 000AAh
C_com		equ 0AAAAAAh
C_hexf		equ 000DD00h
C_hex		equ 000AA00h
C_proc		equ 0FFh
;------

h_font		dd ?
FontName	db "Times New Roman",0
state		dd 0
statesyn	dd 0
n		dd 0

T_hex_num	equ 66h
T_hex_f 	equ 67h
T_ident 	equ 65h
T_key_word	equ 68h
T_str		equ 69h
T_comment	equ 6Ah

T_plus		equ 2h
T_minus 	equ 3h
T_fminus	equ 10h
T_mul		equ 4h
T_div		equ 5h
T_otkr		equ 1h
T_zakr		equ 6h
T_pris		equ 17
T_big		equ 7;18
T_men		equ 8;19
T_nbig		equ 9;20
T_nmen		equ 0ah;21
T_equl		equ 0ch;23
T_nequ		equ 0bh;22

T_skobk_1	equ 24 ;{
T_skobk_2	equ 25 ;}
T_tockkaz	equ 26 ;;
T_and		equ 0dh;27 ;and &
T_or		equ 0eh;28 ;or	|
T_not		equ 0fh;29 ;not !
T_cm		equ 06Dh;29 ;?

T_funs		equ 10h;6Bh
T_proc		equ 6Ch


m		db 0
b		dd 0
f1	dd 1.0
fm1	dd -1.0
f16	dd 16.0
f10	dd 10000000h
imax   equ 7FFFFFFFh;80000000h
fmax	dd 0.0;7FFFFFFF.0
source	dd ?
line	dd 0

sv	dd ? ; список переменных
sl	dd ? ; lexem
sx	dd ? ; syntax
se	dd ? ; выражение

;error
mes0	db "line %d  lexem: %s",0

hilg	db 0
sfsyn	dd ? ; stack for syntax

nnull	db 1,0
pppp	db '=',0

;calc
last_n	db 0
sz	equ 1000h*4
sop0	dd ?
sop	dd ?
sod0	dd ?
sod	dd ?
sif0	dd ? ;результаты условий if for
sif	dd ?
;functions				 fun sqrt or -
t0 \;0 1 2 3 4 5 6 7 8 9  a  b	c  d e f  10
db \;$ ( + - * / ) > < !> !< != ?= & | ! sqrt
     6,1,1,1,1,1,5,1,1,1 ,1, 1, 1, 1,1,1, 1  ,\; $
     6,1,1,1,1,1,3,1,1,1 ,1, 1, 1, 1,1,1, 1  ,\; ( ;5,...
     4,1,2,2,1,1,4,2,2,2 ,2, 2, 2, 1,1,1, 1  ,\; +  ; top stack
     4,1,2,2,1,1,4,2,2,2 ,2, 2, 2, 1,1,1, 1  ,\; -
     4,1,4,4,2,2,4,4,4,4 ,4, 4, 4, 2,2,7, 9  ,\; *
     4,1,4,4,2,2,4,4,4,4 ,4, 4, 4, 2,2,7, 9  ,\; /
     1,1,1,1,1,1,1,1,1,1 ,1, 1, 1, 1,1,1, 1  ,\; 0
     4,1,2,2,1,1,4,2,2,2 ,2, 2, 2, 1,1,1, 1  ,\; >
     4,1,2,2,1,1,4,2,2,2 ,2, 2, 2, 1,1,1, 1  ,\; <
     4,1,2,2,1,1,4,2,2,2 ,2, 2, 2, 1,1,1, 1  ,\; !>
     4,1,2,2,1,1,4,2,2,2 ,2, 2, 2, 1,1,1, 1  ,\; !<
     4,1,2,2,1,1,4,2,2,2 ,2, 2, 2, 1,1,1, 1  ,\; !=
     4,1,2,2,1,1,4,2,2,2 ,2, 2, 2, 1,1,1, 1  ,\; ?=
     4,1,4,4,2,2,4,4,4,4 ,4, 4, 4, 2,2,7, 9  ,\; &
     4,1,4,4,2,2,4,4,4,4 ,4, 4, 4, 2,2,7, 9  ,\; |
     7,1,7,7,8,8,8,7,7,7 ,7, 7, 7, 8,8,7, 9  ,\; !
     9,1,9,9,10,10,10,9,9,9,9,9,9,10,10,9, 9	; sqrt

t0m  equ 16 +1;+funs
nl   dd 0
nls  db 0
fmt	db "%x",0
CR	dw ?
sep	db ".",0
save0	dd ?
;for_if  db ?; 1-for 2-if что было последнее
for_if	dd ?	;что было последнее
for_if0 dd ?
rez	dd ?
for_e	dd ?   ; esi line для for
for_e0	dd ?
;for_esi dd ?
;for_line dd ?
last	db 0 ;тип последней лексемы


 ;общая переменная для хранения каких-либо состояний,
 ; используется в небольших кусках, то есть не требует сохранения
S  dd ?
G  dd ?

; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
section '.text' code readable executable

start:

invoke	GetModuleHandle,0
mov	[hInstance] , eax
invoke	LoadIcon,0,IDI_ASTERISK
mov	[wc.hIcon]  ,eax
mov	[wc.hIconSm] , eax
invoke	LoadCursor,0,IDC_ARROW
mov	[wc.hCursor] ,eax
mov	[wc.cbSize] , 48
mov	[wc.style] , CS_HREDRAW + CS_VREDRAW
mov	[wc.lpfnWndProc] , WindowProc
mov	[wc.cbClsExtra] , 0
mov	[wc.cbWndExtra] , 0
push	[hInstance]
pop	[wc.hInstance]
mov	[wc.hbrBackground] , 010h
mov	[wc.lpszMenuName] , 0
mov	[wc.lpszClassName] , classname

invoke	 RegisterClassEx,addr wc

invoke	CreateWindowEx,0,classname,appname,WS_OVERLAPPED or WS_SIZEBOX + \
WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX,2,1,900,600,0,0,[hInstance],0

mov	[hwnd_m] , eax

invoke	UpdateWindow,eax
invoke	ShowWindow,[hwnd_m],SW_SHOW

invoke	GetDC,[hwnd_m]
mov	[hdc] , eax

invoke	CreateWindowEx,0,buttonclass,bOK,\
WS_CHILD or WS_VISIBLE,1,1,125,25,[hwnd_m],idOK,[hInstance],0
invoke	CreateWindowEx,0,buttonclass,blex,\
WS_CHILD or WS_VISIBLE,1,30,305,25,[hwnd_m],idlex,[hInstance],0

invoke LoadLibrary,RichEditDLL
Mov [hRichEditDLL], eax

invoke CreateWindowEx,0,RichEditClass,tests, \
   WS_VISIBLE or ES_MULTILINE or WS_CHILD or WS_VSCROLL or WS_HSCROLL + \
   WS_BORDER , \
   [x],[y], 700, 500, \
   [hwnd_m], RichEditID, [hInstance], 0
Mov [hwndRichEdit], eax

invoke SetWindowLong,[hwndRichEdit],GWL_WNDPROC,nrep
mov    [hpold] , eax

;------------------------------------------------------------------
invoke CreateFont,17, 5, 0, 0, FW_NORMAL, 0, 0, 0, ANSI_CHARSET, \
		 OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY \
		, FF_SWISS , FontName
mov	[h_font],eax
invoke	SendMessage,[hwndRichEdit],WM_SETFONT,eax,0;[h_font]


invoke SendMessage, [hwndRichEdit], EM_SETBKGNDCOLOR, 0,bkg_color

  Mov [cf.cbSize], cfa_s
  Mov [cf.dwMask], CFM_COLOR
  Mov [cf.crTextColor], tex_color
  invoke SendMessage, [hwndRichEdit], EM_SETCHARFORMAT, SCF_ALL, cf

invoke SendMessage, [hwndRichEdit], EM_LIMITTEXT,-1,0
;------------------------------------------------------------------
invoke	CreateWindowEx,0,lbclass,0,WS_BORDER+\
WS_CHILD or WS_VISIBLE,700,1,190,200,[hwnd_m],idOK,[hInstance],0
mov	[hwnd_l] , eax
invoke	SendMessage,eax,WM_SETFONT,[h_font],0
invoke	CreateWindowEx,0,lbclass,0,WS_BORDER+\
WS_CHILD or WS_VISIBLE,700,200,190,200,[hwnd_m],idOK,[hInstance],0
mov	[hwnd_l0] , eax
invoke	SendMessage,eax,WM_SETFONT,[h_font],0

invoke	CreateWindowEx,0,lbclass,0,WS_BORDER+\
WS_CHILD or WS_VISIBLE,700,400,190,190,[hwnd_m],idOK,[hInstance],0
mov	[hwnd_l1] , eax
invoke	SendMessage,eax,WM_SETFONT,[h_font],0

inc	[hilg]
call	lexp
dec	[hilg]

invoke	SetFocus,[hwndRichEdit]

LP:
invoke	 GetMessage,umsg8,0,0,0
cmp	eax , 0
je	EXIT
invoke	 TranslateMessage,umsg8
invoke	 DispatchMessage,umsg8
jmp    LP
EXIT:

invoke FreeLibrary,[hRichEditDLL]

invoke	ExitProcess,0


proc WindowProc hWnd,uMsg,wParam,lParam
; --------------------
push	ebx esi edi

cmp	[uMsg] , WM_DESTROY
je	JM_doexit
cmp	[uMsg] , WM_PAINT
je	JM_paint
cmp	[uMsg] , WM_KEYDOWN
je	JM_keyd
cmp	[uMsg] , WM_COMMAND
je	JM_com
cmp	[uMsg] , WM_SIZE
je	JM_size


jmp	JM_end

; --------------------
JM_doexit:

invoke	PostQuitMessage,0

jmp	JM_end
; --------------------
JM_paint:

invoke	BeginPaint,[hwnd_m],ps


invoke	EndPaint,[hwnd_m],ps
jmp	JM_end
; --------------------
JM_keyd:
cmp	[wParam] , VK_ESCAPE
je	JM_K_esc

jmp	JM_end
; --------------------
  JM_K_esc:
  invoke  PostQuitMessage,0
  jmp	  JM_end
  ; --------------------
JM_com:
cmp	[wParam] , idOK
je	but_ok
cmp	[wParam] , idlex
je	but_lex

jmp	JM_end
; --------------------
	but_ok:

	mov [ofn.lStructSize],sizeof_ofn
	push [hwnd_m]
	pop [ofn.hwndOwner]
	push [hInstance]
	pop [ofn.hInstance]
	mov [ofn.lpstrFilter], ASMFilterString
	mov [ofn.nMaxFile],512
	mov [ofn.lpstrFile],FileName
	mov byte[FileName],0
	mov [ofn.Flags],OFN_FILEMUSTEXIST or OFN_HIDEREADONLY or OFN_PATHMUSTEXIST
	invoke GetOpenFileName, ofn
	;invoke  MessageBox,0,FileName,0,0
	invoke CreateFile,FileName,GENERIC_READ,FILE_SHARE_READ,NULL,\
	OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	cmp	eax , -1
	jz	JM_end

	mov [hFile],eax
	invoke GetFileSize,[hFile],0
	inc    eax   ;db 40h

	mov    edi , eax
	invoke GlobalAlloc, GMEM_FIXED+GMEM_ZEROINIT, eax
	mov    esi , eax

	invoke ReadFile, [hFile], eax, edi, bt0r, 0

	invoke SendMessage, [hwndRichEdit], WM_SETTEXT, edi, esi

	invoke GlobalHandle,esi
	invoke GlobalFree,eax

	invoke CloseHandle,[hFile]
	jmp	JM_end
	; --------------------

but_lex:

call	lexp

jmp	JM_end
; --------------------

JM_size:

  Mov eax, [lParam]
  Mov edx, eax
  and eax, 0FFFFh
  Shr edx, 16
  ;sub eax , 50
  sub edx , 78
  invoke MoveWindow, [hwndRichEdit], [x],[y], eax, edx, TRUE

jmp	JM_end
; --------------------

JM_end:

invoke	DefWindowProc,[hWnd],[uMsg],[wParam],[lParam]
pop	edi esi ebx
ret
endp

include "SG.asm"
include "procs.asm"

include "syn0.asm"
include "1lex.asm"
include "interpet.asm"


include "0hexf.asm"
include "0hex.asm"

include "find_ident.asm"
include "0calc.asm"
include "0calc_2_1.asm"

include "view_var.asm"

proc	nrep hWnd,uMsg,wParam,lParam
cmp	[uMsg] , WM_KEYUP
je	.Jkd
cmp	[uMsg] , WM_PAINT
je	.Jp


jmp	.exit

.Jkd:
;invoke  ShowWindow,[hwndRichEdit],SW_HIDE
invoke	EnableWindow,[hwndRichEdit],0
inc	[drw]
inc	[hilg]
call	lexp
dec	[hilg]
dec	[drw]
invoke	EnableWindow,[hwndRichEdit],1
invoke	SetFocus,[hwndRichEdit]
;invoke  SendMessage,[hwndRichEdit],EM_SETSEL,[p0],[p1]
;invoke  ShowWindow,[hwndRichEdit],SW_SHOW
jmp	.exit

.Jp:
cmp	[drw] , 1
je	.exit0
jmp	.exit

.exit:
invoke	CallWindowProc,[hpold],[hWnd],[uMsg],[wParam],[lParam]
.exit0:
ret
endp

;---------------------------------------------------------------
lexp:

inc    [drw]

invoke SendMessage,[hwndRichEdit],EM_GETSEL,p0,p1

invoke SendMessage,[hwndRichEdit],WM_GETTEXTLENGTH,0,0

inc    eax
add    eax , 10h
push   eax
invoke GlobalAlloc,GMEM_FIXED+GMEM_ZEROINIT,eax
mov    esi , eax
pop    ebx
invoke SendMessage,[hwndRichEdit],WM_GETTEXT,ebx,eax

invoke lstrcat,esi,cccccc


invoke SendMessage,[hwnd_l],LB_RESETCONTENT,0,0
invoke SendMessage,[hwnd_l0],LB_RESETCONTENT,0,0

;push	 esi
mov	[source] , esi
call	interpet

invoke SendMessage,[hwndRichEdit],EM_SETSEL,[p0],[p1]
mov    [cf.crTextColor] , 0
invoke SendMessage, [hwndRichEdit], EM_SETCHARFORMAT, SCF_SELECTION, cf

;invoke MessageBox,0,edi,0,0

invoke GlobalHandle,esi
invoke GlobalFree,eax
mov    [drw] , 0
ret
;---------------------------------------------------------------


; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

     section '.idata' import data readable writeable

     library kernel32,'KERNEL32.DLL',\
	     user32,'USER32.DLL',\
	     gdi32,'GDI32.DLL',\
	     comdlg32,'COMDLG32.DLL'

  include 'api\kernel32.inc'
  include 'api\user32.inc'
  include 'api\gdi32.inc'
  include 'api\comdlg32.inc'