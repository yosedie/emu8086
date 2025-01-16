; Nama: Ryan Yosedie Irawan
; NRP: 222117059
org 100h
start:
    mov cx, 5
print_loop:
    push cx       
    mov bx, 1     
print_column:
    mov ax, bx    
    call print_number
    inc bx
    cmp bx, cx
    jbe print_column 
    mov ah, 02h   
    mov dl, 0Ah   
    int 21h
; Nama: Ryan Yosedie Irawan
; NRP: 222117059
    mov dl, 0Dh  
    int 21h
    pop cx        
    dec cx
    jnz print_loop  
    mov ax, 4C00h 
    int 21h
print_number:
    add ax, '0'    
    mov dl, al     
    mov ah, 02h    
    int 21h
    ret
; Nama: Ryan Yosedie Irawan
; NRP: 222117059

