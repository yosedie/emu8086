section .data
    prompt1 db 'Masukkan string 1: ', 0      ; prompt untuk string pertama
    prompt2 db 'Masukkan string 2: ', 0      ; prompt untuk string kedua
    promptAgain db 'Ada lagi? (y/n): ', 0    ; prompt untuk tanya lagi
    yes db 'y', 0                            ; karakter 'y' untuk ya
    no db 'n', 0                             ; karakter 'n' untuk tidak

section .bss
    string1 resb 100       ; buffer untuk string 1
    string2 resb 100       ; buffer untuk string 2
    result resb 200        ; buffer untuk hasil penggabungan string

section .text
    global _start

_start:
    ; Loop untuk meminta input string dan menampilkan hasil
ask_input:
    ; Tampilkan prompt untuk string 1
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor STDOUT
    mov ecx, prompt1        ; alamat string prompt1
    mov edx, 19             ; panjang prompt1
    int 0x80

    ; Ambil input string 1
    mov eax, 3              ; sys_read
    mov ebx, 0              ; file descriptor STDIN
    mov ecx, string1        ; buffer untuk string 1
    mov edx, 100            ; ukuran buffer
    int 0x80

    ; Tampilkan prompt untuk string 2
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor STDOUT
    mov ecx, prompt2        ; alamat string prompt2
    mov edx, 19             ; panjang prompt2
    int 0x80

    ; Ambil input string 2
    mov eax, 3              ; sys_read
    mov ebx, 0              ; file descriptor STDIN
    mov ecx, string2        ; buffer untuk string 2
    mov edx, 100            ; ukuran buffer
    int 0x80

    ; Gabungkan string1 dan string2
    mov si, 0               ; index untuk string1
    mov di, 0               ; index untuk result

    ; Copy string1 ke result
copy_string1:
    mov al, [string1 + si]  ; ambil karakter dari string1
    cmp al, 0               ; cek apakah sudah sampai null terminator
    je copy_string2         ; jika iya, pindah ke copy_string2
    mov [result + di], al   ; simpan karakter ke result
    inc si                  ; increment index string1
    inc di                  ; increment index result
    jmp copy_string1        ; ulangi hingga selesai

copy_string2:
    mov si, 0               ; reset index untuk string2

    ; Copy string2 ke result setelah string1
copy_string2_loop:
    mov al, [string2 + si]  ; ambil karakter dari string2
    cmp al, 0               ; cek apakah sudah sampai null terminator
    je done_copy            ; jika iya, selesai
    mov [result + di], al   ; simpan karakter ke result
    inc si                  ; increment index string2
    inc di                  ; increment index result
    jmp copy_string2_loop   ; ulangi hingga selesai

done_copy:
    ; Tampilkan hasil gabungan string
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor STDOUT
    mov ecx, result         ; alamat hasil penggabungan
    mov edx, di             ; panjang hasil gabungan
    int 0x80

    ; Tampilkan prompt "Ada lagi? (y/n)"
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor STDOUT
    mov ecx, promptAgain    ; alamat string promptAgain
    mov edx, 18             ; panjang promptAgain
    int 0x80

    ; Ambil input 'y' atau 'n'
    mov eax, 3              ; sys_read
    mov ebx, 0              ; file descriptor STDIN
    mov ecx, result         ; buffer untuk input (akan menampung 'y' atau 'n')
    mov edx, 1              ; ukuran buffer (hanya 1 karakter)
    int 0x80

    ; Cek apakah input adalah 'y' atau 'n'
    cmp byte [result], 'y'  ; jika input 'y'
    je ask_input            ; jika iya, ulangi
    cmp byte [result], 'n'  ; jika input 'n'
    je _exit                ; jika tidak, keluar

_exit:
    ; Keluar dari program
    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; status 0
    int 0x80
