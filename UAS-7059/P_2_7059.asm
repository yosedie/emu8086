; Nama: Ryan Yosedie Irawan
; NRP: 222117059
.model small
.stack 100h
.data
    prompt1 db "Masukkan bilangan pertama (min 5 digit): $"
    prompt2 db 13, 10, "Masukkan bilangan kedua (min 5 digit): $"
    result_msg db 13, 10, "Hasil penjumlahan: $"
    newline db 13, 10, "$"
    buffer1 dw 0
    buffer2 dw 0
    result dw 0
    error_msg db 13, 10, "Input salah! Minimal 5 digit.$"

.code
start:
    mov ax, @data
    mov ds, ax

; Input bilangan pertama
input_first_number:
    lea dx, prompt1
    mov ah, 09h
    int 21h

    lea si, buffer1
    call read_number
    jc input_first_number ; Jika input salah, ulangi

; Input bilangan kedua
input_second_number:
    lea dx, prompt2
    mov ah, 09h
    int 21h

    lea si, buffer2
    call read_number
    jc input_second_number ; Jika input salah, ulangi

; Penjumlahan buffer1 dan buffer2
    mov ax, buffer1
    add ax, buffer2
    mov result, ax

; Tampilkan hasil
    lea dx, result_msg
    mov ah, 09h
    int 21h

    mov ax, result
    call print_number

; Akhiri program
    mov ah, 4Ch
    int 21h

; Subrutin untuk membaca input angka
read_number proc
    push ax
    push bx
    push cx
    push dx
; Nama: Ryan Yosedie Irawan
; NRP: 222117059
    mov cx, 0           ; Hitung digit
    mov bx, 0           ; Reset angka
    mov ah, 01h
read_loop:
    int 21h
    cmp al, 13          ; Enter key
    je validate_input
    sub al, '0'         ; Konversi ASCII ke angka
    jl input_error
    cmp al, 9
    jg input_error
    imul bx, 10
    add bx, ax
    inc cx
    jmp read_loop

validate_input:
    cmp cx, 5           ; Minimal 5 digit
    jl input_error
    mov ax, bx
    mov [si], ax        ; Simpan hasil ke buffer
    clc                 ; Clear carry flag (tidak ada error)
    jmp done

input_error:
    lea dx, error_msg
    mov ah, 09h
    int 21h
    stc                 ; Set carry flag (ada error)

done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
read_number endp
; Subrutin untuk mencetak angka
print_number proc
    push ax
    push bx
    push cx
    push dx

    mov bx, 10          ; Basis angka desimal
    xor cx, cx
print_loop:
    xor dx, dx
    div bx              ; Bagi AX dengan 10
    push dx             ; Sisa dibagi 10 (digit terakhir)
    inc cx
    test ax, ax
    jnz print_loop      ; Ulangi sampai AX = 0

print_digits:
    pop dx              ; Ambil digit dari stack
    add dl, '0'         ; Konversi ke ASCII
    mov ah, 02h
    int 21h
    loop print_digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_number endp

end start
; Nama: Ryan Yosedie Irawan
; NRP: 222117059