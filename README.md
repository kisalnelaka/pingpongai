# Assembly Ping Pong Game with AI Paddle

This project is a simple Ping Pong game written in x86 assembly. The game includes:
- **Player Paddle**: Controlled by the player using keyboard inputs.
- **AI Paddle**: Controlled by an AI module in assembly, which tracks the ball's position to keep the paddle aligned with the ball.

## Project Structure

- `pingpong.asm`: The main assembly file that handles the game loop, player input, drawing elements, and calling the AI module.
- `ai_module.asm`: The AI module written in assembly, which updates the AI paddle position based on the ball’s current Y-coordinate.

## Prerequisites

- **DOSBox**: An x86 emulator to run the assembly program.
- **NASM** (Netwide Assembler): An assembler for x86 code, used to compile the `.asm` files.

## Installation and Setup

### Step 1: Install DOSBox

Download and install DOSBox from the [official DOSBox website](https://www.dosbox.com/download.php?main=1). DOSBox allows us to run 16-bit and 32-bit programs, which is perfect for running x86 assembly programs.

### Step 2: Install NASM

Download and install NASM from the [official NASM website](https://nasm.us/). NASM is required to compile the assembly code into an executable format compatible with DOSBox.

## Building the Project

### 1. Assemble the Main Program and AI Module

In the project directory, open a terminal or command prompt and run the following commands to assemble the main game and AI module:

```bash
nasm -f elf pingpong.asm -o pingpong.o
nasm -f elf ai_module.asm -o ai_module.o

### 2. Link the Modules

After assembling, link both object files to create a single executable:

bash

ld -m elf_i386 -o pingpong pingpong.o ai_module.o

This will generate the executable file pingpong, which contains both the game logic and AI.
Running the Game
Step 1: Set Up DOSBox

    Open DOSBox.
    Mount the directory where the pingpong executable is located. Replace C:\path\to\your\project with the actual path:

    bash

mount c C:\path\to\your\project

Change to the mounted drive:

bash

    c:

Step 2: Run the Game

In DOSBox, run the game with:

bash

pingpong.com

The game should start with:

    The player controlling the left paddle (using the up and down arrow keys).
    The AI controlling the right paddle, which tracks the ball’s vertical position.

Game Controls

    Up Arrow: Move player paddle up.
    Down Arrow: Move player paddle down.
    The AI paddle will automatically follow the ball.

Code Overview
Main Game Code (pingpong.asm)

The main program handles:

    Initializing game state (ball and paddle positions).
    The game loop, which updates the game screen and processes player input.
    Drawing game elements (ball, player paddle, and AI paddle).
    Calling the update_ai_paddle function from ai_module.asm to adjust the AI paddle position.

AI Module Code (ai_module.asm)

The AI module contains the logic for tracking the ball’s position. This file exports a single function, update_ai_paddle, which moves the AI paddle up or down based on the ball's Y-coordinate.
Sample Code Snippets
Main Program (pingpong.asm)

This file sets up the game state, handles player input, and updates the game screen. Here’s a simplified version of the core loop:

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
    ; Initialize game state and enter game loop

AI Module (ai_module.asm)

This file contains the update_ai_paddle function, which adjusts the AI paddle based on the ball’s Y-position. Here’s an example of the function:

asm

section .data
    paddle_right_y extern
    ball_y extern

section .text
    global update_ai_paddle

update_ai_paddle:
    ; Move AI paddle to track ball's Y-coordinate

Troubleshooting

    NASM Not Found: Ensure NASM is correctly installed and added to your system PATH.
    DOSBox File Access Issues: Make sure the directory is mounted correctly in DOSBox.
    Linking Errors: Double-check assembly and linking commands for compatibility with your system.

License

This project is licensed under the MIT License. Feel free to modify and use the code for educational purposes.