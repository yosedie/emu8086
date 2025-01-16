jmp start 

buflen      dw 0
filehandle  dw ?
newfile     db 'TEXTFILE.txt',0

greeting    db 'Program untuk membuat teks file'
            db 0dh,0ah,0dh,0ah,'$'
         
diskfullmsg db 0dh,0ah,'Disk full.'
            db 'Closing the file.',0dh,0ah,'$'
        
DOSerrmsg   db 0dh,0ah,'DOS error occured: $'

crlf2       db 0dh,0ah,0dh,0ah,'$'                      
videopage   db 0

maxkeys     db 80
chars_input db ?
buffer      db 80 dup(0)
 
 
start:
main proc
    call display_heading	; tampilkan heading program
    mov dx,offset newfile	; buat/create file
    call create_file
    jc akhir			    ; create file error ?
    
a1:
    call get_text_line		; tidak, inputkan teks
    cmp buflen,0		    ; buffer kosong/tidak ada inputan ?
    je a2			        ; ya
    call write_buffer		; tidak, tulis buffer ke file
    jmp a1
a2:
    mov w.buffer,0a0dh		; akhir inputan teks
    mov buflen,02
    call write_buffer
    mov bx,filehandle
    mov ah,3eh			    ; close file
    int 21h
    jmp akhir  
main endp  
 

; tampilkan greeting 
display_heading proc
    call clrscr
    mov dx,offset greeting
    call display
    mov dx,offset crlf2
    call display
    ret
display_heading endp


; create file
create_file proc 
    mov ah,3ch		
    mov cx,0		        ; normal file
    int 21h
    jnc c1		
    call DOS_error	        ; jika cf = 1 error
c1:
    mov filehandle,ax	    ; simpan filehandle
    ret
create_file endp


; inputan teks 
get_text_line proc
    mov ah,2		        ; tampilkan '>' dilayar monitor
    mov dl,'>'
    int 21h
    mov ah,0ah 		        ; input buffer
    mov dx,offset maxkeys
    int 21h      
    mov ah,0
    mov al,chars_input	    ; panjang teks yg di inputkan
    mov buflen,ax	 
    mov dx,offset crlf2	    ; ganti baris
    call display
    ret
get_text_line endp


; tulis isi buffer ke file 
write_buffer proc 
    cmp buflen,2	        ; akhir teks ?
    je L1		            ; ya
    mov di,offset buffer    ; tidak
    add di,buflen
    mov byte ptr (di+1),0ah
    add buflen,2
L1: clc
    mov ah,40h		        ; write buffer ke file
    mov bx,filehandle 
    mov cx,buflen
    mov dx,offset buffer
    int 21h
    jnc e1		            ; tidak error
    call DOS_error	        ; DOS error
    jmp e2
e1:
    cmp ax,buflen	        ; ax <> buflen, maka storage penuh
    je e2		            ; ax = buflen, maka teks tersimpan di file
    mov dx,offset diskfullmsg
    call display
    stc
e2:
    ret
write_buffer endp        
    
 
; clear screen
clrscr proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    mov ax,0600h
    mov cx,0
    mov dx,184fh
    mov bh,7
    int 10h
    mov ah,2
    mov bh,videopage
    mov dx,0
    int 10h
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
clrscr endp
    

; tampilkan teks ke layar monitor
display proc
    push ax
    mov ah,9
    int 21h
    pop ax
    ret
display endp   


; tampilkan keterangan error dari DOS
DOS_error proc  
    mov dx,offset DOSerrmsg
    call display
    ret
DOS_error endp


akhir:
    mov ax,4c00h		
    int 21h
end  