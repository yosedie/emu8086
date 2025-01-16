; Nama: Ryan Yosedie Irawan
; NRP: 222117059

org 100h          ; Menentukan offset untuk .COM file

start:
    mov cx, 5     ; Jumlah baris segitiga

print_loop:
    push cx       ; Simpan nilai cx
    mov bx, 1     ; Reset kolom

print_column:
    ; Cetak angka dari 1 sampai bx
    mov ax, bx    ; Angka yang akan dicetak
    call print_number
    inc bx
    cmp bx, cx
    jbe print_column

    ; Pindah ke baris berikutnya
    mov ah, 02h   ; Fungsi untuk enter (newline)
    mov dl, 0Ah   ; ASCII untuk LF (line feed)
    int 21h
    mov dl, 0Dh   ; ASCII untuk CR (carriage return)
    int 21h

    pop cx        ; Kembali ke cx
    dec cx
    jnz print_loop ; Ulangi hingga selesai

    ; Exit program
    mov ax, 4C00h ; Fungsi untuk keluar
    int 21h

print_number:
    ; Prosedur untuk mencetak angka dalam register ax
    ; Mengubah angka ke karakter dan menampilkannya
    add ax, '0'    ; Konversi ke karakter ASCII
    mov dl, al     ; Pindahkan ke DL
    mov ah, 02h    ; Fungsi untuk menampilkan karakter
    int 21h
    ret
