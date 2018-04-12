.386
RomSize    EQU   4096
NMax       EQU   50

Stk        SEGMENT AT 100h use16
; размер стека
           dw    100 dup (?)
StkTop     Label Word
Stk        ENDS

Data       SEGMENT at 0 use16
;Здесь размещаются описания переменных
           ;бегущая строка 10
string     db   10 dup (?) 
delayc     db   ?
KbdImage   DB    4 DUP(?)
EmpKbd     DB    ?
KbdErr     DB    ?
NextDig    DB    ?
Data       ENDS

Code       SEGMENT use16
           ASSUME cs:Code,ds:Data,es:Code,ss:Stk

;Здесь размещаются описания констант
           ;Образы десятичных цифр от 0 до 9
Image      db    03Fh,00Ch,076h,05Eh,04Dh,05Bh,07Bh,00Eh,07Fh,05Fh

Start:
    mov   ax, Data
    mov   ds, ax
    mov   ax, Code
    mov   es, ax
    mov   ax, Stk
    mov   ss, ax
    lea   sp, StkTop

    mov   di, 11 
    mov   al, 0
    FillLoop:
    mov   string+di, al
    dec   di
    jnz   FillLoop

    mov   di, 0 ; index
    mov   dx, 0

InfLoop:
    lea   bx, Image    ;bx - указатель на массив образов
    mov   dl, string+di   ; загружаем значение цифры из стоки
    ; index pos
    add   bx, dx      ; вычисляем адрес образа цифры
    mov   al,es:[bx]     ; Выводим цифру на индикатор
    out   0, al
    ; вторая цифра
    lea   bx, Image
    add   bx, dx
    inc   bx
    mov   al,es:[bx]     ; Выводим цифру на индикатор
    out   1,al
    ; третья цифра
    lea   bx, Image
    add   bx, dx
    inc   bx
    inc   bx
    mov   al,es:[bx]     ; Выводим цифру на индикатор
    out   2,al
    ; четвертая цифра
    lea   bx, Image
    add   bx, dx
    add   bx, 3
    mov   al, es:[bx]     ; Выводим цифру на индикатор
    out   3, al

; считываем скорость движения строки с ацп
    mov cl, delayc
    test cl, 0
    jnz okcount ; ?? всё пропустим, надо прерыванием
; он выдаёт дельту? надо её добавлять, знаково
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
           mov   ax, 10
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
           ;and   al,3Fh     ;Объединение номера с
           ;or    al,MesBuff ;сообщением "Тип ввода"
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
