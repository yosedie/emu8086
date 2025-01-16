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

    ; Open file TOKO.DTA
    mov ah, 3dh
    mov al, 0
    mov dx, offset filename
    int 21h
    jc error ; Jump if carry flag is set (error)

    mov bx, ax ; File handle in BX

    ; Read a record
    mov ah, 3fh
    mov cx, 35
    mov dx, offset buffer
    int 21h
    jc error

    ; While AX (bytes read) == 35
    read_loop:
        cmp ax, 35
        jne end_loop ; Exit loop if EOF

        ; Print Kodetk (9 characters)
        mov cx, 9
        lea dx, buffer
        call print_cx_bytes

        ; Print 5 spaces
        mov dx, offset spaces5
        mov ah, 9h
        int 21h

        ; Print NAMA (20 characters)
        mov cx, 20
        lea dx, buffer + 9
        call print_cx_bytes

        ; Print 4 spaces
        mov dx, offset spaces4
        mov ah, 9h
        int 21h

        ; Print Plafon (6 characters)
        mov cx, 6
        lea dx, buffer + 29
        call print_cx_bytes

        ; Print newline
        mov dx, offset newline
        mov ah, 9h
        int 21h

        ; Read next record
        mov ah, 3fh
        mov cx, 35
        mov dx, offset buffer
        int 21h
        jc error
        jmp read_loop

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
header db 'Kodetk     NAMA                Plafon$'
spaces5 db '     $' ; 5 spaces to make it clear
spaces4 db '    $'  ; 4 spaces to make it clear
newline db 13,10,'$' ; Carriage return and line feed
filename db 'TOKO.DTA', 0
buffer db 35 dup(0) ; Buffer to hold one record
errmsg db 'Error occurred.$'

print_cx_bytes:
    push ax
    push si
    mov si, dx
  print_loop:
    cmp cx, 0
    je print_done
    mov al, [si]
    mov ah, 0eh ; DOS function to display a character
    int 10h
    inc si
    loop print_loop
  print_done:
    pop si
    pop ax
    ret
