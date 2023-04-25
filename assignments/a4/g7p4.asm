 TITLE Broadcast Network Simulator (G7P3.asm)

; Robert Krency		-		kre1188@pennwest.edu
; Tanner Kirsch		-		kir0510@pennwest.edu

; This program simulates a simple Broadcast Mode network.

; TODO:
; Implement Echo
; Fix MessageAlive int printing.
; Calculate Avg Hops

INCLUDE Irvine32.inc

.data

; Constants
ascii_Tab               equ         9
BaseSizeOfStructure     equ         14
ConnectionSize          equ         12


; Messages
msg_Welcome             byte        "Welcome to the Broadcast Network Simulator.", 0
msg_PacketDied          byte        "Packet has outlived its life.", 0
msg_PacketDest          byte        "Packet has reached its destination.", 0
msg_Quit                byte        "Quitting...", 0

; Message to Transmit Message to Connection
msg_XmtConn             byte        9,9,9,"Sending message to: x", 0
XmtConn_Name            equ         23

; Message to Receive Message to Connection
msg_RcvConn             byte        9,9,9,"Receiving message from: x", 0
RcvConn_Name            equ         27

; Message for Transmit Queue Processing
msg_TransmitQueue       byte        9, "Processing transmit queue for: x", 0
XmtMsg_Name             equ         32

; Message for Receive Buffer Processing
msg_ReceiveBuffer       byte        9, "Processing receive buffer for: x", 0
RcvMsg_Name             equ         32

; Message Packet
MessagePointer    label byte
Dest_Node               byte        0
Sender_Node             byte        0
Origin_Node             byte        0
TTL_Counter             byte        0
Time_Received           dword       0

PacketSize              equ         8
Destination             equ         0       ; Target Offset
Sender                  equ         1       ; Last Sender Offset
Origin                  equ         2       ; Source Offset
TTL                     equ         3       ; TTL Offset
Received                equ         4       ; Receive Time Offset


; Transmit Queues
QueueSize               equ         10
QueueA                  byte        QueueSize*PacketSize dup(0)
QueueB                  byte        QueueSize*PacketSize dup(0)
QueueC                  byte        QueueSize*PacketSize dup(0)
QueueD                  byte        QueueSize*PacketSize dup(0)
QueueE                  byte        QueueSize*PacketSize dup(0)
QueueF                  byte        QueueSize*PacketSize dup(0)


; Transmit Buffers

A_XMT_B label byte
B_RCV_A byte PacketSize dup(0)
B_XMT_A label byte
A_RCV_B byte PacketSize dup(0)

A_XMT_E label byte
E_RCV_A byte PacketSize dup(0)
E_XMT_A label byte
A_RCV_E byte PacketSize dup(0)

B_XMT_C label byte
C_RCV_B byte PacketSize dup(0)
C_XMT_B label byte
B_RCV_C byte PacketSize dup(0)

C_XMT_D label byte
D_RCV_C byte PacketSize dup(0)
D_XMT_C label byte
C_RCV_D byte PacketSize dup(0)

D_XMT_F label byte
F_RCV_D byte PacketSize dup(0)
F_XMT_D label byte
D_RCV_F byte PacketSize dup(0)

F_XMT_E label byte
E_RCV_F byte PacketSize dup(0)
E_XMT_F label byte
F_RCV_E byte PacketSize dup(0)

B_XMT_F label byte
F_RCV_B byte PacketSize dup(0)
F_XMT_B label byte
B_RCV_F byte PacketSize dup(0)

C_XMT_E label byte
E_RCV_C byte PacketSize dup(0)
E_XMT_C label byte
C_RCV_E byte PacketSize dup(0)

byte 10 dup(0)


; Node Structure Offsets
Node_Name           equ     0
Node_Connections    equ     1
Node_Queue_Base     equ     2
Node_Queue_Input    equ     6
Node_Queue_Output   equ     10

; Network

Network label byte

NodeA       byte    'A'             ; Name
            byte    2               ; Number of Connection
            dword   QueueA          ; Base address of Queue
            dword   QueueA          ; Input Pointer of Queue
            dword   QueueA          ; Output Pointer of Queue

            dword   NodeB           ; Pointer to Node B
            dword   A_XMT_B         ; Transmit Buffer to Node B
            dword   A_RCV_B         ; Receive Buffer from Node B

            dword   NodeE           ; Pointer to Node E
            dword   A_XMT_E         ; Transmit Buffer to Node E
            dword   A_RCV_E         ; Receive Buffer from Node E

