TITLE RPN Calculator (G7P2.asm)

; CSC 323 - Group #7 - Assignment 2: RPN Calc
; Author: Robert Krency, kre1188@pennwest.edu
; Author: Tanner Kirsch, kir0510@pennwest.edu
; Author: Zachary Teixido, tei3216@pennwest.edu

; This program creates a Reverse Polish Notation Calculator
; driven by a stack. 

INCLUDE Irvine32.inc

.data

; Output Strings
msg_Details         BYTE        "Welcome to the RPN Calculator.", 0
err_StackFull       BYTE        "Stack is full and cannot be pushed onto", 0
err_StackEmpty      BYTE        "Not enough values in stack to perform operation", 0
err_WrongInput      BYTE        "Invalid Entry", 0



; Stack
stackBase           dword       8 DUP(0)        ; The stack
stackSize           dword       0               ; Number of elements in the stack
stackHead           dword       stackBase       ; Address of where the top of the stack is at
stackBuffer         dword       0               ; Buffer for push/pop operations


; Input Buffer
inputBuffer         BYTE        80 DUP(0)       ; User input buffer
inputByteCount      dword       ?               ; Number of bytes from User Input


; Operation Buffers
operandOne          dword       0               ; First operand for arithmetic operations
operandTwo          dword       0               ; Second operand for arithmetic operations


; ASCII Constants
ASCII_Space         EQU         0x20
ASCII_Tab           EQU         0x09


; Flags
flag_quit           dword       0
flag_ValidInput     dword       0

.code

; main - Entry Point
main PROC
    ; Print out welcome messages
    nop

; GetInput - Get input from the User
GetInput:
    nop


; SkipWhitespace - Skips whitespace at the start of the input buffer
SkipWhitespace:
    mov eax, 0                                  ; Current position in InputBuffer
    mov ebx, inputByteCount
    
    ; Check if we've reached the end of the buffer
    cmp eax, ebx
    JGE EndOfInputError

SkipSpace:
    cmp [inputBuffer+eax], ASCII_Space
    JNE SkipTab
    inc eax
    JMP SkipWhitespace
    
SkipTab:
    cmp [inputBuffer+eax], ASCII_Tab
    JNE 
    inc eax
    JMP SkipWhitespace


EndOfInputError:
    mov edx, err_WrongInput
    call WriteString
    call Crlf
    ret

; PushStack - Pushes an item onto the stack
PushStack:
    ; If the stack is full, fail
    mov eax, stackSize
    cmp eax, 8
    JGE StackFullError

    ; Otherwise, push onto the top of the stack
    add eax, stackHead, 4
    mov stackHead, eax
    inc stackSize
    mov [eax], stackBuffer

    ret


; StackFullError - Displays an error message when the stack is full and cannot be pushed onto
StackFullError:
    mov edx, OFFSET err_StackFull
    call WriteString
    call Crlf
    ret


; ClearStack - empties the stack and resets its values
ClearStack:
    ; Reset the head of the stack
    mov eax, OFFSET stackBase
    mov stackHead, eax

    ; Reset the size of the stack
    mov stackSize, 0

    ret


; Quit - Quits the program
Quit:
    ; Print quit message?
    nop

main ENDP
END main