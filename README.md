Step 1: Setting Up DOSBox
1.1 Download and Install DOSBox

    Download DOSBox from the official website: DOSBox Downloads
    Install DOSBox following the installation instructions for your operating system.

1.2 Create a Development Directory

    Create a folder on your system where you will store your assembly files. For example, create a folder named asm_games in your home directory or on your desktop.

Step 2: Writing the Assembly Code
2.1 Install an Assembler

You will need an assembler like NASM to convert assembly code into executable files. You can download NASM from the official site:

    Download NASM: NASM Downloads
    Install it on your system, and ensure it's added to your PATH if you're using Windows.

2.2 Write the Assembly Code

    Open a text editor (like Notepad or any code editor) and create a new file named pingpong.asm.
    Copy and paste the following assembly code into your file:

asm

section .data
    screen_width db 80                ; Width of the screen
    screen_height db 25               ; Height of the screen
    paddle_height db 4                ; Height of the paddles
    paddle_left_x db 3                ; X position of the left paddle
    paddle_right_x db 76               ; X position of the right paddle
    paddle_start_y db 10               ; Starting Y position of paddles

    ball_start_x db 40                 ; Starting X position of the ball
    ball_start_y db 12                 ; Starting Y position of the ball
    ball_speed_x db 1                   ; Ball speed in X direction
    ball_speed_y db 1                   ; Ball speed in Y direction

section .bss
    paddle_left_y resb 1                ; Current Y position of the left paddle
    paddle_right_y resb 1               ; Current Y position of the right paddle
    ball_x resb 1                       ; Current X position of the ball
    ball_y resb 1                       ; Current Y position of the ball

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
    call update_ai_paddle

    ; Update ball position and check for collisions
    call update_ball_position

    ; Delay for frame rate control (simplified delay)
    call delay

    ; Loop back to continue game
    jmp game_loop

clear_screen:
    ; Clears the screen by filling it with spaces
    mov ah, 06h         ; Scroll up function
    xor al, al          ; Clear entire screen
    xor cx, cx          ; Upper left corner
    mov dx, 184Fh       ; Lower right corner
    int 10h
    ret

draw_paddle_left:
    ; Draws the left paddle at the current position
    mov cx, [paddle_left_y]
    mov dx, paddle_left_x

.draw_left_loop:
    ; Place paddle character
    mov ah, 02h         ; Set cursor position
    mov dh, cl          ; Set row to CX
    mov dl, dx          ; Column to DX
    int 10h
    mov ah, 09h         ; Write character
    mov al, '|'         ; Paddle character
    mov bh, 0           ; Page number
    mov bl, 07h         ; White color
    mov cx, 1           ; Repeat count
    int 10h
    inc cl
    cmp cl, [paddle_left_y] + paddle_height
    jb .draw_left_loop
    ret

draw_paddle_right:
    ; Draws the right paddle at the current position
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
    ; Draws the ball at its current position
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
    ; Simple up/down movement for left paddle
    mov ah, 01h         ; Check for key press
    int 16h
    jz .no_input        ; No input if ZF is set

    mov ah, 00h         ; Get key
    int 16h
    cmp al, 72          ; Up arrow key scan code
    jne .check_down
    dec byte [paddle_left_y]
    jmp .no_input

.check_down:
    cmp al, 80          ; Down arrow key scan code
    jne .no_input
    inc byte [paddle_left_y]

.no_input:
    ret

update_ai_paddle:
    ; Simple AI to track the ball's Y position
    mov al, [ball_y]
    cmp al, [paddle_right_y]
    jle .move_ai_up
    inc byte [paddle_right_y]
    jmp .done_ai

.move_ai_up:
    dec byte [paddle_right_y]

.done_ai:
    ret

update_ball_position:
    ; Update ball X position
    mov al, [ball_x]
    add al, [ball_speed_x]
    mov [ball_x], al

    ; Update ball Y position
    mov al, [ball_y]
    add al, [ball_speed_y]
    mov [ball_y], al

    ; Check for collision with top and bottom screen edges
    mov al, [ball_y]
    cmp al, 0
    jge .check_bottom
    neg byte [ball_speed_y]   ; Bounce off top edge
    jmp .done_update

