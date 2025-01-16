org 100h

start:
    jmp proses

n            db      ?  ; Input angka
jumspasi     db      ?  ; Jumlah spasi saat ini
jumbintang   db      ?  ; Jumlah bintang saat ini

; Fungsi Untuk Meminta Inputan -> hasil ada di reg AL
read:
    mov ah,1
    int 21h
    sub al,48        ; Konversi ASCII ke angka
    ret

; Fungsi Untuk Mencetak 1 Karakter -> karakter di reg DL
write:
    mov ah,2
    int 21h         ; Cetak karakter di DL
    ret

; Fungsi Untuk Turun Baris
newline:
    mov ah,2
    mov dl,13       ; Carriage return
    int 21h
    mov dl,10       ; Line feed
    int 21h
    ret

; Fungsi Untuk Mencetak Bagian Bawah Berlian
bottom_diamond:
    mov jumspasi,0          ; Spasi awal = 0
    mov al,n
    ; Calculate starting stars as n*2 - 1
    mov bl,al
    shl bl,1                ; Multiply n by 2
    dec bl                  ; Subtract 1 to get n*2 - 1
    mov jumbintang,bl       ; Set number of stars

down_diamond:
    mov cl,jumspasi         ; Cetak spasi
print_space:
    cmp cl,0
    je done_space
    mov dl,' '
    call write
    dec cl
    jmp print_space

done_space:
    mov cl,jumbintang       ; Cetak bintang
print_star:
    cmp cl,0
    je done_star
    mov dl,'*'
    call write
    dec cl
    jmp print_star

done_star:
    call newline
    inc jumspasi            ; Tambah spasi
    sub jumbintang,2        ; Kurangi bintang dengan 2 (simetri)
    cmp jumbintang,0
    jg down_diamond
    ret

proses:
    call read               ; Baca input pengguna
    mov n,al

    call newline
    call bottom_diamond     ; Cetak bagian bawah berlian

selesai:
    ret

end start
