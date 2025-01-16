; Nama: Ryan Yosedie Irawan
; NRP: 222117059
.model small
.stack 100h
.data
    prompt db "Input karakter: $"
    output1 db "Karakter: $"
    output2 db "Biner: $"
    output3 db "Jumlah bit 1: $"
    newline db 13, 10, '$'
    char db ?
    binary db 8 dup('0'), '$'
    one_count db 0

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Tampilkan prompt input
    lea dx, prompt
    mov ah, 09h
    int 21h

    ; Input karakter
    mov ah, 01h
    int 21h
    mov char, al

    ; Tampilkan karakter
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, output1
    mov ah, 09h
    int 21h
; Nama: Ryan Yosedie Irawan
; NRP: 222117059
    mov dl, char
    mov ah, 02h
    int 21h

    ; Konversi ke biner
    mov cx, 8
    mov al, char
    lea di, binary
convert_loop:
    shl al, 1
    jc set_one
    mov byte ptr [di], '0'
    jmp next_digit
set_one:
    mov byte ptr [di], '1'
    inc one_count
next_digit:
    inc di
    loop convert_loop

    ; Tampilkan biner
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, output2
    mov ah, 09h
    int 21h

    lea dx, binary
    mov ah, 09h
    int 21h

    ; Tampilkan jumlah bit 1
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, output3
    mov ah, 09h
    int 21h

    mov dl, one_count
    add dl, '0'
    mov ah, 02h
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h
main endp
end main
; Nama: Ryan Yosedie Irawan
; NRP: 222117059