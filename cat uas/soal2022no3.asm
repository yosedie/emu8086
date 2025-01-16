.model small
.stack 100h
.data
    max_len     db 100          ; Maximum string length
    act_len     db ?            ; Actual input length
    input_str   db 100 dup('$') ; Input buffer
    prompt      db 'Enter lowercase string: $'
    newline     db 0dh,0ah,'$'

.code
main proc
    ; Initialize data segment
    mov ax, @data
    mov ds, ax
    
    ; Display prompt
    lea dx, prompt
    mov ah, 09h
    int 21h
    
    ; Get string input
    lea dx, max_len    ; Point to input buffer
    mov ah, 0ah        ; DOS string input function
    int 21h
    
    ; Display newline
    lea dx, newline
    mov ah, 09h
    int 21h
    
    ; Process string: Setup
    lea si, input_str  ; Source index points to string
    mov cl, act_len    ; Get string length in CL
    mov ch, 0          ; Clear CH for loop counter
    mov bl, 1          ; Flag: 1 = capitalize next char, 0 = don't
    
process_loop:
    ; Get current character
    mov al, [si]
    
    ; Should we capitalize this character?
    cmp bl, 1
    jne check_space    ; If no, check if it's a space
    
    ; Capitalize current character if lowercase
    call to_upper
    mov bl, 0          ; Reset capitalize flag
    jmp save_char
    
check_space:
    ; Is current character a space?
    cmp al, ' '
    jne save_char      ; If no, save as is
    mov bl, 1          ; If yes, set flag to capitalize next char
    
save_char:
    ; Save processed character back to string
    mov [si], al
    
    ; Move to next character
    inc si
    loop process_loop
    
    ; Display result
    lea dx, input_str
    mov ah, 09h
    int 21h
    
    ; Exit program
    mov ah, 4ch
    int 21h
main endp

; Procedure to convert character to uppercase
to_upper proc
    cmp al, 'a'        ; Is character < 'a'?
    jb no_convert      ; If yes, don't convert
    cmp al, 'z'        ; Is character > 'z'?
    ja no_convert      ; If yes, don't convert
    sub al, 32         ; Convert to uppercase
no_convert:
    ret
to_upper endp

end main