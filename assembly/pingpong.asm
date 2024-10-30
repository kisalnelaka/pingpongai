section .data
    screen_width db 80
    screen_height db 25
    paddle_height db 4
    paddle_left_x db 3
    paddle_right_x db 76
    paddle_start_y db 10

    ball_start_x db 40
    ball_start_y db 12
    ball_speed_x db 1
    ball_speed_y db 1

section .bss
    paddle_left_y resb 1
    paddle_right_y resb 1
    ball_x resb 1
    ball_y resb 1

extern update_ai_paddle

section .text
    global _start

_start:
    ; Initialize game state
    mov [paddle_left_y], paddle_start_y
    mov [paddle_right_y], paddle_start_y
    mov [ball_x], ball_start_x
    mov [ball_y], ball_start_y

game_loop:
    ; Draw game elements
    call clear_screen
    call draw_paddle_left
    call draw_paddle_right
    call draw_ball

    ; Player input for paddle movement (up/down arrow keys)
    call get_player_input

    ; AI paddle movement
    call update_ai_paddle  ; Invokes the external AI function

    ; Update ball position and check for collisions
    call update_ball_position

    ; Delay for frame rate control (simplified delay)
    call delay

    ; Loop back to continue game
    jmp game_loop

clear_screen:
    ; Clears the screen by filling it with spaces
    mov ah, 06h
    xor al, al
    xor cx, cx
    mov dx, 184Fh
    int 10h
    ret

draw_paddle_left:
    mov cx, [paddle_left_y]
    mov dx, paddle_left_x
.draw_left_loop:
    mov ah, 02h
    mov dh, cl
    mov dl, dx
    int 10h
    mov ah, 09h
    mov al, '|'
    mov bh, 0
    mov bl, 07h
    mov cx, 1
    int 10h
    inc cl
    cmp cl, [paddle_left_y] + paddle_height
    jb .draw_left_loop
    ret

draw_paddle_right:
    mov cx, [paddle_right_y]
    mov dx, paddle_right_x
.draw_right_loop:
    mov ah, 02h
    mov dh, cl
    mov dl, dx
    int 10h
    mov ah, 09h
    mov al, '|'
    mov bh, 0
    mov bl, 07h
    mov cx, 1
    int 10h
    inc cl
    cmp cl, [paddle_right_y] + paddle_height
    jb .draw_right_loop
    ret

draw_ball:
    mov ah, 02h
    mov dh, [ball_y]
    mov dl, [ball_x]
    int 10h
    mov ah, 09h
    mov al, 'O'
    mov bh, 0
    mov bl, 07h
    mov cx, 1
    int 10h
    ret

get_player_input:
    mov ah, 01h
    int 16h
    jz .no_input
    mov ah, 00h
    int 16h
    cmp al, 72
    jne .check_down
   
