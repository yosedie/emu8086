org 100h

; Declare variables
num1 DW ?
num2 DW ?
result DW ?
choice DB ?

; Display text
display proc
    push ax
    mov ah, 9
    int 21h
    pop ax
    ret
display endp

; Program start
START:    
    ; Display menu
    MOV AH, 09h
    mov dx, offset MENU
    call display
    
    ; Get user's choice
    MOV AH, 01h
    INT 21h
    SUB AL, '0'
    MOV choice, AL
    
    ; Ask for the first number
    LEA DX, PROMPT1
    MOV AH, 09h
    INT 21h
    CALL GET_NUMBER
    MOV num1, AX
    
    ; Ask for the second number
    LEA DX, PROMPT2
    MOV AH, 09h
    INT 21h
    CALL GET_NUMBER
    MOV num2, AX
    
    ; Perform calculation
    CMP choice, 1
    JE ADDITION
    CMP choice, 2
    JE SUBTRACTION
    CMP choice, 3
    JE MULTIPLICATION
    CMP choice, 4
    JE DIVISION
    CMP choice, 5
    JE EXPONENTIATION
    JMP INVALID_CHOICE

ADDITION:
    MOV AX, num1
    ADD AX, num2
    JMP DISPLAY_RESULT

SUBTRACTION:
    MOV AX, num1
    SUB AX, num2
    JMP DISPLAY_RESULT

MULTIPLICATION:
    MOV AX, num1
    MOV BX, num2
    MUL BX
    JMP DISPLAY_RESULT

DIVISION:
    CMP num2, 0
    JE DIVIDE_BY_ZERO
    MOV AX, num1
    XOR DX, DX
    MOV BX, num2
    DIV BX
    JMP DISPLAY_RESULT

EXPONENTIATION:
    MOV CX, num2
    MOV AX, num1
    CMP CX, 0
    JE DONE_EXP
    DEC CX
EXP_LOOP:
    MUL num1
    LOOP EXP_LOOP
DONE_EXP:
    JMP DISPLAY_RESULT

DIVIDE_BY_ZERO:
    LEA DX, DIV_BY_ZERO_MSG
    MOV AH, 09h
    INT 21h
    JMP START

DISPLAY_RESULT:
    MOV result, AX
    LEA DX, RESULT_MSG
    MOV AH, 09h
    INT 21h
    
    ; Display first number
    MOV AX, num1
    CALL DISPLAY_NUMBER
    
    MOV AH, 02h
    MOV DL, ' '
    INT 21h
    
    ; Display operator
    MOV AL, choice
    CMP AL, 1
    JE DISP_PLUS
    CMP AL, 2
    JE DISP_MINUS
    CMP AL, 3
    JE DISP_MULT
    CMP AL, 4
    JE DISP_DIV
    CMP AL, 5
    JE DISP_EXP
    JMP INVALID_CHOICE

DISP_PLUS:
    MOV DL, '+'
    JMP DISP_END
DISP_MINUS:
    MOV DL, '-'
    JMP DISP_END
DISP_MULT:
    MOV DL, '*'
    JMP DISP_END
DISP_DIV:
    MOV DL, '/'
    JMP DISP_END
DISP_EXP:
    MOV DL, '^'
DISP_END:
    INT 21h
    
    MOV AH, 02h
    MOV DL, ' '
    INT 21h
    
    ; Display second number
    MOV AX, num2
    CALL DISPLAY_NUMBER
    
    MOV AH, 02h
    MOV DL, ' '
    INT 21h
    MOV DL, '='
    INT 21h
    MOV DL, ' '
    INT 21h
    
    ; Display result
    MOV AX, result
    CALL DISPLAY_NUMBER
    
    ; Ask to continue
    LEA DX, CONTINUE_MSG
    MOV AH, 09h
    INT 21h
    MOV AH, 01h
    INT 21h
    CMP AL, 'y'
    JNE CHECK_EXIT
    ; Clear screen before starting new calculation
    CALL clear_screen
    JMP START
    
CHECK_EXIT:
    CMP AL, 'n'
    JE EXIT
    JMP INVALID_CHOICE

GET_NUMBER:
    XOR AX, AX
    MOV CX, 0
INPUT_LOOP:
    MOV AH, 01h
    INT 21h
    CMP AL, 13
    JE DONE_INPUT
    SUB AL, '0'
    MOV BL, AL
    MOV AX, CX
    MOV CL, 10
    MUL CL
    ADD AX, BX
    MOV CX, AX
    JMP INPUT_LOOP
DONE_INPUT:
    MOV AX, CX
    RET

DISPLAY_NUMBER:
    PUSH AX
    XOR CX, CX
    MOV BX, 10
DIV_LOOP:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    OR AX, AX
    JNZ DIV_LOOP
PRINT_LOOP:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP PRINT_LOOP
    POP AX
    RET

INVALID_CHOICE:
    LEA DX, INVALID_MSG
    MOV AH, 09h
    INT 21h
    JMP START

EXIT:
    MOV AH, 4Ch
    INT 21h
              

; Clear screen procedure
clear_screen proc
    push ax
    push bx
    push cx
    push dx
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    mov ah, 02h
    mov bh, 0
    mov dx, 0000h
    int 10h
    pop dx
    pop cx
    pop bx
    pop ax
    jmp START
clear_screen endp              
              
MENU DB "Calculator Program", 13, 10
    DB "1. Addition", 13, 10
    DB "2. Subtraction", 13, 10
    DB "3. Multiplication", 13, 10
    DB "4. Division", 13, 10
    DB "5. Exponentiation", 13, 10
    DB "Choose an option: $"
PROMPT1 DB 13, 10, "Enter the first number: $"
PROMPT2 DB 13, 10, "Enter the second number: $"
RESULT_MSG DB 13, 10, "Result: $"
CONTINUE_MSG DB 13, 10, "Would you like to continue? (y/n): $"
DIV_BY_ZERO_MSG DB 13, 10, "Error: Division by zero!", 13, 10, "$"
INVALID_MSG DB 13, 10, "Invalid choice. Try again.", 13, 10, "$"