org 100h
start:
    ; Initialize data segment
    mov ax, cs
    mov ds, ax
    
    ; Print header
    mov dx, offset header
    mov ah, 9h
    int 21h
    
    ; Print newline after header
    mov dx, offset newline
    mov ah, 9h
    int 21h
    
    ; Open file DATAMHS.DTA
    mov ah, 3dh
    mov al, 0
    mov dx, offset filename
    int 21h
    jc error        ; Jump if carry flag is set (error)
    mov bx, ax      ; File handle in BX
    
    ; Read a record
read_loop:
    ; Read next record (37 bytes including CR+LF)
    mov ah, 3fh
    mov cx, 57      ; Changed to 37 to include CR+LF -----New change from 37 to 57 (space management)
    mov dx, offset buffer
    int 21h
    jc error
    
    ; Check for EOF or partial read
    cmp ax, 0
    je end_loop     ; Exit if EOF (0 bytes read)
    cmp ax, 57      ; Check if we read a full record -------New change from 37 to 57 (space management)
    jne error       ; Error if partial record
        
    ; Print NRP (9 characters)
    mov cx, 9
    lea dx, buffer
    call print_cx_bytes
    
    ; Print spacing
    mov dx, offset spaces5
    mov ah, 9h
    int 21h
    
    ; Print Nama (20 characters)
    mov cx, 20
    lea dx, buffer + 9
    call print_cx_bytes
    
    ; Print spacing
    mov dx, offset spaces4
    mov ah, 9h
    int 21h
    
    ; Print Something (20 characters)-----------------New
    mov cx, 20
    lea dx, buffer + 29
    call print_cx_bytes
    
    ; Print spacing--------------------------------New
    mov dx, offset spaces4
    mov ah, 9h
    int 21h
    
    ; Print Total (6 characters)
    mov cx, 6
    lea dx, buffer + 49 ;change from 29 to 49 (space management)
    call print_cx_bytes
    
    ; Print newline
    mov dx, offset newline
    mov ah, 9h
    int 21h
    
    jmp read_loop   ; Continue reading next record
    
end_loop:
    ; Close file
    mov ah, 3eh
    int 21h
    
    ; Exit program
    mov ah, 4ch
    int 21h

error:
    ; Handle error, print error message
    mov dx, offset errmsg
    mov ah, 9h
    int 21h
    mov ah, 4ch
    int 21h

; Data declarations
header  db 'NRP           NAMA                    TOTAL$'
spaces5 db '     $'     ; 5 spaces for formatting
spaces4 db '    $'      ; 4 spaces for formatting
newline db 13,10,'$'    ; Carriage return and line feed
filename db 'DATAMHS.DTA',0
buffer  db 57 dup(0)    ; Buffer to hold one record (35 + CR + LF)------New change from 37 to 57 (space management)
errmsg  db 'Error reading file.$'

; Procedure to print CX bytes starting from DX
print_cx_bytes proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si, dx      ; SI points to start of string
print_loop:
    mov al, [si]    ; Get character
    mov ah, 0eh     ; BIOS teletype output
    mov bh, 0       ; Page 0
    int 10h         ; Print character
    inc si          ; Next character
    loop print_loop
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_cx_bytes endp