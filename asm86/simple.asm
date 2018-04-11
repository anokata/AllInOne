.386
RomSize    EQU   4096

Code       SEGMENT use16
           ASSUME cs:Code,ds:Data,es:Data

Image      db    03Fh,00Ch,076h,05Eh,04Dh,05Bh,07Bh,00Eh,07Fh,05Fh

Start:

mov di, 0
InfLoop:
    lea   bx, Image+di 
    mov   al,[bx]  
    out   0, al

    mov cx, 6000
    inc di
        
DelayLoop:
           inc   cx
           dec cx
           loop  DelayLoop

    jmp   InfLoop

           org   RomSize-16
           ASSUME cs:NOTHING
           jmp   Far Ptr Start
Code       ENDS
END