.check_bottom:
    cmp al, screen_height - 1
    jle .done_update
    neg byte [ball_speed_y]   ; Bounce off bottom edge

.done_update:
    ret

delay:
    ; A simple delay for controlling frame rate
    mov cx, 0FFFFh
.delay_loop:
    dec cx
    jnz .delay_loop
    ret

Step 3: Assembling the Code
3.1 Launch DOSBox

    Open DOSBox.

3.2 Mount Your Development Directory

    In the DOSBox command prompt, mount your directory. If your assembly code is in C:\asm_games, use:

    r

    mount c c:\asm_games

3.3 Change to the Mounted Drive

    Switch to the mounted drive:

    makefile

    c:

3.4 Assemble the Code with NASM

    First, you need to create a .com file from your assembly code. Use the following command in DOSBox:

    arduino

    nasm -f bin pingpong.asm -o pingpong.com

Step 4: Running the Game
4.1 Run the Game

    Now that you have assembled the code, you can run the game by typing:

    pingpong.com

4.2 Control the Game

    Use the up and down arrow keys to move the left paddle up and down. The AI paddle will automatically follow the ball.

Step 5: Debugging

If you encounter any issues:

    Ensure the file name is correctly spelled.
    Verify that NASM is correctly installed and available in the DOSBox environment.
    Check for any errors reported during the assembly step.

Step 6: Enhancements (Optional)

Once you have the basic game running, consider adding:

    Score tracking: Display the score on the screen.
    Ball speed increase: Increase ball speed as the game progresses.
    Game over conditions: Implement a scoring system that ends the game when a player scores.



To separate the AI into its own component and make it invokable from the main assembly program, you can follow a modular approach. This way, the AI logic for controlling the paddle will be in a separate code file that the main program can call. Here’s a breakdown of how to set this up:

    Create the main program: The main program will handle the game loop, draw the paddles and ball, and manage player input. It will call the AI module to control the AI paddle.

    Create the AI module: The AI module will only contain logic for moving the AI paddle based on the ball's position.

    Link the files: After creating and assembling both modules, you’ll link them together so the main program can call the AI function.

Here's a step-by-step guide to setting this up.
Step 1: Write the Main Assembly Program

Create a file named pingpong.asm for the main program. This file will set up the game and invoke the AI module to move the AI paddle.
pingpong.asm

asm

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
    dec byte [paddle_left_y]
    jmp .no_input

.check_down:
    cmp al, 80
    jne .no_input
    inc byte [paddle_left_y]

.no_input:
    ret

update_ball_position:
    mov al, [ball_x]
    add al, [ball_speed_x]
    mov [ball_x], al
    mov al, [ball_y]
    add al, [ball_speed_y]
    mov [ball_y], al
    mov al, [ball_y]
    cmp al, 0
    jge .check_bottom
    neg byte [ball_speed_y]
    jmp .done_update

.check_bottom:
    cmp al, screen_height - 1
    jle .done_update
    neg byte [ball_speed_y]

.done_update:
    ret

delay:
    mov cx, 0FFFFh
.delay_loop:
    dec cx
    jnz .delay_loop
    ret

Step 2: Write the AI Module

The AI module will contain the function update_ai_paddle that controls the AI paddle. This function will move the AI paddle up or down to track the ball’s Y position.
ai_module.asm

asm

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

Step 3: Assemble and Link the Modules

    Assemble the main program:

    bash

nasm -f elf pingpong.asm -o pingpong.o

Assemble the AI module:

bash

nasm -f elf ai_module.asm -o ai_module.o

Link the modules:

bash

    ld -m elf_i386 -o pingpong pingpong.o ai_module.o

Step 4: Run in DOSBox

    Open DOSBox and mount the directory where your files are located.

    bash

mount c c:\path\to\your\directory

Change to the mounted drive and run the program.

bash

    c:
    pingpong.com

This setup modularizes the AI function into a separate module that can be invoked by the main game loop, making the code structure clearer and easier to maintain.