NodeB       byte    'B'             ; Name
            byte    3               ; Number of Connection
            dword   QueueB          ; Base address of Queue
            dword   QueueB          ; Input Pointer of Queue
            dword   QueueB          ; Output Pointer of Queue

            dword   NodeB           ; Pointer to Node A
            dword   B_XMT_A         ; Transmit Buffer to Node A
            dword   B_RCV_A         ; Receive Buffer from Node A

            dword   NodeC           ; Pointer to Node B
            dword   B_XMT_C         ; Transmit Buffer to Node C
            dword   B_RCV_C         ; Receive Buffer from Node C

            dword   NodeF           ; Pointer to Node F
            dword   B_XMT_F         ; Transmit Buffer to Node F
            dword   B_RCV_F         ; Receive Buffer from Node F

NodeC       byte    'C'             ; Name
            byte    3               ; Number of Connection
            dword   QueueC          ; Base address of Queue
            dword   QueueC          ; Input Pointer of Queue
            dword   QueueC          ; Output Pointer of Queue

            dword   NodeB           ; Pointer to Node B
            dword   C_XMT_B         ; Transmit Buffer to Node B
            dword   C_RCV_B         ; Receive Buffer from Node B

            dword   NodeD           ; Pointer to Node D
            dword   C_XMT_D         ; Transmit Buffer to Node D
            dword   C_RCV_D         ; Receive Buffer from Node D

            dword   NodeE           ; Pointer to Node E
            dword   C_XMT_E         ; Transmit Buffer to Node E
            dword   C_RCV_E         ; Receive Buffer from Node E

NodeD       byte    'D'             ; Name
            byte    2               ; Number of Connection
            dword   QueueD          ; Base address of Queue
            dword   QueueD          ; Input Pointer of Queue
            dword   QueueD          ; Output Pointer of Queue

            dword   NodeC           ; Pointer to Node C
            dword   D_XMT_C         ; Transmit Buffer to Node C
            dword   D_RCV_C         ; Receive Buffer from Node C

            dword   NodeF           ; Pointer to Node F
            dword   D_XMT_F         ; Transmit Buffer to Node F
            dword   D_RCV_F         ; Receive Buffer from Node F

NodeE       byte    'E'             ; Name
            byte    3               ; Number of Connection
            dword   QueueE          ; Base address of Queue
            dword   QueueE          ; Input Pointer of Queue
            dword   QueueE          ; Output Pointer of Queue

            dword   NodeA           ; Pointer to Node A
            dword   E_XMT_A         ; Transmit Buffer to Node A
            dword   E_RCV_A         ; Receive Buffer from Node A

            dword   NodeC           ; Pointer to Node C
            dword   E_XMT_C         ; Transmit Buffer to Node C
            dword   E_RCV_C         ; Receive Buffer from Node C

            dword   NodeF           ; Pointer to Node F
            dword   E_XMT_F         ; Transmit Buffer to Node F
            dword   E_RCV_F         ; Receive Buffer from Node F

NodeF       byte    'F'             ; Name
            byte    3               ; Number of Connection
            dword   QueueF          ; Base address of Queue
            dword   QueueF          ; Input Pointer of Queue
            dword   QueueF          ; Output Pointer of Queue

            dword   NodeB           ; Pointer to Node B
            dword   F_XMT_B         ; Transmit Buffer to Node B
            dword   F_RCV_B         ; Receive Buffer from Node B

            dword   NodeD           ; Pointer to Node D
            dword   F_XMT_D         ; Transmit Buffer to Node D
            dword   F_RCV_D         ; Receive Buffer from Node D

            dword   NodeE           ; Pointer to Node E
            dword   F_XMT_E         ; Transmit Buffer to Node E
            dword   F_RCV_E         ; Receive Buffer from Node E

EndOfNodes  dword   EndOfNodes            

; Ptrs
CurNodePtr          dword       ?
CurConnPtr          dword       ?

; Output File
msg_OutFile_Error   byte        "Error opening output file.", 0
OutFile_Name        byte        "output.txt", 0
OutFile_Ptr         dword       ?
OutFile_CRLF        byte        13,10

