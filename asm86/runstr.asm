.386
RomSize    EQU   4096
NMax       EQU   50
KbdPort    EQU   09h
ACPPort    EQU   8
ACPIN      EQU   0
DELAYN     EQU   4000
BtnStart   EQU   2
BtnStop    EQU   3
BtnReset   EQU   4

Stk        SEGMENT AT 100h use16
; размер стека
           dw    1100 dup (?)
StkTop     Label Word
Stk        ENDS

Data       SEGMENT at 0 use16
;Здесь размещаются описания переменных
           ;бегущая строка 10
string     db   10 dup (?) 
delayc     db   ?
KbdImage   DB   4 DUP(?)
EmpKbd     DB   ?
KbdErr     DB   ?
NextDig    DB   ?
Data       ENDS

Code       SEGMENT use16
           ASSUME cs:Code,ds:Data,es:Code,ss:Stk

;Здесь размещаются описания констант
           ;Образы десятичных цифр от 0 до 9
Image      db    03Fh,00Ch,076h,05Eh,04Dh,05Bh,07Bh,00Eh,07Fh,05Fh

Start:
;main is
;call main_step
;call delay
;jmp start
;main_step:
;display
;if move: shift
;check buttons
;check spd acp
;check keys
    mov   ax, Data
    mov   ds, ax
    mov   ax, Code
    mov   es, ax
    mov   ax, Stk
    mov   ss, ax
    lea   sp, StkTop
    call init

InfLoop:

; считываем скорость движения строки с ацп
;check spd acp
    call acp_spd
okcount:
    call Delay
    call display_digits
        
; смещаем индекс текущего символа
    inc   di
    cmp   di, 10
    jnz   Savedi
    mov   di, 0
Savedi:

; ввод цифр с клавиатуры
    call  KbdInput
    call  KbdInContr
    call  NxtDigTrf
; сброс 
    jmp   InfLoop


init proc
    mov   si, 0
    mov   di, LENGTH string
    mov   al, 0
    FillLoop:
    mov   string+di, al
    dec   di
    jnz   FillLoop

    mov   di, 0 ; index
    mov   dx, 0
    ret
init endp

display_digits     proc near
    lea   bx, Image    ;bx - указатель на массив образов
    mov   dl, string+di   ; загружаем значение цифры из стоки
    add   bx, dx      ; вычисляем адрес образа цифры
    mov   al,es:[bx]     ; Выводим цифру на индикатор
    out   0, al
    ; вторая цифра
    add   di, 1
    lea   bx, Image
    mov   dl, string+di   
    sub   di, 1
    add   bx, dx
    mov   al,es:[bx]     ; Выводим цифру на индикатор
    out   1,al
    ; третья цифра
    add   di, 2
    lea   bx, Image
    mov   dl, string+di   
    sub   di, 2
    add   bx, dx
    mov   al,es:[bx]     ; Выводим цифру на индикатор
    out   2,al
    ; четвертая цифра
    add   di, 3
    lea   bx, Image
    mov   dl, string+di   
    sub   di, 3
    add   bx, dx
    mov   al, es:[bx]     ; Выводим цифру на индикатор
    out   3, al
    ret
display_digits endp

acp_spd      proc  near ; out cx
    mov al, 0
    out ACPPort, al
    mov al, 1
    out ACPPort, al
    waitrdy:
    in al, ACPPort
    test al, 1
    jz waitrdy
    in al, ACPIN
    mov  delayc, al
    mov  cx, 0
    mov  cl, al
    ret
acp_spd      endp

Delay      proc  near ; param cx=count
    inc   cx
    not   cl
    add   ax, DELAYN
LoopTen:
    push  cx
DelayLoop:
    inc   cx
    dec   cx
    loop  DelayLoop
    pop   cx
    dec   ax
    jnz   LoopTen
    ret
Delay      endp


VibrDestr  PROC  NEAR
VD1:       mov   ah,al       ;Сохранение исходного состояния
           mov   bh,0        ;Сброс счётчика повторений
