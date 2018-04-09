.386
RomSize    EQU   4096

Stk        SEGMENT AT 100h use16
; размер стека
           dw    100 dup (?)
StkTop     Label Word
Stk        ENDS

Data       SEGMENT AT 40h use16
;Здесь размещаются описания переменных
           ;бегущая строка
string     db    01h, 01h, 01h, 01h, 01h, 01h, 01h, 01h, 01h 
Data       ENDS

Code       SEGMENT use16
           ASSUME cs:Code,ds:Data,es:Data

;Здесь размещаются описания констант
           ;Образы десятичных цифр от 0 до 9
Image      db    03Fh,00Ch,076h,05Eh,04Dh,05Bh,07Bh,00Eh,07Fh,05Fh

Start:
           mov   ax,Data
           mov   ds,ax
           mov   es,ax
           mov   ax,Stk
           mov   ss,ax
           lea   sp,StkTop

; считываем скорость движения строки с ацп

; 
           lea   bx,Image    ;bx - указатель на массив образов
           lea   dx,string   ; загружаем значение цифры из стоки
            ; index pos
           add   bx, dx      ; вычисляем адрес образа цифры
           mov   al,[bx]     ; Выводим цифру на индикатор
           out   0,al
            ; вторая цифра
           lea   bx,Image
           add   bx, dx
           inc   bx
           mov   al,[bx]     ; Выводим цифру на индикатор
           out   1,al
;... 4 digits

InfLoop:
           nop
           
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
