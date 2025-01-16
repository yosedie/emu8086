
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

jmp start

prompt_input1 db 'Masukkan string 1: $'    ; Pesan untuk meminta input string pertama
prompt_input2 db 'Masukkan string 2: $'    ; Pesan untuk meminta input string kedua
prompt_input_next db 'Masukkan string berikutnya: $' ; Pesan untuk meminta input string selanjutnya
prompt_continue db 'Ada lagi? (Y/N): $'   ; Pesan untuk menanyakan apakah ingin menambah string lagi
prompt_result db 'Gabungan string: $'     ; Pesan untuk menampilkan hasil string gabungan
invalid_input db 'Input tidak valid, coba lagi.', 0dh, 0ah, '$' ; Pesan jika input tidak valid
newline db 0dh, 0ah, '$'                  ; Karakter newline (CRLF)

buffer db 80 dup(0)                       ; Buffer untuk menyimpan input string dari pengguna
buffer_size db ?                          ; Panjang string yang dimasukkan pengguna
output db 512 dup(0)                      ; Buffer untuk menyimpan string gabungan
out_index dw 0                            ; Indeks akhir string dalam buffer output

start:
    call clrscr                           ; Bersihkan layar
    mov byte ptr output, 0                ; Inisialisasi output kosong
    mov out_index, 0                      ; Setel posisi awal indeks output

    ; Input string pertama
    mov dx, offset prompt_input1          ; Tampilkan pesan untuk input string pertama
    call display
    call read_string                      ; Tunggu input dari pengguna
    call append_to_output                 ; Tambahkan string ke buffer output

    ; Input string kedua
    mov dx, offset newline                ; Pindah ke baris baru
    call display
    mov dx, offset prompt_input2          ; Tampilkan pesan untuk input string kedua
    call display
    call read_string                      ; Tunggu input dari pengguna
    call append_to_output                 ; Tambahkan string ke buffer output

input_next:
    ; Tanya apakah mau input lagi
    mov dx, offset newline                ; Pindah ke baris baru
    call display
    mov dx, offset prompt_continue        ; Tampilkan pesan untuk input (Y/N)
    call display
    mov ah, 1                             ; Setel fungsi DOS untuk membaca 1 karakter input
    int 21h                               ; Panggil interrupt DOS untuk membaca input
    cmp al, 'Y'                           ; Periksa apakah input adalah 'Y'
    je get_next_string                    ; Jika ya, lanjut ke langkah berikutnya
    cmp al, 'y'                           ; Periksa apakah input adalah 'y'
    je get_next_string                    ; Jika ya, lanjut ke langkah berikutnya
    cmp al, 'N'                           ; Periksa apakah input adalah 'N'
    je show_result                        ; Jika ya, tampilkan hasil
    cmp al, 'n'                           ; Periksa apakah input adalah 'n'
    je show_result                        ; Jika ya, tampilkan hasil

    ; Jika input tidak valid
    mov dx, offset invalid_input          ; Tampilkan pesan input tidak valid
    call display
    jmp input_next                        ; Kembali ke langkah input (Y/N)

get_next_string:
    mov dx, offset newline                ; Pindah ke baris baru
    call display
    mov dx, offset prompt_input_next      ; Tampilkan pesan untuk input string berikutnya
    call display
    call read_string                      ; Tunggu input dari pengguna
    call append_to_output                 ; Tambahkan string ke buffer output
    jmp input_next                        ; Kembali ke langkah input (Y/N)

show_result:
    ; Tambahkan $ di akhir string gabungan
    lea di, output                        ; Pindahkan pointer ke buffer output
    add di, out_index                     ; Tambahkan offset akhir string
    mov byte ptr [di], '$'                ; Tambahkan terminator $ di akhir string

    ; Tampilkan hasil
    call clrscr                           ; Bersihkan layar
    mov dx, offset prompt_result          ; Tampilkan pesan hasil string gabungan
    call display
    mov dx, offset output                 ; Tampilkan string gabungan dari buffer output
    call display
    mov dx, offset newline                ; Tambahkan baris baru
    call display
    jmp end_program                       ; Akhiri program

