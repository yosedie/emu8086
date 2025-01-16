; Nama: Ryan Yosedie Irawan
; NRP: 222117059

org 100h          ; Menentukan offset untuk .COM file

start:
    ; Status peralatan
    mov al, 0Eh   ; Status CHECKPOINT: 0b00001110
                  ; Bit 1 (valve 1), Bit 2 (valve 2), Bit 3 (valve 3) 

    ; Memeriksa valve 1 (bit 1)
    mov bl, 0     ; BL untuk menyimpan status valve 1
    test al, 2    ; Memeriksa bit ke-1
    jz valve1_normal
    mov bl, '1'   ; Valve 1 rusak
    jmp check_valve2

valve1_normal:
    mov bl, '0'   ; Valve 1 normal

check_valve2:
    ; Memeriksa valve 2 (bit 4)
    test al, 16   ; Memeriksa bit ke-4
    jz valve2_normal
    mov bh, '2'   ; Valve 2 rusak
    jmp check_valve3

valve2_normal:
    mov bh, '0'   ; Valve 2 normal

check_valve3:
    ; Memeriksa valve 3 (bit 8)
    test al, 8    ; Memeriksa bit ke-3
    jz valve3_normal
    mov cl, '3'   ; Valve 3 rusak
    jmp print_result

valve3_normal:
    mov cl, '0'   ; Valve 3 normal

print_result:
    ; Mencetak hasil ke layar
    mov ah, 02h   ; Fungsi untuk menampilkan karakter
    mov dl, bl    ; Menampilkan status valve 1
    int 21h
    mov dl, bh    ; Menampilkan status valve 2
    int 21h
    mov dl, cl    ; Menampilkan status valve 3
    int 21h

    ; Exit program
    mov ax, 4C00h ; Fungsi untuk keluar
    int 21h
