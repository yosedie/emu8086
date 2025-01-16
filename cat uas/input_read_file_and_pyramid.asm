jmp start

menu:   db 'Choose an option:', 0dh, 0ah
        db '1. Create Text File', 0dh, 0ah
        db '2. Read Text File', 0dh, 0ah
        db '3. Create Pyramid', 0dh, 0ah
        db '4. Exit', 0dh, 0ah, '$'
choice: db 'Enter your choice (1-4): $'
invalid_choice db 'Invalid choice. Try again.', 0dh, 0ah, '$'
    
    n            db      0  
    jumbintang   db      0
    jumspasi     db      0
    baris        db      0
    kolom        db      0    
infile       db 'TEXTFILE.txt',0
inbuf        db 512 dup(0)
text_line    db 128 dup(0)
text_count   dw 0
linenum      dw 0
bufend       dw offset inbuf-1
infilehandle dw ?
eof_flag     dw 0 
colon        db ':  $'
syntax_msg   db 'Read text file',0
DOSerrmsg    db 'File error.',0
newfile      db 'TEXTFILE.txt',0
filehandle   dw ?
buflen       dw 0
greeting     db 'Program to create a text file.', 0dh, 0ah, '$'
diskfullmsg  db 'Disk full. Closing the file.', 0dh, 0ah, '$'
crlf2        db 0dh, 0ah, '$'
maxkeys      db 80
chars_input  db ?
buffer db 80                    ; Maximum length of the input (80 bytes)
       db ?                     ; Actual number of characters read (set by DOS)
       db 80 dup(0)             ; Buffer space for input characters
videopage    db 0
pyramid_prompt db 'Enter the number of rows for the pyramid (1-9): $'
pyramid_exit db 'Exit? (yes/no): $'
yes_string db 'yes', 0
no_string db 'no', 0

start:
    call clrscr
    mov dx, offset menu
    call display

    mov dx, offset choice
    call display

    ; Wait for input string and process it
    mov ah, 1        ; Wait for user input
    int 21h
    sub al, '0'      ; Convert ASCII to numeric
    
    cmp al, 1
    je create_file_option
    cmp al, 2
    je read_file_option
    cmp al, 3
    je create_pyramid_option
    cmp al, 4
    je exit_program

    ; Invalid choice
    mov dx, offset invalid_choice
    call display
    jmp start

create_file_option:
    call display_heading
    mov dx, offset newfile
    call create_file
    jc akhir

create_loop:
    call get_text_line
    cmp buflen, 0             ; Check if user entered any text
    je finish_create
    call write_buffer
    jmp create_loop

finish_create:
    ; Add a final CRLF before closing the file
    mov w.buffer, 0a0dh
    mov buflen, 2
    call write_buffer
    ; Close the file
    mov bx, filehandle
    mov ah, 3eh
    int 21h
    jmp start


read_file_option:
    call open_input_file
    jc akhir

    ; Reset pointers and flags
    mov si, offset inbuf
    mov di, offset text_line
    mov eof_flag, 0

read_loop:
    call read_input_line
    cmp text_count, 0         ; Check if any text was read
    je check_eof              ; If no text, check EOF
    call display_the_buffer   ; Display the text read
    jmp read_loop             ; Continue reading

check_eof:
    cmp eof_flag, 1           ; Check if EOF was reached
    jne read_loop             ; If not, continue reading

    ; Close the file
    mov ah, 3eh
    mov bx, infilehandle
    int 21h
    jmp start

exit_program:
    mov ax, 4c00h
    int 21h

create_pyramid_option:
    call clrscr
    mov dx, offset pyramid_prompt    ; Prompt the user for pyramid height
    mov ah, 9
    int 21h                          ; Print the prompt

    call read                        ; Read user input
    mov n, al                        ; Store the pyramid height in `n`

    call turunbaris                  ; Move to the next line
    call kotakkosong                 ; Draw the pyramid

pyramid_exit_prompt:
    mov dx, offset pyramid_exit      ; Display "Exit? (yes/no)"
    mov ah, 9
    int 21h

    call read_string                 ; Read user input as a string
    mov si, offset buffer + 2       ; Point to the first character of input (after length byte)


    ; Check for "yes"
    mov si, offset buffer + 2        ; Point to the start of the input string
    mov di, offset yes_string        ; Point to the "yes" string
    mov cx, 3                        ; Length of "yes" (3 characters)
    repe cmpsb                       ; Compare strings
    je exit_to_menu                  ; If match, exit to the main menu

    ; Check for "no"
    mov si, offset buffer + 2        ; Reset SI to point to the start of input
    mov di, offset no_string         ; Point to the "no" string
    mov cx, 2                        ; Length of "no" (2 characters)
    repe cmpsb                       ; Compare strings
    je reset_pyramid                 ; If match, reset pyramid input

    ; Invalid input
    mov dx, offset invalid_choice    ; Display invalid input message
    mov ah, 9
    int 21h
    jmp pyramid_exit_prompt          ; Repeat the prompt

reset_pyramid:
    call clrscr
    jmp create_pyramid_option        ; Restart pyramid creation

exit_to_menu proc
    jmp start
exit_to_menu endp                              ; Return to the main menu
    
