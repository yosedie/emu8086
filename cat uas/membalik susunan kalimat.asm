; program membalik susunan kalimat
; contoh  
; input  : saya makan nasi
; hasil  : isan nakam ayas 


; input buffer
mov ah,0ah
mov dx,offset max_key
int 21h  
 
 
; cetak cr
mov ah,2
mov dl,0ah
int 21h
mov dl,0dh
int 21h
 
 
; cetak membalik kalimat
mov cx,0
mov cl,num_type
mov bx,offset buffer   
add bx,cx   
 
 
mov ah,2
cetak:
mov dl,(bx)
int 21h
dec bx
loop cetak 
mov dl,(bx)
int 21h


; akhiri program
mov ax,04c00h
int 21h


; data buffer fungsi 0ah
max_key db 04bh
num_type db ?
buffer db 75 dup (0)    