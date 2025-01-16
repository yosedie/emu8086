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

; Fungsi Untuk Mencetak Pola Berlian
diamond:
    ; Bagian atas berlian (termasuk baris tengah)
    mov dl,n
    mov jumspasi,dl
    dec jumspasi       ; spasi awal = n-1
    mov jumbintang,1   ; bintang awal = 1

    mov ah,0
    mov ch,0           ; Baris counter

upper_diamond:
    mov cl,jumspasi    ; Cetak spasi
print_space:
    cmp cl,0
    je done_space
    mov dl,' '
    call write
    dec cl
    jmp print_space

done_space:
    mov cl,jumbintang  ; Cetak bintang
print_star:
    cmp cl,0
    je done_star
    mov dl,'*'
    call write
    dec cl
    jmp print_star

done_star:
    call newline
    dec jumspasi       ; Kurangi spasi
    add jumbintang,2   ; Tambah bintang
    inc ch
    mov al,n
    cmp ch,al
    jl upper_diamond

    ; Bagian bawah berlian (tanpa baris tengah)
    mov jumspasi,1
    mov al,n
    shl al,1
    dec al
    mov jumbintang,al  ; Inisialisasi jumlah bintang untuk bawah
    sub jumbintang,2    ; Kurangi bintang awal untuk menghindari duplikasi tengah

down_diamond:
    mov cl,jumspasi    ; Cetak spasi
print_space2:
    cmp cl,0
    je done_space2
    mov dl,' '
    call write
    dec cl
    jmp print_space2

done_space2:
    mov cl,jumbintang  ; Cetak bintang
print_star2:
    cmp cl,0
    je done_star2
    mov dl,'*'
    call write
    dec cl
    jmp print_star2

done_star2:
    call newline
    inc jumspasi       ; Tambah spasi
    sub jumbintang,2   ; Kurangi bintang
    cmp jumbintang,0
    jg down_diamond
    ret

; Fungsi Untuk Mencetak Kotak Kosong
empty_box:
    mov ah,0
    mov ch,1           ; Baris counter

box_row:
    mov al,n
    cmp ch,al
    jg end_box

    mov cl,1           ; Kolom counter
box_col:
    cmp cl,1
    je print_star3     ; Tepi kiri
    mov al,n
    cmp cl,al
    je print_star3     ; Tepi kanan

    mov al,ch
    cmp al,1
    je print_star3     ; Tepi atas
    mov al,n
    cmp ch,al
    je print_star3     ; Tepi bawah

    mov dl,' '         ; Bagian dalam kosong
    call write
    jmp next_col

print_star3:
    mov dl,'*'
    call write

next_col:
    inc cl
    mov al,n
    cmp cl,al
    jle box_col

    call newline
    inc ch
    jmp box_row

end_box:
    ret

proses:
    call read          ; Baca input pengguna
    mov n,al

    call newline
    call diamond       ; Cetak pola berlian

    call newline
    call empty_box     ; Cetak kotak kosong

    selesai:
    ret

end start
