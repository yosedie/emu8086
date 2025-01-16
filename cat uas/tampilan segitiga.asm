; Program cetak
; . . . . .
; 4 3 2 1
; 3 2 1
; 2 1
; 1


; fungsi input 1
mov ah,1
int 21h  
and al,0fh
mov cl,al
mov counter,al
call cetak_cr               

 
; cetak hasil
iterasi:
mov bil,cl
or bil,30h

mov ah,2
cetak: 
mov dl,bil
int 21h
mov dl,' '
int 21h
dec bil
loop cetak
call cetak_cr 
dec counter
mov cl,counter
inc cl
loop iterasi


; akhiri program
mov ax,04c00h
int 21h

 
bil db 0
counter db 0


cetak_cr:
mov ah,2
mov dl,0ah
int 21h
mov dl,0dh
int 21h
ret 