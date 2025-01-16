; Nama: Ryan Yosedie Irawan
; NRP: 222117059

org 100h          ; Menentukan offset untuk .COM file

start:
    ; Menampilkan kalimat "Nama Saya Ryan Yosedie Irawan, NRP:222117059"
    
    ; Mencetak setiap karakter dari string secara manual
    mov ah, 02h    ; Fungsi untuk menampilkan karakter

    ; Mencetak kalimat
    mov dl, 'N' 
    int 21h
    mov dl, 'a' 
    int 21h
    mov dl, 'm' 
    int 21h
    mov dl, 'a' 
    int 21h
    mov dl, ' '
    int 21h
    mov dl, 'S' 
    int 21h
    mov dl, 'a' 
    int 21h
    mov dl, 'y' 
    int 21h
    mov dl, 'a' 
    int 21h
    mov dl, ' '
    int 21h
    mov dl, 'R' 
    int 21h
    mov dl, 'y' 
    int 21h
    mov dl, 'a' 
    int 21h
    mov dl, 'n' 
    int 21h
    mov dl, ' '
    int 21h
    mov dl, 'Y' 
    int 21h
    mov dl, 'o' 
    int 21h
    mov dl, 's' 
    int 21h
    mov dl, 'e' 
    int 21h
    mov dl, 'd' 
    int 21h
    mov dl, 'i' 
    int 21h
    mov dl, 'e' 
    int 21h
    mov dl, ' '
    int 21h
    mov dl, 'I' 
    int 21h
    mov dl, 'r' 
    int 21h
    mov dl, 'a' 
    int 21h
    mov dl, 'w' 
    int 21h
    mov dl, 'a' 
    int 21h
    mov dl, 'n' 
    int 21h
    mov dl, ',' 
    int 21h
    mov dl, ' '
    int 21h
    mov dl, 'N' 
    int 21h
    mov dl, 'R' 
    int 21h
    mov dl, 'P' 
    int 21h
    mov dl, ':' 
    int 21h
    mov dl, '2' 
    int 21h
    mov dl, '2' 
    int 21h
    mov dl, '2' 
    int 21h
    mov dl, '1' 
    int 21h
    mov dl, '1' 
    int 21h
    mov dl, '0' 
    int 21h
    mov dl, '5' 
    int 21h
    mov dl, '9' 
    int 21h

    ; Exit program
    mov ax, 4C00h ; Fungsi untuk keluar
    int 21h
