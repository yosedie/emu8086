.model small
.stack 100h
.data
    filename db "DATAMHS.DTA", 0
    filehandle dw ?
    
    prompt_nrp db "Masukkan NRP (9 digit, masukkan 0 untuk selesai): $"
    prompt_nama db 13, 10, "Masukkan Nama (max 20 karakter): $"
    prompt_total db 13, 10, "Masukkan Total (max 6 digit): $"
    new_line db 13, 10, "$"
    
    nrp db 10 dup(?)    ; 9 digits + 1 for '$'
    nama db 21 dup(?)   ; 20 chars + 1 for '$'
    total db 7 dup(?)   ; 6 digits + 1 for '$'
    buffer db 37 dup(' ')  ; Buffer for writing to file (9+20+6+2=37, including CR+LF)
    temp db ?           ; Temporary storage for first digit check
    
    error_msg db "Error dalam membuka/membuat file!$"
    success_msg db 13, 10, "Data berhasil disimpan!$"

.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Create/Open file
    mov ah, 3Ch      ; Create file function
    mov cx, 0        ; Normal attribute
    lea dx, filename
    int 21h
    jc error        ; If carry flag set, error occurred
    mov filehandle, ax
    
input_loop:
    ; Clear buffer with spaces
    lea di, buffer
    mov cx, 35      ; Clear main data area (9+20+6)
    mov al, ' '
clear_main_buffer:
    mov [di], al
    inc di
    loop clear_main_buffer
    
    ; Add CR+LF at the end of buffer
    mov byte ptr [di], 0Dh    ; CR
    mov byte ptr [di+1], 0Ah  ; LF
    
    ; Input NRP
    lea dx, prompt_nrp
    mov ah, 09h
    int 21h
    
    ; Read first character of NRP
    mov ah, 01h
    int 21h
    mov temp, al
    
    ; Check if first input is '0'
    cmp temp, '0'
    je close_file
    
    ; Store first digit and continue reading NRP
    lea si, buffer   ; Write directly to buffer
    mov al, temp
    mov [si], al
    inc si
    mov cx, 8       ; Read remaining 8 characters
read_remaining_nrp:
    mov ah, 01h     ; Read character
    int 21h
    mov [si], al
    inc si
    loop read_remaining_nrp
    
    ; Input Nama
    lea dx, prompt_nama
    mov ah, 09h
    int 21h
    
    ; Read Nama (starting at buffer position 9)
    mov cx, 0       ; Counter for name characters
    mov si, 9       ; Offset for name in buffer
input_nama:
    mov ah, 01h     ; Read character
    int 21h
    cmp al, 13      ; Check for Enter key
    je input_total_prep
    mov buffer[si], al
    inc si
    inc cx
    cmp cx, 20      ; Max 20 characters
    jae input_total_prep
    jmp input_nama
    
input_total_prep:
    lea dx, prompt_total
    mov ah, 09h
    int 21h
    
    ; Read Total (starting at buffer position 29)
    mov si, 29      ; Offset for total in buffer
    mov cx, 6       ; Read 6 characters
read_total:
    mov ah, 01h     ; Read character
    int 21h
    mov buffer[si], al
    inc si
    loop read_total
    
    ; Write to file
    mov ah, 40h         ; Write to file function
    mov bx, filehandle
    mov cx, 37          ; Total length (9+20+6+2) including CR+LF
    lea dx, buffer
    int 21h
    
    lea dx, new_line
    mov ah, 09h
    int 21h
    
    jmp input_loop
    
close_file:
    ; Close file
    mov ah, 3Eh
    mov bx, filehandle
    int 21h
    
    ; Display success message
    lea dx, success_msg
    mov ah, 09h
    int 21h
    jmp exit
    
error:
    lea dx, error_msg
    mov ah, 09h
    int 21h
    
exit:
    mov ah, 4Ch
    int 21h
    
end main