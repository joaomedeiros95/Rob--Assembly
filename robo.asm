; Desenvolvido por João Eduardo Ribeiro de Medeiros, estudante de graduação em Tecnologia da Informação na UFRN
; Não é permitido a cópia e a modificação sem a presença desse cabeçalho.

.include "m328def.inc"

.def temp = R16
.def d0  = R17
.def d1  = R18
.def d2  = R19

.equ OneSecond = 16 * 1000000 / 5
;.org $0000 jmp  RESET

main:
    ldi  temp,high(RAMEND)
    out  SPH,temp
    ldi  temp,low(RAMEND)
    out  SPL,temp

Teste:
    sbis PINC, 0 ; Testa se é branco ou preto
    rjmp frente ; Se for verdadeiro pula pra "frente", c.c continua o código

    call desliga ; desliga o motor
    rjmp Teste

desliga:
                            ; definições de desligar o motor
    ldi     r24, 0xA2       ; 130
    sts     TCCR1A, r24
    ldi     r24, 0x1A       ; 26
    sts     TCCR1B, r24
    ldi     r24, 0x40       ; 64
    ldi     r25, 0x9C       ; 156
    sts     ICR1H, r25
    sts     ICR1L, r24
    ldi     r24, 0xFF       ; 255 OCR1AL
    out     0x04, r24       ; 4
    ldi     r25, 0xFF       ; 255 OCRA1H
    sts     OCR1AH, r25
    sts     OCR1AL, r24

    ret

Frente:
                            ; definições para ligar o motor
    ldi     r24, 0xA2       ; 130
    sts     TCCR1A, r24
    ldi     r24, 0x1A       ; 26
    sts     TCCR1B, r24
    ldi     r24, 0x40       ; 64
    ldi     r25, 0x9C       ; 156
    sts     ICR1H, r25
    sts     ICR1L, r24
    ldi     r24, 0xFF       ; 255 OCR1AL
    out     0x04, r24       ; 4
    ldi     r25, 0x10       ; 10 OCRA1H
    sts     OCR1AH, r25
    sts     OCR1AL, r24

    rjmp Teste

DELAY200:
                            ; função para dar delay

   ldi  d2, byte3 (OneSecond / 5)
   ldi  d1, high (OneSecond / 5)
   ldi  d0, low  (OneSecond / 5)

   subi d0, 1
   sbci d1, 0
   sbci d2, 0
   brcc pc-3

   ret
