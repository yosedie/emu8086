ORG 100h

LEA DX, msg       ; Load alamat pesan ke DX menggunakan LEA (Load Effective Address)
MOV AH, 09h       ; Function untuk mencetak string
INT 21h           ; Panggil interrupt DOS

MOV AH, 4Ch       ; Function untuk keluar program
INT 21h           ; Panggil interrupt DOS

msg DB 'Hello, World!$' ; Pesan yang akan ditampilkan, diakhiri dengan simbol $