; Time Step
msg_TimeStep        byte        "Time is:         0", 0
TimeStepOffset      equ         9
TimeStep            dword       1

; Messages Alive
MessagesAlive       dword       1
msg_MessagesAlive   byte        9,9, "There are       messages active.", 0
MessAlive_Offset    equ         12

; New Messages Generated
NewMessageCounter   byte        0
msg_NewMessages     byte        9,9, "There are x new messages.", 0
NewMess_Offset      equ         12

; Message Received
msg_MessageReceived byte        9,9, "At time         0, a message was received from x.", 0
MsgRcv_Time         equ         10
MsgRcv_Name         equ         49

; Output Msg
OutMsg              byte        100 dup(0)

; Statistics
TotalPackets        dword       0
DestinationPackets  dword       0
TotalHops           dword       0
msg_TotalPackets    byte        "Total packets generated:      ", 0
TotPacks_Offset     equ         25
msg_DestPacks       byte        "Total packets reaching destination:      ", 0
DestPacks_Offset    equ         36
msg_AvgHops         byte        "The average number of hops was:      ", 0

; Flags
flag_Echo           byte        0


.code

main PROC

    ; edi - Pointer to beginning of current Node structure
    ; esi - Pointer to connected Node struture
    ; edx - Used for WriteString
    ; ecx - Used for WriteString
    ; ebx - Used for connection counter
    ; eax - Temporary register for calculations and data

    ; Print welcome message
    mov edx, offset msg_Welcome
    mov ecx, sizeof msg_Welcome
    call WriteString
    call Crlf

    ; Open the Output File
    mov edx, offset OutFile_Name
    call CreateOutputFile
    mov OutFile_Ptr, eax
    cmp eax, INVALID_HANDLE_VALUE
    je OutFileError

    ; Get the Start of the Network
    mov edi, offset Network                     ; Put the start of the network address in edi
    
    ; Setup the initial message packet
    mov al, 'D'
    mov Dest_Node, al
    mov al, 'A'
    mov Sender_Node, al
    mov Origin_Node, al
    mov al, 5
    mov TTL_Counter, al
    mov CurNodePtr, edi
    call Enqueue


mainloop:

    ; Transmit Loop
    call WriteTimeToFile
    mov edi, offset Network
    call TransmitLoop
    
    ; Increment the time step
    inc TimeStep

    ; Receive Loop
    call WriteTimeToFile
    mov edi, offset Network
    call ReceiveLoop

    cmp MessagesAlive, 0
    jg mainloop

    jmp PrintStats


; Transmit Loop
; For Each Node
    ; If a message is in its queue
    ; Copy message to each transmit buffer
TransmitLoop:

    call PrintNodeXmt

    call Dequeue
    cmp Dest_Node, 0
    je TransmitLoopNext
    dec TTL_Counter
    dec MessagesAlive

    xor eax, eax
    xor ebx, ebx
    mov eax, edi
    add eax, 14
    mov bl, byte ptr Node_Connections[edi]

    mov NewMessageCounter, 0

CopyXmtPacketLoop:
    ; Print the Current Connection
    push ebx
    mov edx, [eax]
    xor ecx, ecx
    mov cl, byte ptr [edx]
    mov edx, offset msg_XmtConn
    mov byte ptr XmtConn_name[edx], cl

    push eax
    mov ecx, sizeof msg_XmtConn
    push edi
    push esi
    mov edi, offset OutMsg
    mov esi, edx
    cld
    rep movsb
    mov ecx, sizeof msg_XmtConn
    call PrintString
    pop esi
    pop edi
    pop eax

    ; Update the message info
    mov cl, byte ptr Node_Name[edi]
    mov Sender_Node, cl
    cmp TTL_Counter, 0
    je XmtNextConn

    ; Copy the message to the XMT Buffer of the current connection
    push edi
    push esi
    mov edi, 4[eax]
    mov esi, offset MessagePointer
    mov ecx, PacketSize
    cld
    rep movsb
    pop esi
    pop edi
    inc MessagesAlive

