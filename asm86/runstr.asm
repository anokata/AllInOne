.386
RomSize    EQU   4096

Stk        SEGMENT AT 100h use16
; размер стека
           dw    100 dup (?)
StkTop     Label Word
Stk        ENDS

Data       SEGMENT at 0 use16
;Здесь размещаются описания переменных
           ;бегущая строка 10
string     db   10 dup (1) 
delayc     db   1
Data       ENDS

Code       SEGMENT use16
           ASSUME cs:Code,ds:Data,es:Data

;Здесь размещаются описания констант
           ;Образы десятичных цифр от 0 до 9
Image      db    03Fh,00Ch,076h,05Eh,04Dh,05Bh,07Bh,00Eh,07Fh,05Fh

Start:
    mov   ax, Data
    mov   ds, ax
    mov   es, ax
    mov   ax, Stk
    mov   ss, ax
    lea   sp, StkTop
    mov   di, 0 ; index

InfLoop:
    lea   bx, Image    ;bx - указатель на массив образов
    lea   dx, string+di   ; загружаем значение цифры из стоки
    ; index pos
    add   bx, dx      ; вычисляем адрес образа цифры
    mov   al,[bx]     ; Выводим цифру на индикатор
    out   0, al
    ; вторая цифра
    lea   bx, Image
    add   bx, dx
    inc   bx
    mov   al,[bx]     ; Выводим цифру на индикатор
    out   1,al
    ; третья цифра
    lea   bx, Image
    add   bx, dx
    inc   bx
    inc   bx
    mov   al,[bx]     ; Выводим цифру на индикатор
    out   2,al
    ; четвертая цифра
    lea   bx, Image
    add   bx, dx
    add   bx, 3
    mov   al, [bx]     ; Выводим цифру на индикатор
    out   3, al

; считываем скорость движения строки с ацп
mov cl, delayc
test cl, 0
jnz okcount
    mov al, 0
    out 8, al
    mov al, 1
    out 8, al
    waitrdy:
    in al, 8
    test al, 1
    jz waitrdy
    in al, 0
    mov  delayc, al
    mov  cx, 0
    mov  cl, al
okcount:
    shl cx, 8
    call Delay
        
; смещаем индекс текущего символа
    inc   di
    cmp   di, 10
    jnz   Savedi
    mov   di, 0
Savedi:

; ввод цифр с клавиатуры

; сброс
 
    jmp   InfLoop



Delay      proc  near ; param cx=count
           push  cx
DelayLoop:
           inc   cx
           dec cx
           loop  DelayLoop
           pop   cx
           ret
Delay      endp


;В следующей строке необходимо указать смещение стартовой точки
           org   RomSize-16
           ASSUME cs:NOTHING
           jmp   Far Ptr Start
Code       ENDS
END
