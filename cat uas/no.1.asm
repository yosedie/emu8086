.model small
.stack 100h
.data                                                 
    ; maksimum inputan yang bisa dimasukkan adalah 9
    prompt db 'Masukkan tinggi pola (maksimum 9): $'
    error_msg db 'Input tidak valid! Masukkan angka antara 1-11.$', 13, 10, '$'
    newline db 13, 10, '$'
    star db '*$'
    num db 0       ; variabel untuk menyimpan input pengguna

.code
main proc
    ; Inisialisasi segment
    mov ax, @data
    mov ds, ax

input_loop:
    ; Tampilkan prompt
    lea dx, prompt
    mov ah, 09h
    int 21h

    ; Baca input
    mov ah, 01h
    int 21h
    sub al, '0'     ; konversi karakter ke angka
    cmp al, 1
    jl invalid_input
    cmp al, 11
    jg invalid_input
    mov num, al     ; simpan angka ke variabel num

    ; Tunggu tombol enter
    mov ah, 01h
    int 21h
    cmp al, 13       ; cek apakah tombol yang ditekan adalah Enter (ASCII 13)
    jne invalid_input

    jmp valid_input

invalid_input:
    lea dx, error_msg
    mov ah, 09h
    int 21h
    jmp input_loop

valid_input:
    ; Pindah ke baris baru setelah input angka
    lea dx, newline
    mov ah, 09h
    int 21h

    ; Pola naik
    mov cl, 1        ; CL = jumlah bintang awal
upward_loop:
    cmp cl, num       ; apakah CL > num?
    jg downward       ; jika ya, masuk ke pola turun

    ; Cetak bintang sebanyak CL
    mov ch, cl         ; CH = jumlah bintang
print_star_up:
    cmp ch, 0
    je newline_up      ; jika CH = 0, pindah ke baris baru
    lea dx, star
    mov ah, 09h
    int 21h
    dec ch
    jmp print_star_up

newline_up:
    lea dx, newline
    mov ah, 09h
    int 21h
    inc cl
    jmp upward_loop

; Pola turun
downward:
    dec num             ; Mulai dari num - 1
downward_loop:
    cmp num, 0
    je finish          ; jika num = 0, selesai

    ; Cetak bintang sebanyak num
    mov ch, num         ; CH = jumlah bintang
print_star_down:
    cmp ch, 0
    je newline_down    ; jika CH = 0, pindah ke baris baru
    lea dx, star
    mov ah, 09h
    int 21h
    dec ch
    jmp print_star_down

newline_down:
    lea dx, newline
    mov ah, 09h
    int 21h
    dec num
    jmp downward_loop

finish:
    mov ah, 4Ch        ; keluar dari program
    int 21h

main endp
end main
