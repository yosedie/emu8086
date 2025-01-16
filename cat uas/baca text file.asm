jmp start

infile       db 'TEXTFILE.txt',0
inbuf        db 512 dup(0)
text_line    db 128 dup(0)
text_count   dw 0
linenum      dw 0
bufend       dw offset inbuf-1
infilehandle dw ?
eof_flag     dw 0 
colon        db ':  $'
syntax_msg   db 'Baca file txt',0
DOSerrmsg    db 'File error.',0
table        db '0123456789ABCDEF',0
buffer       db 16 dup(' ')


start:
    call    open_input_file	    ; buka file
    jc      a2			        ; error ? ya
    mov     si,offset inbuf 	; tidak, lakukan proses baca file
    mov     di,offset text_line
a1:
    call    read_input_line	    ; baca teks file
    call    display_the_buffer	; tampilkan ke layar monitor
    cmp     eof_flag,1		    ; akhir file ?
    jne     a1			        ; tidak, baca record selanjutnya
    mov     ah,3eh		        ; ya, tutup file
    mov     bx,infilehandle
    int     21h
a2:
    jmp     akhir    


; baca teks file 
read_input_line proc
b1:
    cmp     si,bufend
    ja      b2			        ; ya, baca record selanjutnya
    movsb			            ; tidak, copy ke output buffer
    inc     text_count		    ; tambahkan 1 ke hitungan output
    cmp     byte ptr [si-1],0ah	; akhir baris ?
    je      b4			        ; ya
    jmp     b1			        ; tidak, copy karakter selanjutnya
b2:
    mov     ah,3fh		        ; read file
    mov     bx,infilehandle
    mov     cx,512		        ; baca 512 karakter
    mov     dx,offset inbuf	    ; menunjuk pada input buffer
    int     21h
    jnc     b3			        ; error ?
    call    DOS_error		    ; ya
    jmp     b4
b3:      
    mov     bufend,offset inbuf-1
    add     bufend,ax		    ; menunjuk pada karakter terakhir
    mov     si,offset inbuf	    ; reset menunjuk input
    cmp     ax,0		        ; eof ?
    jne     b1			        ; tidak
    mov     eof_flag,1		    ; ya, eof = 1
b4:
    ret
read_input_line endp    
  
 
; tampilkan isi buffer
display_the_buffer proc
    mov     dx, offset colon	; tampilkan ':'
    mov     ah,9
    int     21h
    mov     ah,40h		        ; tampilkan output buffer
    mov     bx,1		        ; console
    mov     cx,text_count	    ; banyak byte yg ditampilkan
    mov     dx,offset text_line	; lokasi buffer yang ditampilkan
    int     21h
    mov     di,offset text_line	; reset penunjuk output
    mov     text_count,0	    ; text_count = 0	
    ret
display_the_buffer endp 


; open file
open_input_file proc
    mov     ah,3dh		        ; open file
    mov     al,0		        ; mode input
    mov     dx,offset infile
    int     21h
    jnc     d1			        ; file error ?
    call    DOS_error		    ; ya, tampilkan DOS error
d1:
    mov     infilehandle,ax	    ; tidak, simpan filehandle
    ret
open_input_file endp


display proc
    push    ax
    mov     ah,9
    int     21h
    pop     ax
    ret
display endp   


DOS_error proc  
    mov     dx,offset DOSerrmsg
    call    display
    ret
DOS_error endp
       

akhir:
    mov     ax,4c00h
    int     21h 
end