read_string:
    mov ah, 0Ah                  ; DOS function to read string
    mov dx, offset buffer        ; Buffer to store the input
    int 21h                      ; Call DOS interrupt
    ret

; Function to read a single-digit input (1-9)
read:
    mov ah, 1
    int 21h
    sub al, '0'
    cmp al, 1
    jb invalid_input
    cmp al, 9
    ja invalid_input
    ret
invalid_input:
    mov dx, offset invalid_choice
    call display
    jmp start

; Function to write a single character (in DL)
write:
    mov ah, 2                        ; Write character to screen
    int 21h                          ; Output in DL
    ret

; Function to move to a new line
turunbaris:
    mov ah, 2
    mov dl, 13                       ; Carriage return
    int 21h
    mov dl, 10                       ; Line feed
    int 21h
    ret

; Function to draw the pyramid
kotakkosong:
    mov al, n                        ; Get the pyramid height
    mov jumspasi,dl                       ; Copy to CL for loop limit
    sub jumspasi,1
    mov jumbintang,1
    mov baris,1                     ; Start with the first row
        p2:          
            mov dl,n        
            cmp baris,dl
            jg  akhirp2
                                        
            mov kolom,1          
            p3spasi:    
                mov dl,jumspasi
                cmp kolom,dl
                jg  akhirp3spasi
               
                mov dl,' '
                call write
                add kolom,1 
                jmp p3spasi
                
            akhirp3spasi:
                                                    
                                        
            mov kolom,1
            p3bintang:    
                cmp  kolom,1
                je   cetbintang
                mov  dl,kolom
                cmp  dl,jumbintang
                je   cetbintang
                mov  dl,baris
                cmp  dl,n
                je   cetbintang
                
                mov  dl,'*'
                call write
                jmp  lompat
                
                cetbintang:                 
                  mov dl,'*'
                  call write
                
                lompat:
                  add kolom,1 
                  mov dl,jumbintang
                  cmp kolom,dl
                  jg akhirp3bintang
                  jmp p3bintang
                
            akhirp3bintang:
                call turunbaris
                add baris,1 
                add jumbintang,2
                sub jumspasi,1
                jmp p2
        
        akhirp2:
     ret
   

; Display heading
display_heading proc
    call clrscr
    mov dx, offset greeting
    call display
    mov dx, offset crlf2
    call display
    ret
display_heading endp

; Create file
create_file proc
    mov ah, 3ch
    mov cx, 0
    int 21h
    jnc c1
    call DOS_error
c1:
    mov filehandle, ax
    ret
create_file endp

; Input text
get_text_line proc
    mov ah, 2
    mov dl, '>'
    int 21h
    mov ah, 0ah
    mov dx, offset maxkeys
    int 21h
    mov ah, 0
    mov al, chars_input
    mov buflen, ax
    mov dx, offset crlf2
    call display
    ret
get_text_line endp

; Write buffer to file
write_buffer proc
    cmp buflen, 2
    je L1
    mov di, offset buffer
    add di, buflen
    mov byte ptr (di+1), 0ah
    add buflen, 2
L1: clc
    mov ah, 40h
    mov bx, filehandle
    mov cx, buflen
    mov dx, offset buffer
    int 21h
    jnc e1
    call DOS_error
    jmp e2
e1:
    cmp ax, buflen
    je e2
    mov dx, offset diskfullmsg
    call display
    stc
e2:
    ret
write_buffer endp

; Open file
open_input_file proc
    call clrscr
    mov ah, 3dh
    mov al, 0
    mov dx, offset infile
    int 21h
    jnc d1
    call DOS_error
d1:
    mov infilehandle, ax
    ret
open_input_file endp

read_input_line proc
    cmp si, bufend
    ja refill_buffer          ; If end of buffer is reached, refill
    movsb
    inc text_count
    cmp byte ptr [si-1], 0ah  ; Check for newline
    je return_line
    jmp read_input_line

refill_buffer:
    mov ah, 3fh
    mov bx, infilehandle
    mov cx, 512               ; Read 512 bytes
    mov dx, offset inbuf
    int 21h
    jnc refill_success
    call DOS_error
    ret

refill_success:
    mov bufend, offset inbuf-1
    add bufend, ax
    mov si, offset inbuf
    cmp ax, 0                 ; Check if bytes were read
    jne read_input_line
    mov eof_flag, 1
    mov ah, 0Ah        ; Wait for user input
    int 21h           ; Set EOF flag if no bytes read

return_line:
    ret
read_input_line endp

; Display buffer
display_the_buffer proc
    mov dx, offset colon
    mov ah, 9
    int 21h
    mov ah, 40h
    mov bx, 1
    mov cx, text_count
    mov dx, offset text_line
    int 21h
    mov di, offset text_line
    mov text_count, 0
    ret
display_the_buffer endp

; Clear screen
clrscr proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    mov ax, 0600h
    mov cx, 0
    mov dx, 184fh
    mov bh, 7
    int 10h
    mov ah, 2
    mov bh, videopage
    mov dx, 0
    int 10h
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
clrscr endp

; Display text
display proc
    push ax
    mov ah, 9
    int 21h
    pop ax
    ret
display endp

; DOS error handler
DOS_error proc
    mov dx, offset DOSerrmsg
    call display
    ret
DOS_error endp

akhir:
    mov ax, 4c00h
    int 21h
