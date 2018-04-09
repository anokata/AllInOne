.386
RomSize    EQU   4096

Code       SEGMENT use16
           ASSUME cs:Code,ds:Code,es:Code

           ;Образы десятичных цифр от 0 до 9
Image      db    03Fh,00Ch,076h,05Eh,04Dh,05Bh,07Bh,00Eh,07Fh,05Fh
           ;бегущая строка
string     db    01h, 01h, 01h, 01h, 01h, 01h, 01h, 01h, 01h 

Start:
           mov   ax,Code
           mov   ds,ax
           mov   es,ax

; считываем скорость движения строки с ацп

; 
           lea   bx,Image    ;bx - указатель на массив образов
           mov   dx,string   ; загружаем значение цифры из стоки
            ; index pos
           add   bx, dx      ; вычисляем адрес образа цифры
           mov   al,[bx]     ; Выводим цифру на индикатор
           out   0,al
            ; вторая цифра
           lea   bx,Image + dx
           inc   bx
           mov   al,[bx]     ; Выводим цифру на индикатор
           out   1,al
;... 4 digits

InfLoop:
           nop
           
           jmp   InfLoop



;В следующей строке необходимо указать смещение стартовой точки
           org   RomSize-16
           ASSUME cs:NOTHING
           jmp   Far Ptr Start
Code       ENDS
END
