; Program Assembly untuk membaca dan menampilkan data dari file TOKO.DTA

.DATA
    file_name       DB 'TOKO.DTA', 0 ; Nama file
    buffer          DB 35 DUP(' ')  ; Buffer untuk membaca 1 baris data (35 karakter)
    kodetk_label    DB 'KodeTK: ', 0
    nama_label      DB 'Nama   : ', 0
    plafon_label    DB 'Plafon : ', 0
    newline         DB 0Dh, 0Ah, '$'

    file_handle     DW ?            ; Handle file
    bytes_read      DW ?            ; Jumlah byte yang dibaca

.CODE
START:
    ; Inisialisasi segmen data
    MOV AX, @DATA
    MOV DS, AX

    ; Buka file TOKO.DTA
    LEA DX, file_name
    MOV AH, 3DH      ; Fungsi membuka file
    MOV AL, 0        ; Mode baca saja
    INT 21H

    JC Error         ; Jika gagal membuka file

    MOV file_handle, AX ; Simpan handle file

READ_LOOP:
    ; Baca 35 byte dari file
    MOV AH, 3FH      ; Fungsi membaca file
    MOV BX, file_handle
    LEA DX, buffer
    MOV CX, 35       ; Panjang data per baris
    INT 21H

    JC EndRead       ; Jika gagal atau EOF
    CMP AX, 0        ; Cek apakah EOF (tidak ada data dibaca)
    JE EndRead

    ; Tampilkan Kodetk
    LEA DX, kodetk_label
    MOV AH, 09H      ; Fungsi mencetak string
    INT 21H

    LEA DX, buffer   ; Ambil 9 karakter pertama (Kodetk)
    MOV AH, 09H
    INT 21H

    LEA DX, newline
    MOV AH, 09H
    INT 21H

    ; Tampilkan Nama
    LEA DX, nama_label
    MOV AH, 09H
    INT 21H

    LEA DX, buffer+9 ; Ambil 20 karakter berikutnya (Nama)
    MOV AH, 09H
    INT 21H

    LEA DX, newline
    MOV AH, 09H
    INT 21H

    ; Tampilkan Plafon
    LEA DX, plafon_label
    MOV AH, 09H
    INT 21H

    LEA DX, buffer+29 ; Ambil 6 karakter terakhir (Plafon)
    MOV AH, 09H
    INT 21H

    LEA DX, newline
    MOV AH, 09H
    INT 21H

    ; Ulangi membaca data berikutnya
    JMP READ_LOOP

EndRead:
    ; Tutup file
    MOV AH, 3EH      ; Fungsi menutup file
    MOV BX, file_handle
    INT 21H

    JMP Exit

Error:
    ; Tampilkan pesan error (opsional)
    MOV AH, 09H
    LEA DX, newline
    INT 21H

Exit:
    ; Selesai
    MOV AH, 4CH
    INT 21H

END START
