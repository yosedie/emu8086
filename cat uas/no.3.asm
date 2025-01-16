; Program Assembly untuk membuat file teks tetap (DATAMHS.DTA)

.DATA
    prompt_nrp      DB 'Masukkan NRP (maks 9 digit, isi 0 untuk keluar): $'
    prompt_nama     DB 'Masukkan Nama (maks 20 karakter): $'
    prompt_total    DB 'Masukkan Total (maks 6 digit): $'

    nrp_buffer      DB 10 DUP(' ')  ; buffer untuk NRP (9 digit + terminator)
    nama_buffer     DB 21 DUP(' ')  ; buffer untuk Nama (20 karakter + terminator)
    total_buffer    DB 7 DUP(' ')   ; buffer untuk Total (6 digit + terminator)

    newline         DB 0Dh, 0Ah, '$'
    separator       DB 0Dh, 0Ah, '---------------------', 0Dh, 0Ah, '$'
    file_name       DB 'DATAMHS.DTA', 0  ; nama file output

    file_handle     DW ?                ; handle file
    bytes_written   DW ?                ; jumlah byte yang ditulis

.CODE
START:
    ; Inisialisasi segment data
    MOV AX, @DATA
    MOV DS, AX

    ; Buat file baru
    LEA DX, file_name
    MOV AH, 3CH      ; Create file
    MOV CX, 0        ; File attribute: normal
    INT 21H

    JC ErrorHandling  ; Jika gagal, loncat ke ErrorHandling

    MOV file_handle, AX ; Simpan handle file

INPUT_LOOP:
    ; Input NRP
    LEA DX, prompt_nrp
    MOV AH, 09H      ; Print string
    INT 21H

    LEA DX, nrp_buffer
    MOV AH, 0AH      ; Input string
    INT 21H

    ; Cek apakah NRP adalah 0 untuk keluar
    LEA SI, nrp_buffer+2
    MOV CX, 1        ; Hanya periksa satu karakter pertama
    MOV AL, '0'
    REPE CMPSB       ; Bandingkan dengan '0'
    JZ EndProgram    ; Jika sama, keluar dari program

    ; Tambahkan separator setelah input
    LEA DX, separator
    MOV AH, 09H
    INT 21H

    ; Input Nama
    LEA DX, prompt_nama
    MOV AH, 09H      ; Print string
    INT 21H

    LEA DX, nama_buffer
    MOV AH, 0AH      ; Input string
    INT 21H

    ; Tambahkan separator setelah input
    LEA DX, separator
    MOV AH, 09H
    INT 21H

    ; Input Total
    LEA DX, prompt_total
    MOV AH, 09H      ; Print string
    INT 21H

    LEA DX, total_buffer
    MOV AH, 0AH      ; Input string
    INT 21H

    ; Tambahkan separator setelah input
    LEA DX, separator
    MOV AH, 09H
    INT 21H

    ; Format buffer untuk memenuhi panjang tetap
    CALL FormatBuffers

    ; Tulis data ke file
    LEA DX, nrp_buffer+2
    MOV CX, 9        ; Panjang NRP (9 digit)
    CALL WriteToFile

    LEA DX, nama_buffer+2
    MOV CX, 20       ; Panjang Nama (20 karakter)
    CALL WriteToFile

    LEA DX, total_buffer+2
    MOV CX, 6        ; Panjang Total (6 digit)
    CALL WriteToFile

    JMP INPUT_LOOP

WriteToFile PROC
    ; Tulis CX byte dari DX ke file
    MOV AH, 40H      ; Write to file
    MOV BX, file_handle
    INT 21H
    RET
WriteToFile ENDP

FormatBuffers PROC
    ; Pastikan buffer sesuai panjang tetap dengan padding spasi
    ; Format NRP
    MOV CX, 9        ; Panjang tetap NRP
    LEA SI, nrp_buffer+2
    CALL PadBuffer

    ; Format Nama
    MOV CX, 20       ; Panjang tetap Nama
    LEA SI, nama_buffer+2
    CALL PadBuffer

    ; Format Total
    MOV CX, 6        ; Panjang tetap Total
    LEA SI, total_buffer+2
    CALL PadBuffer

    RET
FormatBuffers ENDP

PadBuffer PROC
    ; Isi buffer hingga CX panjang dengan spasi jika kurang
    PUSH CX
PadLoop:
    LODSB            ; Ambil karakter
    CMP AL, 0        ; Apakah null terminator?
    JE PadFill       ; Jika ya, mulai isi spasi
    LOOP PadLoop     ; Lanjutkan loop

PadFill:
    MOV AL, ' '      ; Isi dengan spasi
    STOSB
    LOOP PadFill     ; Ulangi hingga CX selesai

    POP CX
    RET
PadBuffer ENDP

ErrorHandling:
    ; Tampilkan pesan error (opsional)
    MOV AH, 4CH      ; Exit program
    INT 21H

EndProgram:
    ; Tutup file
    MOV AX, 3E00H    ; Close file
    MOV BX, file_handle
    INT 21H

    ; Program selesai
    MOV AH, 4CH
    INT 21H

END START
