; Program Assembly untuk menerima input data: NRP, Nama, dan Nomor Telepon

.DATA
    prompt_nrp      DB 'Masukkan NRP (maks 9 digit): $'
    prompt_nama     DB 'Masukkan Nama (maks 20 karakter): $'
    prompt_telepon  DB 'Masukkan No. Telepon (maks 12 digit): $'

    nrp_buffer      DB 10 DUP('$')  ; buffer untuk NRP (maks 9 digit + null terminator)
    nama_buffer     DB 21 DUP('$')  ; buffer untuk Nama (maks 20 karakter + null terminator)
    telepon_buffer  DB 13 DUP('$')  ; buffer untuk No. Telepon (maks 12 digit + null terminator)

    output_nrp      DB 'NRP: $'
    output_nama     DB 'Nama: $'
    output_telepon  DB 'No. Telepon: $'

    prompt_confirm  DB 0Dh, 0Ah, 'Apakah data benar? (y/n): $'
    invalid_input   DB 0Dh, 0Ah, 'Input tidak valid, silakan coba lagi.$'

    newline         DB 0Dh, 0Ah, '$'
    separator       DB 0Dh, 0Ah, '---------------------', 0Dh, 0Ah, '$'
    reinput_notice  DB 0Dh, 0Ah, 'Silakan inputkan data.', 0Dh, 0Ah, '=====================', 0Dh, 0Ah, '$'

    confirm_buffer  DB 2 DUP('$')  ; buffer untuk konfirmasi (1 karakter + null terminator)

.CODE
START:
    ; Inisialisasi segment data
    MOV AX, @DATA
    MOV DS, AX

REINPUT:
    ; Tampilkan pemberitahuan input ulang
    LEA DX, reinput_notice
    MOV AH, 09H
    INT 21H

    ; Input NRP
    LEA DX, prompt_nrp
    MOV AH, 09H      ; Print string
    INT 21H

    LEA DX, nrp_buffer
    MOV AH, 0AH      ; Input string
    INT 21H

    ; Tambahkan separator setelah input
    LEA DX, separator
    MOV AH, 09H
    INT 21H

    ; Input Nama
    LEA DX, prompt_nama
    MOV AH, 09H
    INT 21H

    LEA DX, nama_buffer
    MOV AH, 0AH
    INT 21H

    ; Tambahkan separator setelah input
    LEA DX, separator
    MOV AH, 09H
    INT 21H

    ; Input No. Telepon
    LEA DX, prompt_telepon
    MOV AH, 09H
    INT 21H

    LEA DX, telepon_buffer
    MOV AH, 0AH
    INT 21H

    ; Tambahkan separator setelah input
    LEA DX, separator
    MOV AH, 09H
    INT 21H

CONFIRM:
    ; Tampilkan prompt konfirmasi
    LEA DX, prompt_confirm
    MOV AH, 09H
    INT 21H

    ; Ambil input konfirmasi
    LEA DX, confirm_buffer
    MOV AH, 0AH
    INT 21H       
    
    LEA DX, separator
    MOV AH, 09H
    INT 21H

    ; Cek input apakah 'y' atau 'n'
    MOV AL, confirm_buffer+2  ; Ambil karakter pertama dari buffer
    CMP AL, 'y'               ; Jika 'y', lanjutkan
    JE DISPLAY_DATA
    CMP AL, 'n'               ; Jika 'n', ulangi input
    JE REINPUT      
    
    ; Jika input tidak valid, ulangi konfirmasi
    LEA DX, invalid_input
    MOV AH, 09H
    INT 21H
    JMP CONFIRM

DISPLAY_DATA:
    ; Tampilkan Data
    ; Tampilkan NRP
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    LEA DX, output_nrp
    MOV AH, 09H
    INT 21H

    LEA DX, nrp_buffer+2 ; Skip length byte
    MOV AH, 09H
    INT 21H

    ; Tampilkan Nama
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    LEA DX, output_nama
    MOV AH, 09H
    INT 21H

    LEA DX, nama_buffer+2
    MOV AH, 09H
    INT 21H

    ; Tampilkan No. Telepon
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    LEA DX, output_telepon
    MOV AH, 09H
    INT 21H

    LEA DX, telepon_buffer+2
    MOV AH, 09H
    INT 21H

    ; Program selesai
    MOV AH, 4CH      ; Exit program
    INT 21H

END START