VD2:       in    al,dx       ;Ввод текущего состояния
           cmp   ah,al       ;Текущее состояние=исходному?
           jne   VD1         ;Переход, если нет
           inc   bh          ;Инкремент счётчика повторений
           cmp   bh,NMax     ;Конец дребезга?
           jne   VD2         ;Переход, если нет
           mov   al,ah       ;Восстановление местоположения данных
           ret
VibrDestr  ENDP

KbdInput   PROC  NEAR
           lea   si,KbdImage         ;Загрузка адреса,
           mov   cx,LENGTH KbdImage  ;счётчика циклов
           mov   bl,0FEh             ;и номера исходной строки
KI4:       mov   al,bl       ;Выбор строки
           out   KbdPort,al  ;Активация строки
           in    al,KbdPort  ;Ввод строки
           and   al,0Fh      ;Включено?
           cmp   al,0Fh
           jz    KI1         ;Переход, если нет
           mov   dx,KbdPort  ;Передача параметра
           call  VibrDestr   ;Гашение дребезга
           mov   [si],al     ;Запись строки
KI2:       in    al,KbdPort  ;Ввод строки
           and   al,0Fh      ;Выключено?
           cmp   al,0Fh
           jnz   KI2         ;Переход, если нет
           call  VibrDestr   ;Гашение дребезга
           jmp   SHORT KI3
KI1:       mov   [si],al     ;Запись строки
KI3:       inc   si          ;Модификация адреса
           rol   bl,1        ;и номера строки
           loop  KI4         ;Все строки? Переход, если нет
           ret
KbdInput   ENDP

KbdInContr PROC  NEAR
           lea   bx,KbdImage ;Загрузка адреса
           mov   cx,4        ;и счётчика строк
           mov   EmpKbd,0    ;Очистка флагов
           mov   KbdErr,0
           mov   dl,0        ;и накопителя
KIC2:      mov   al,[bx]     ;Чтение строки
           mov   ah,4        ;Загрузка счётчика битов
KIC1:      shr   al,1        ;Выделение бита
           cmc               ;Подсчёт бита
           adc   dl,0
           dec   ah          ;Все биты в строке?
           jnz   KIC1        ;Переход, если нет
           inc   bx          ;Модификация адреса строки
           loop  KIC2        ;Все строки? Переход, если нет
           cmp   dl,0        ;Накопитель=0?
           jz    KIC3        ;Переход, если да
           cmp   dl,1        ;Накопитель=1?
           jz    KIC4        ;Переход, если да
           mov   KbdErr,0FFh ;Установка флага ошибки
           jmp   SHORT KIC4
KIC3:      mov   EmpKbd,0FFh ;Установка флага пустой клавиатуры
KIC4:      ret
KbdInContr ENDP

NxtDigTrf  PROC  NEAR
           cmp   EmpKbd,0FFh ;Пустая клавиатура?
           jz    NDT1        ;Переход, если да
           cmp   KbdErr,0FFh ;Ошибка клавиатуры?
           jz    NDT1        ;Переход, если да
           lea   bx,KbdImage ;Загрузка адреса
           mov   dx,0        ;Очистка накопителей кода строки и столбца
NDT3:      mov   al,[bx]     ;Чтение строки
           and   al,0Fh      ;Выделение поля клавиатуры
           cmp   al,0Fh      ;Строка активна?
           jnz   NDT2        ;Переход, если да
           inc   dh          ;Инкремент кода строки
           inc   bx          ;Модификация адреса
           jmp   SHORT NDT3
NDT2:      shr   al,1        ;Выделение бита строки
           jnc   NDT4        ;Бит активен? Переход, если да
           inc   dl          ;Инкремент кода столбца
           jmp   SHORT NDT2
NDT4:      mov   cl,2        ;Формировние двоичного кода цифры
           shl   dh,cl
           or    dh,dl
           mov   NextDig,dh  ;Запись кода цифры
NDT1:      ret
NxtDigTrf  ENDP

;В следующей строке необходимо указать смещение стартовой точки
           org   RomSize-16
           ASSUME cs:NOTHING
           jmp   Far Ptr Start
Code       ENDS
END