; Membaca string dari input
read_string proc
    mov byte ptr buffer[0], 79            ; Atur panjang maksimum string yang dapat dimasukkan (79 karakter)
    mov ah, 0Ah                           ; Setel fungsi DOS untuk membaca string
    lea dx, buffer                        ; Pindahkan pointer ke buffer input
    int 21h                               ; Panggil interrupt DOS untuk membaca input
    mov al, buffer[1]                     ; Ambil panjang string yang dimasukkan pengguna
    mov buffer_size, al                   ; Simpan panjang string ke buffer_size
    ret
read_string endp

; Menambahkan string ke output
append_to_output proc
    push ax                               ; Simpan register AX
    push bx                               ; Simpan register BX
    push cx                               ; Simpan register CX
    push dx                               ; Simpan register DX

    lea si, buffer + 2                    ; Pindahkan pointer ke awal string input di buffer
    lea di, output                        ; Pindahkan pointer ke buffer output
    add di, out_index                     ; Pindah ke indeks akhir dalam buffer output
    mov al, buffer_size                   ; Ambil panjang string input
    mov cl, al                            ; Salin panjang string ke register CL

append_loop:
    cmp cl, 0                             ; Periksa apakah panjang string adalah 0
    je end_append                         ; Jika ya, keluar dari loop
append_loop_body:
    mov al, [si]                          ; Ambil karakter dari buffer input
    mov [di], al                          ; Salin karakter ke buffer output
    inc si                                ; Pindahkan pointer input ke karakter berikutnya
    inc di                                ; Pindahkan pointer output ke posisi berikutnya
    loop append_loop_body                 ; Kurangi CX, ulangi jika CX > 0

    ; Tambahkan spasi setelah string (jika ada string berikutnya)
    mov al, ' '                           ; Karakter spasi
    mov [di], al                          ; Tambahkan spasi ke buffer output
    inc di                                ; Geser pointer output

end_append:
    sub di, offset output                 ; Hitung panjang total output
    mov out_index, di                     ; Simpan panjang total ke out_index

    pop dx                                ; Pulihkan register DX
    pop cx                                ; Pulihkan register CX
    pop bx                                ; Pulihkan register BX
    pop ax                                ; Pulihkan register AX
    ret
append_to_output endp

; Menampilkan teks ke layar
display proc
    push ax                               ; Simpan register AX
    push dx                               ; Simpan register DX
    mov ah, 9                             ; Setel fungsi DOS untuk menampilkan string
    int 21h                               ; Panggil interrupt DOS untuk menampilkan string
    pop dx                                ; Pulihkan register DX
    pop ax                                ; Pulihkan register AX
    ret
display endp

; Membersihkan layar
clrscr proc
    push ax                               ; Simpan register AX
    push bx                               ; Simpan register BX
    push cx                               ; Simpan register CX
    push dx                               ; Simpan register DX
    mov ax, 0600h                         ; Setel fungsi BIOS untuk membersihkan layar
    mov cx, 0                             ; Posisi awal (baris 0, kolom 0)
    mov dx, 184fh                         ; Posisi akhir layar (baris 24, kolom 79)
    mov bh, 7                             ; Warna background putih, teks hitam
    int 10h                               ; Panggil interrupt BIOS untuk membersihkan layar
    mov ah, 2                             ; Setel fungsi untuk memindahkan kursor
    mov bh, 0                             ; Halaman layar aktif
    mov dx, 0                             ; Pindahkan kursor ke baris 0, kolom 0
    int 10h                               ; Panggil interrupt BIOS untuk memindahkan kursor
    pop dx                                ; Pulihkan register DX
    pop cx                                ; Pulihkan register CX
    pop bx                                ; Pulihkan register BX
    pop ax                                ; Pulihkan register AX
    ret
clrscr endp

end_program:
    mov ax, 4c00h                         ; Setel fungsi DOS untuk keluar dari program
    int 21h                               ; Panggil interrupt DOS untuk keluar
