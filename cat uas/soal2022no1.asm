org 100h

.model small
.stack 100h
.data
    prompt1     db 'String_1: $'
    prompt2     db 'String_2: $'
    prompt3     db 'String_3: $'
    prompt_com  db 'String_com: $'
    newline     db 13,10,'$'
    space       db ' $'
    
    str1        db 50,?,50 dup('$')  ; First string buffer
    str2        db 50,?,50 dup('$')  ; Second string buffer
    str3        db 50,?,50 dup('$')  ; Third string buffer
    str_com     db 150 dup('$')      ; Combined string buffer

.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Input first string
    lea dx, prompt1
    mov ah, 09h
    int 21h
    
    lea dx, str1
    mov ah, 0ah
    int 21h
    
    ; Print newline
    lea dx, newline
    mov ah, 09h
    int 21h
    
    ; Input second string
    lea dx, prompt2
    mov ah, 09h
    int 21h
    
    lea dx, str2
    mov ah, 0ah
    int 21h
    
    ; Print newline
    lea dx, newline
    mov ah, 09h
    int 21h
    
    ; Input third string
    lea dx, prompt3
    mov ah, 09h
    int 21h
    
    lea dx, str3
    mov ah, 0ah
    int 21h
    
    ; Print newline
    lea dx, newline
    mov ah, 09h
    int 21h
    
    ; Combine strings
    lea si, str1 + 2      ; Source index points to first string
    lea di, str_com       ; Destination index points to combined string
    
    ; Copy first string
    mov cl, str1 + 1      ; Get length of first string
    mov ch, 0
    rep movsb
    
    ; Add space
    mov al, ' '
    stosb
    
    ; Copy second string
    lea si, str2 + 2      ; Point to second string
    mov cl, str2 + 1      ; Get length
    mov ch, 0
    rep movsb
    
    ; Add space
    mov al, ' '
    stosb
    
    ; Copy third string
    lea si, str3 + 2      ; Point to third string
    mov cl, str3 + 1      ; Get length
    mov ch, 0
    rep movsb
    
    ; Display combined string
    lea dx, prompt_com
    mov ah, 09h
    int 21h
    
    lea dx, str_com
    mov ah, 09h
    int 21h
    
    ; Exit program
    mov ax, 4c00h
    int 21h
main endp
end main