XmtNextConn:
    ; Check if we have more connections
    inc NewMessageCounter
    pop ebx
    dec ebx
    add eax, 12
    cmp ebx, 0
    jg CopyXmtPacketLoop

    ; Print Out the Number of New Messages
    push eax
    xor eax, eax
    mov al, NewMessageCounter
    add eax, TotalPackets
    mov TotalPackets, eax
    pop eax
    dec NewMessageCounter
    push edi
    push esi
    push ecx
    mov edi, offset OutMsg
    mov esi, offset msg_NewMessages
    mov cl, NewMessageCounter
    add cl, 48
    mov byte ptr NewMess_Offset[esi], cl
    mov ecx, sizeof msg_NewMessages
    cld
    rep movsb
    mov ecx, sizeof msg_NewMessages
    call PrintString
    pop ecx
    pop esi
    pop edi

    ; Print out the Number of Messages Alive
    call WriteMessagesAlive

TransmitLoopNext:
    call NextNode
    cmp edi, EndOfNodes
    jge TransmitLoopEnd
    jmp TransmitLoop

TransmitLoopEnd:
    ret

    
; Get the next node in the Network
NextNode: 
    ; Get to the next Node
    mov eax, 0
    mov al, byte ptr Node_Connections[edi]          ; Get the current node's number of connections
    mov ebx, 0
    mov bl, ConnectionSize
    mul bl

    add edi, BaseSizeOfStructure                    ; Add the size of the fixed portion of each node
    add edi, eax                                    ; Add the size of the connections block to the node
    ret


; Print the Transmit Message for this Node
PrintNodeXmt:
    ; Print the current node's name
    mov edx, offset msg_TransmitQueue               ; Build the Source Node Message
    mov ecx, sizeof msg_TransmitQueue
    
    mov al, byte ptr Node_Name[edi]                 ; Move the name of the current node into edx
    mov XmtMsg_Name[edx], al

    push edi
    push esi
    mov edi, offset OutMsg
    mov esi, edx
    cld
    rep movsb
    mov ecx, sizeof msg_TransmitQueue
    call PrintString
    pop esi
    pop edi

    ret



ReceiveLoop:
    mov CurNodePtr, edi
    call PrintNodeRcv

    xor eax, eax
    xor ebx, ebx
    mov bl, Node_Connections[edi]
    mov eax, edi
    add eax, BaseSizeOfStructure

ReceiveConnection:
    ; Get the current connection's rcv buffer
    mov edx, 8[eax]

    ; Check if there is a message in the rcv buffer
    cmp byte ptr [edx], 0
    je ReceiveNextConnection

    ; Copy the message into the packet buffer
    push edi
    push esi
    mov esi, edx
    mov edi, offset MessagePointer
    mov ecx, PacketSize
    cld
    rep movsb
    pop esi
    pop edi
    dec MessagesAlive

    ; Print out the Message Info
    call WriteMessageReceived

    ; Check if the Packet has reached its destination
    push ebx
    push eax
    xor ebx, ebx
    xor eax, eax
    mov bl, Dest_Node
    mov al, byte ptr Node_Name[edi]
    cmp al, bl
    pop eax
    pop ebx
    je PacketDestination

    ; Update the Message Info
    mov ecx, TimeStep
    mov Time_Received, ecx

    ; If the TTL is 0, don't Enqueue
    cmp TTL_Counter, 0
    je PacketDeath
    jmp EnqueueMsg

PacketDeath:
    push edx
    push ecx
    push edi
    push esi
    mov esi, offset msg_PacketDied
    mov edi, offset OutMsg
    mov ecx, sizeof msg_PacketDied
    cld
    rep movsb
    pop esi
    pop edi
    mov ecx, sizeof msg_PacketDied
    call PrintString
    pop ecx
    pop edx
    jmp SkipEnqueue

PacketDestination:
    push edi
    push esi
    push ecx
    push eax
    mov esi, offset msg_PacketDest
    mov edi, offset OutMsg
    mov ecx, sizeof msg_PacketDest
    cld
    rep movsb
    mov ecx, sizeof msg_PacketDest
    call Printstring
    pop eax
    pop ecx
    pop esi
    pop edi
    inc DestinationPackets
    jmp SkipEnqueue

EnqueueMsg:
    ; Enqueue the new message
    call Enqueue
    inc MessagesAlive

SkipEnqueue:
    ; Print out the Messages Alive count
    call WriteMessagesAlive

    ; Clear the rcv buffer
    mov byte ptr 8[edx], 0

ReceiveNextConnection:
    dec ebx
    cmp ebx, 0
    je ReceiveLoopNext
    add eax, ConnectionSize
    jmp ReceiveConnection
    

