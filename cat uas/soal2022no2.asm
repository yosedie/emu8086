.model small
.stack 100h
.data
    filename db 'nrp.txt',0
    buffer db 1000 dup('$')    ; Buffer for file content
    search_nrp db 10 dup('$')  ; 9 chars + '$'
    temp_nrp db 10 dup('$')    
    temp_name db 31 dup('$')   
    temp_amount db 7 dup('$')  
    
    prompt db 'Enter NRP to search (9 digits): $'
    not_found_msg db 'Data yang dicari tidak ada!$'
    found_header db 'NRP          Nama                              Amount $'
    nrp_label db 'NRP    : $'
    name_label db 'Name   : $'
    amount_label db 'Amount : $'
    spaces5 db '     $'     ; 5 spaces for formatting
    spaces4 db '    $'      ; 4 spaces for formatting
    newline db 0dh,0ah,'$'
    file_error_msg db 'Error opening file!$'

.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Display prompt and get NRP
    lea dx, prompt
    mov ah, 09h
    int 21h
    
    ; Get NRP input
    mov ah, 0ah
    lea dx, search_nrp
    int 21h
    
    ; Add newline
    lea dx, newline
    mov ah, 09h
    int 21h
    
    ; Open file
    mov ah, 3dh
    mov al, 0          ; Read mode
    lea dx, filename
    int 21h
    jc file_error      
    
    mov bx, ax         ; Save file handle
    
    ; Read file
    mov ah, 3fh
    mov cx, 1000       
    lea dx, buffer
    int 21h
    
    ; Close file
    push ax            
    mov ah, 3eh
    int 21h
    pop ax             
    
    ; Process file contents
    lea si, buffer     
    mov cx, ax         
    
scan_loop:
    ; Compare NRP
    push cx
    mov cx, 9          
    lea di, search_nrp + 2  
    push si
    call compare_nrp
    pop si
    pop cx
    jz found_record
    
    call find_newline
    jc not_found       
    loop scan_loop
    
    jmp not_found

found_record:
    ; Display found header
    lea dx, found_header
    mov ah, 09h
    int 21h
    lea dx, newline
    int 21h
    
    ; Display NRP
    ;lea dx, nrp_label
    ;mov ah, 09h
    ;int 21h
    push cx
    mov cx, 9
    call display_field
    
    mov dx, offset spaces4
    mov ah, 9h
    int 21h
    ;lea dx, newline
    ;mov ah, 09h
    ;int 21h
    
    ; Display name
    ;lea dx, name_label
    ;mov ah, 09h
    ;int 21h
    ;add si, 9          ; Skip past NRP
    mov cx, 30         ; Name length
    call display_field
    
    mov dx, offset spaces4
    mov ah, 9h
    int 21h
    ;lea dx, newline
    ;mov ah, 09h
    ;int 21h
    
    ; Display amount
    ;lea dx, amount_label
    ;mov ah, 09h
    ;int 21h
    ;add si, 20          ; Skip past Nama
    mov cx, 6          ; Amount length
    call display_field
    ;lea dx, newline
    ;mov ah, 09h
    ;int 21h
    
    pop cx
    jmp exit_program

file_error:
    lea dx, file_error_msg
    mov ah, 09h
    int 21h
    jmp exit_program

not_found:
    lea dx, not_found_msg
    mov ah, 09h
    int 21h

exit_program:
    mov ah, 4ch
    int 21h
main endp

; Compare NRP procedure
compare_nrp proc
    push si
    push di
    push cx
compare_loop:
    mov al, [si]
    cmp al, [di]
    jne not_equal
    inc si
    inc di
    loop compare_loop
    pop cx
    pop di
    pop si
    xor ax, ax         ; Set zero flag
    ret
not_equal:
    pop cx
    pop di
    pop si
    mov ax, 1          ; Clear zero flag
    ret
compare_nrp endp

; Find next newline character
find_newline proc
    find_loop:
        mov al, [si]
        inc si
        cmp al, 0dh    ; Check for CR
        je found_nl
        cmp al, '$'    ; Check for end of buffer
        je eof
        loop find_loop
    eof:
        stc            ; Set carry flag for EOF
        ret
    found_nl:
        inc si         ; Skip LF
        clc            ; Clear carry flag
        ret
find_newline endp

; Display field procedure
display_field proc
    push cx
display_loop:
    mov dl, [si]
    mov ah, 02h
    int 21h
    inc si
    loop display_loop
    pop cx
    ret
display_field endp

end main