.model small
.stack 100h
.data

prompt_nrp      db 'Masukkan NRP (maks. 9 digit): $'
prompt_nama     db 'Masukkan Nama (maks. 20 karakter): $'
prompt_telepon  db 'Masukkan Telepon/hp (maks. 12 digit): $'
prompt_data     db 'Data benar? (Y/N): $'
msg_data_valid  db 'Data yang dimasukkan: $'
newline         db 0Ah, 0Dh, '$'
space           db ' ', '$'
clr_screen      db 27, '[2J', 0Ah, 0Dh, '$'

buffer_nrp      db 10,?, 20 dup('$')
buffer_nama     db 21,?, 40 dup('$')
buffer_telepon  db 13,?, 20 dup('$')
buffer_confirm  db 2,?, 2 dup('$')

.code
main:
    mov ax, @data
    mov ds, ax

input_data:
    ; Input NRP
    mov ah, 09h
    lea dx, prompt_nrp
    int 21h
    lea dx, buffer_nrp
    mov ah, 0Ah
    int 21h

    ; Tambah newline
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Input Nama
    mov ah, 09h
    lea dx, prompt_nama
    int 21h
    lea dx, buffer_nama
    mov ah, 0Ah
    int 21h

    ; Tambah newline
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Input Telepon
    mov ah, 09h
    lea dx, prompt_telepon
    int 21h
    lea dx, buffer_telepon
    mov ah, 0Ah
    int 21h

    ; Tambah newline
    mov ah, 09h
    lea dx, newline
    int 21h

confirm_data:
    ; Menampilkan konfirmasi Y/N
    mov ah, 09h
    lea dx, prompt_data
    int 21h

    ; Membaca input Y/N
    mov ah, 01h
    int 21h
    mov buffer_confirm + 1, al

    ; Periksa input Y/y untuk validasi
    cmp al, 'Y'
    je display_data
    cmp al, 'y'
    je display_data

    ; Jika input N/n, bersihkan layar dan ulangi input
    cmp al, 'N'
    je reset_data
    cmp al, 'n'
    je reset_data

    ; Jika input invalid, ulangi konfirmasi
    jmp confirm_data

reset_data:
    ; Clear screen
    mov ah, 09h
    lea dx, clr_screen
    int 21h
    jmp input_data

display_data:
    ; Display newline before output data
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display NRP
    lea si, buffer_nrp + 2           ; Point SI to the start of the NRP data
    mov cl, buffer_nrp[1]           ; Get the length of the NRP string
    add si, cx                      ; Calculate the end of the string
    mov byte ptr [si], '$'          ; Append '$' at the end
    lea dx, buffer_nrp + 2          ; Point DX to the NRP string
    mov ah, 09h                     ; Display string using DOS interrupt
    int 21h

    ; Add newline after all data
    lea dx, newline                 ; Point DX to the newline string
    mov ah, 09h
    int 21h

    ; Display Name
    lea si, buffer_nama + 2         ; Point SI to the start of the Name data
    mov cl, buffer_nama[1]          ; Get the length of the Name string
    add si, cx                      ; Calculate the end of the string
    mov byte ptr [si], '$'          ; Append '$' at the end
    lea dx, buffer_nama + 2         ; Point DX to the Name string
    mov ah, 09h                     ; Display string using DOS interrupt
    int 21h

    ; Add newline after all data
    lea dx, newline                 ; Point DX to the newline string
    mov ah, 09h
    int 21h

    ; Display Telephone
    lea si, buffer_telepon + 2      ; Point SI to the start of the Telephone data
    mov cl, buffer_telepon[1]       ; Get the length of the Telephone string
    add si, cx                      ; Calculate the end of the string
    mov byte ptr [si], '$'          ; Append '$' at the end
    lea dx, buffer_telepon + 2      ; Point DX to the Telephone string
    mov ah, 09h                     ; Display string using DOS interrupt
    int 21h

    ; Add newline after all data
    lea dx, newline                 ; Point DX to the newline string
    mov ah, 09h
    int 21h

    ; Exit program
    mov ah, 4Ch                     ; Terminate program
    int 21h

end main
