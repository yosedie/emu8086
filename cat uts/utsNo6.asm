org 100h          ; Mulai dari offset 100h untuk .COM

; 1. Menampilkan "Saya membeli laptop seharga $17000"
mov ah, 09h      ; Fungsi untuk menampilkan string
lea dx, msg1     ; Alamat dari string
int 21h          ; Panggil interrupt 21h

; 2. Tampilkan 'iSTTS' pada baris 10 kolom 20 dengan background kuning dan tulisan hitam
mov ah, 0Eh      ; Fungsi untuk menampilkan karakter dengan atribut
mov bh, 0        ; Halaman 0
mov bl, 0Eh      ; Atribut: tulisan hitam (0) dan background kuning (E)
mov cx, 5        ; Panjang string 'iSTTS'
mov si, offset str2 ; Offset dari string 'iSTTS'

call PrintStringAt ; Memanggil prosedur untuk mencetak string di posisi tertentu

; 3. Menulis karakter dan atribut pada baris X, kolom Y
mov ah, 0Eh      ; Fungsi untuk menampilkan karakter dengan atribut
mov bh, 0        ; Halaman 0
mov bl, 0Eh      ; Atribut: tulisan hitam dan background kuning
mov dh, 5        ; Baris 5
mov dl, 10       ; Kolom 10
mov al, 'A'      ; Karakter yang akan ditampilkan
int 10h          ; Panggil BIOS untuk menampilkan karakter

; 4. Pilihan 1-4
call ShowMenu    ; Menampilkan pilihan menu
call GetChoice    ; Mendapatkan pilihan dari user

; 5. Input 1 karakter
call GetChar     ; Mengambil karakter

; 6. Meniru fungsi 0Ah
call BufferInput  ; Meniru cara kerja fungsi 0Ah

; 7. Input 2 digit numerik
call GetTwoDigits ; Mengambil 2 digit numerik dan menampilkan hasil penjumlahan

; End of program
mov ax, 4C00h    ; Mengakhiri program
int 21h

; Data
msg1 db 'Saya membeli laptop seharga $17000', 0
str2 db 'iSTTS', 0

; Prosedur untuk mencetak string pada posisi tertentu
PrintStringAt:
    mov ah, 0Ah       ; Fungsi untuk menampilkan string
    mov dh, 10        ; Baris
    mov dl, 20        ; Kolom
    int 10h           ; Panggil BIOS
    ret

; Prosedur untuk menampilkan menu
ShowMenu:
    mov ah, 09h
    lea dx, menu
    int 21h
    ret

menu db 'Pilih 1-4: $'

; Prosedur untuk mendapatkan pilihan
GetChoice:
    ; Input karakter
    mov ah, 01h      ; Fungsi untuk input karakter
    int 21h
    ; Validasi pilihan
    cmp al, '1'
    jb InvalidChoice
    cmp al, '4'
    ja InvalidChoice
    ; Lanjutkan jika valid
    jmp EndChoice
InvalidChoice:
    ; Tampilkan pesan salah pilih
    mov ah, 09h
    lea dx, invalid
    int 21h
EndChoice:
    ret

invalid db 'Anda salah pilih !!', 0

; Prosedur untuk mengambil karakter
GetChar:
    ; Input karakter
    mov ah, 01h
    int 21h
    ; Tampilkan karakter yang diinput
    mov ah, 0Eh
    int 10h
    ret

; Prosedur untuk meniru cara kerja fungsi 0Ah
BufferInput:
    ; Meniru fungsi 0Ah
    ret

; Prosedur untuk input dua digit dan menjumlahkannya
GetTwoDigits:
    ; Input digit pertama
    call GetChar
    sub al, '0'     ; Konversi ASCII ke numerik
    mov bl, al      ; Simpan digit pertama
    ; Input digit kedua
    call GetChar
    sub al, '0'     ; Konversi ASCII ke numerik
    add bl, al      ; Jumlahkan dengan digit pertama
    ; Tampilkan hasil
    ; Hasil ditampilkan menggunakan fungsi 02h (untuk menampilkan karakter)
    add bl, '0'     ; Konversi kembali ke ASCII
    mov ah, 02h
    mov dl, bl      ; Karakter hasil
    int 21h         ; Panggil interrupt
    ret
