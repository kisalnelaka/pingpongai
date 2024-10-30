section .data
    paddle_right_y extern
    ball_y extern

section .text
    global update_ai_paddle

update_ai_paddle:
    ; AI tracks the ball's Y position to move its paddle
    mov al, [ball_y]
    cmp al, [paddle_right_y]
    jle .move_ai_up
    inc byte [paddle_right_y]
    jmp .done_ai

.move_ai_up:
    dec byte [paddle_right_y]

.done_ai:
    ret
