; Simplified Ping Pong Game in Assembly Language
; Assembled with NASM for DOS environment

section .data
    scr_width      db 80          ; Screen width
    scr_height     db 25          ; Screen height
    paddle_height   db 4          ; Paddle height
    paddle_left_x  db 3           ; Left paddle X pos
    paddle_right_x db 76          ; Right paddle X pos
    paddle_start_y db 10          ; Paddle starting Y pos

    ball_start_x   db 40          ; Ball starting X pos
    ball_start_y   db 12          ; Ball starting Y pos

section .bss
    paddle_left_y  resb 1         ; Left paddle Y pos
    paddle_right_y resb 1         ; Right paddle Y pos
    ball_x         resb 1         ; Ball X pos
    ball_y         resb 1         ; Ball Y pos

section .text
    global _start

_start:
    ; Init game state
    mov byte [paddle_left_y], paddle_start_y
    mov byte [paddle_right_y], paddle_start_y
    mov byte [ball_x], ball_start_x
    mov byte [ball_y], ball_start_y

game_loop:
    ; Clear screen
    call clear_screen

    ; Draw paddles and ball
    call draw_paddle_left
    call draw_paddle_right
    call draw_ball

    ; Simple delay
    call delay

    ; Repeat game loop
    jmp game_loop

clear_screen:
    ; Clear the screen
    mov ah, 06h           ; Scroll up function
    xor al, al            ; Clear entire screen
    xor cx, cx            ; Upper left corner
    mov dx, 184Fh         ; Lower right corner
    int 10h
    ret

draw_paddle_left:
    ; Draw the left paddle
    mov cx, [paddle_left_y]
    mov dl, [paddle_left_x]

    ; Set end of paddle based on its height
    mov al, [paddle_left_y]
    add al, paddle_height
    mov ah, al

.draw_left_loop:
    ; Set cursor and draw paddle
    mov ah, 02h           ; Set cursor position
    mov dh, cl            ; Y pos
    mov dl, [paddle_left_x] ; X pos
    int 10h
    mov ah, 09h           ; Write character
    mov al, '|'           ; Paddle char
    mov bh, 0             ; Page number
    mov bl, 07h           ; White color
    mov cx, 1             ; Repeat count
    int 10h
    inc cl
    cmp cl, ah            ; Compare with end of paddle
    jb .draw_left_loop
    ret

draw_paddle_right:
    ; Draw the right paddle
    mov cx, [paddle_right_y]
    mov dl, [paddle_right_x]

    ; Set end of paddle based on its height
    mov al, [paddle_right_y]
    add al, paddle_height
    mov ah, al

.draw_right_loop:
    ; Set cursor and draw paddle
    mov ah, 02h
    mov dh, cl
    mov dl, [paddle_right_x] ; X pos
    int 10h
    mov ah, 09h
    mov al, '|'
    mov bh, 0
    mov bl, 07h
    mov cx, 1
    int 10h
    inc cl
    cmp cl, ah            ; Compare with end of paddle
    jb .draw_right_loop
    ret

draw_ball:
    ; Draw the ball
    mov ah, 02h
    mov dh, [ball_y]
    mov dl, [ball_x]
    int 10h
    mov ah, 09h
    mov al, 'O'           ; Ball char
    mov bh, 0
    mov bl, 07h
    mov cx, 1
    int 10h
    ret

delay:
    ; Simple delay for frame rate
    mov cx, 0FFFFh
.delay_loop:
    dec cx
    jnz .delay_loop
    ret