ReceiveLoopNext:
    call NextNode
    cmp edi, EndOfNodes
    je ReceiveLoopEnd
    jmp ReceiveLoop


ReceiveLoopEnd:
    ret


PrintNodeRcv:
    ; Print the current node's name
    mov edx, offset msg_ReceiveBuffer             ; Build the Source Node Message
    mov ecx, sizeof msg_ReceiveBuffer
    
    mov al, byte ptr Node_Name[edi]                      ; Move the name of the current node into edx
    mov RcvMsg_Name[edx], al

    push edi
    push esi
    mov edi, offset OutMsg
    mov esi, edx
    cld
    rep movsb
    mov ecx, sizeof msg_ReceiveBuffer
    call PrintString
    pop esi
    pop edi

    ret





; Enqueue a message into the current node's transmit queue
Enqueue:
    push edx
    mov edx, CurNodePtr
    push edi
    push esi
    push eax
    push ebx

    cmp TTL_Counter, 0
    je FinishEnqueue

    ; Find end of Queue
    mov ebx, Node_Queue_Base[edx]
    add ebx, QueueSize*PacketSize

    ; Check if the Queue is full
    mov ecx, Node_Queue_Output[edx]
    mov eax, Node_Queue_Input[edx]
    add eax, PacketSize
    cmp eax, ebx
    jl EnqueueCmpInOut
    sub eax, QueueSize*PacketSize
EnqueueCmpInOut:
    cmp eax, ecx
    je EnqueueFull

EnqueueCopyMessage:
    ; Copy the message
    cld
    mov esi, offset MessagePointer
    mov edi, Node_Queue_Input[edx]
    mov ecx, PacketSize
    rep movsb

EnqueueUpdateInPtr:
    ; Update the Pointer
    mov eax, Node_Queue_Input[edx]
    add eax, PacketSize
    cmp eax, ebx
    jl SaveInPtr
    mov eax, Node_Queue_Base[edx]
SaveInPtr:
    mov Node_Queue_Input[edx], eax
    jmp FinishEnqueue

EnqueueFull:
    jmp FinishEnqueue

FinishEnqueue:
    pop ebx
    pop eax
    pop esi
    pop edi
    pop edx
    ret


; Dequeue a message from the current node into the message buffer
Dequeue:
    mov edx, edi
    push edi
    push esi
    push eax
    push ebx

    ; Find end of Queue
    mov ebx, Node_Queue_Base[edx]
    add ebx, QueueSize*PacketSize

    ; Check for Empty Queue
    mov eax, Node_Queue_Output[edx]
    mov ecx, Node_Queue_Input[edx]
    cmp eax, ecx
    je DequeueEmpty

DequeueCopyMessage:
    ; Copy the message
    cld
    mov edi, offset MessagePointer
    mov esi, Node_Queue_Output[edx]
    mov ecx, PacketSize
    rep movsb
    mov ecx, TimeStep
    mov Time_Received, ecx

DequeueUpdateOutPtr:
    mov eax, Node_Queue_Output[edx]
    add eax, PacketSize
    cmp eax, ebx
    jl SaveOutPtr
    sub eax, PacketSize*QueueSize
SaveOutPtr:
    mov Node_Queue_Output[edx], eax
    jmp FinishDequeue

DequeueEmpty:
    mov Dest_Node, 0
    jmp FinishDequeue

FinishDequeue:
    pop ebx
    pop eax
    pop esi
    pop edi
    ret


; Write the Current Time Step to file
WriteTimeToFile:
    push esi
    push edi
    push edx
    push ecx
    push ebx
    push eax

    mov edi, offset msg_TimeStep
    mov ecx, TimeStepOffset
    add ecx, 8
    mov ebx, 10
    mov eax, TimeStep

WriteTimeLoop:
    xor edx, edx
    div ebx
    add edx, 48
    mov byte ptr [edi+ecx], dl
    dec ecx
    cmp eax, 0
    je WriteTimeEnd
    jmp WritetimeLoop

WriteTimeEnd:
    mov esi, edi
    mov edi, offset OutMsg
    mov ecx, sizeof msg_TimeStep
    cld 
    rep movsb
    mov ecx, sizeof msg_TimeStep
    call PrintString

    pop eax
    pop ebx
    pop ecx
    pop edx
    pop edi
    pop esi
    ret
    

