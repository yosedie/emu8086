; Nama: Ryan Yosedie Irawan
; NRP: 222117059

org 100h          ; Menentukan offset untuk .COM file

jmp start

; Variabel yang menyimpan alamat IP dan subnet mask
ipl db 192, 168, 0, 1          ; Alamat IP 1
ip2 db 192, 168, 2, 250        ; Alamat IP 2
subnet db 11111111b, 11111111b, 11111110b, 00000000b ; Subnet Mask

start:
    ; Inisialisasi
    mov si, 0          ; SI digunakan untuk indeks ke variabel
    mov cx, 4          ; Jumlah byte untuk IP dan subnet mask
    xor ax, ax         ; Kosongkan AX untuk operasi AND

compare:
    ; Lakukan operasi AND antara alamat IP dan subnet mask
    mov al, [ipl + si] ; Ambil byte dari IP 1
    and al, [subnet + si] ; Operasi AND dengan subnet
    mov bl, al         ; Simpan hasil IP 1 di BL

    mov al, [ip2 + si] ; Ambil byte dari IP 2
    and al, [subnet + si] ; Operasi AND dengan subnet
    cmp al, bl         ; Bandingkan hasil dengan IP 1
    jne not_same       ; Jika berbeda, lompat ke not_same

    inc si             ; Pindah ke byte berikutnya
    loop compare       ; Ulangi untuk semua byte

    ; Jika semua byte sama
    ; Mencetak "sama"
    mov ah, 09h        ; Fungsi untuk mencetak string
    lea dx, same_msg   ; Alamat pesan
    int 21h
    jmp end_program

not_same:
    ; Jika ada byte yang berbeda
    ; Mencetak "beda"
    mov ah, 09h        ; Fungsi untuk mencetak string
    lea dx, diff_msg   ; Alamat pesan
    int 21h

end_program:
    ; Keluar dari program
    mov ax, 4C00h      ; Fungsi untuk keluar
    int 21h

; Pesan untuk hasil
same_msg db 'sama$'
diff_msg db 'beda$'
