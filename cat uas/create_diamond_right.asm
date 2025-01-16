org 100h

start:
    jmp proses

n            db      ?  ; Input angka
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
    mov jumbintang,1   ; bintang awal = 1

    mov ah,0
    mov ch,0           ; Baris counter

upper_diamond:
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
    add jumbintang,1   ; Tambah bintang
    inc ch
    mov al,n
    cmp ch,al
    jl upper_diamond

    ; Bagian bawah berlian (tanpa baris tengah)
    mov al,n
    mov jumbintang,al  ; Inisialisasi jumlah bintang untuk bawah
    dec jumbintang      ; Kurangi bintang awal untuk menghindari duplikasi tengah

down_diamond:
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
    dec jumbintang   ; Kurangi bintang
    cmp jumbintang,0
    jg down_diamond
    ret

proses:
    call read          ; Baca input pengguna
    mov n,al

    call newline
    call diamond       ; Cetak pola berlian

selesai:
    ret

end start