WriteMessagesAlive:
    push esi
    push edi
    push edx
    push ecx
    push ebx
    push eax

    mov edi, offset msg_MessagesAlive
    mov ecx, MessAlive_Offset
    add ecx, 4
    mov ebx, 10
    xor eax, eax
    mov eax, MessagesAlive

WriteMessagesAliveLoop:
    xor edx, edx
    div ebx
    add edx, 48
    mov byte ptr [edi+ecx], dl
    dec ecx
    cmp eax, 0
    je WriteMessagesAliveEnd
    jmp WriteMessagesAliveLoop

WriteMessagesAliveEnd:
    mov esi, edi
    mov edi, offset OutMsg
    mov ecx, sizeof msg_MessagesAlive
    cld 
    rep movsb
    mov ecx, sizeof msg_MessagesAlive
    call PrintString

    pop eax
    pop ebx
    pop ecx
    pop edx
    pop edi
    pop esi
    ret


WriteMessageReceived:
    push esi
    push edi
    push edx
    push ecx
    push ebx
    push eax

    mov edi, offset msg_MessageReceived
    mov ecx, MsgRcv_Time
    add ecx, 8
    mov ebx, 10
    mov eax, Time_Received

WriteMsgRcvLoop:
    xor edx, edx
    div ebx
    add edx, 48
    mov byte ptr [edi+ecx], dl
    dec ecx
    cmp eax, 0
    je WriteMsgRcvEnd
    jmp WriteMsgRcvLoop

WriteMsgRcvEnd:
    mov esi, edi
    mov cl, Sender_Node
    mov byte ptr MsgRcv_Name[esi], cl
    mov edi, offset OutMsg
    mov ecx, sizeof msg_MessageReceived
    cld 
    rep movsb
    mov ecx, sizeof msg_MessageReceived
    call PrintString

    pop eax
    pop ebx
    pop ecx
    pop edx
    pop edi
    pop esi
    ret


PrintString:
    push edi
    push esi
    push edx
    push eax

    mov edx, offset OutMsg
    call WriteString
    call Crlf

    mov edx, offset OutMsg
    sub ecx, 1
    mov eax, OutFile_Ptr
    call WriteToFile

    mov edx, offset OutFile_CRLF
    push ecx
    mov ecx, 1
    mov eax, OutFile_Ptr
    call WriteToFile
    pop ecx

    pop eax
    pop edx
    pop esi
    pop edi
    ret


PrintStats:

    call PrintTotalPackets
    call PrintDestPackets
    call WriteTimeToFile

    ; Quit
    jmp Quit


PrintTotalPackets:

    mov edi, offset OutMsg
    mov esi, offset msg_TotalPackets
    mov ecx, TotPacks_Offset
    add ecx, 4
    mov ebx, 10
    mov eax, TotalPackets

PrintTotalPacketsLoop:
    xor edx, edx
    div ebx
    add edx, 48
    mov byte ptr [esi+ecx], dl
    dec ecx
    cmp eax, 0
    je PrintTotalPacketsEnd
    jmp PrintTotalPacketsLoop

PrintTotalPacketsEnd:
    mov ecx, sizeof msg_TotalPackets
    cld
    rep movsb
    mov ecx, sizeof msg_TotalPackets
    call PrintString

    ret


PrintDestPackets:
    mov edi, offset OutMsg
    mov esi, offset msg_DestPacks
    mov ecx, DestPacks_Offset
    add ecx, 4
    mov ebx, 10
    mov eax, DestinationPackets

PrintDestPacketsLoop:
    xor edx, edx
    div ebx
    add dl, 48
    mov byte ptr [esi+ecx], dl
    dec ecx
    cmp eax, 0
    je PrintDestPacketsEnd
    jmp PrintDestPacketsLoop

PrintDestPacketsEnd:
    mov ecx, sizeof msg_DestPacks
    cld
    rep movsb
    mov ecx, sizeof msg_DestPacks
    call PrintString
    ret


OutFileError:
    mov edx, offset msg_OutFile_Error
    mov ecx, sizeof msg_OutFile_Error
    call WriteString
    call Crlf
    jmp Quit

; Exit the program
Quit:
    mov edx, offset msg_Quit
    mov ecx, sizeof msg_Quit
    call WriteString

    exit

main ENDP
end main
