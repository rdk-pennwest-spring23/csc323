 TITLE Broadcast Network Simulator (G7P3.asm)

; Robert Krency		-		kre1188@pennwest.edu
; Tanner Kirsch		-		kir0510@pennwest.edu

; This program simulates a simple Broadcast Mode network.



INCLUDE Irvine32.inc

.data

; Constants
ascii_Tab               equ         9
MessagesInQueue         equ         30
PacketSize              equ         8
QueueSize               equ         10
BaseSizeOfStructure     equ         14
ConnectionSize          equ         12
NameOffset              equ         0                                       ; Node name offset
NumConnOffset           equ         1                                       ; Connection Number Offset
Connection              equ         0                       ; Offset to pointer to the connected Node
XMT                     equ         4                       ; Offset to transmit buffer pointer
RCV                     equ         8                       ; Offset to receive buffer pointer


; Messages
msg_Welcome             byte        "Welcome to the Broadcast Network Simulator.", 0
msg_Quit                byte        "Quitting...", 0

; Message to print out info for currently processed node
msg_CurrentNode         byte        "Node being processed: x", 0
CN_Offset_Name          equ         22

; Message to print out connection info
msg_ConnectionInfo      byte        "Origin: x    Destination: x   ", 0
CI_Offset_Origin        equ         8
CI_Offset_Destination   equ         27

; Message Packet
Dest_Node               byte        0
Sender_Node             byte        0
Origin_Node             byte        0
TTL_Counter             byte        0
Time_Received           word        0

Destination             equ         0       ; Target Offset
Sender                  equ         1       ; Last Sender Offset
Origin                  equ         2       ; Source Offset
TTL                     equ         3       ; TTL Offset
Received                equ         4       ; Receive Time Offset

MessagePacketSize       equ         6


; Buffers

; Transmit Queues
AxmtQueue               byte        QueueSize*MessagePacketSize   dup(0)
BxmtQueue               byte        QueueSize*MessagePacketSize   dup(0)
CxmtQueue               byte        QueueSize*MessagePacketSize   dup(0)
DxmtQueue               byte        QueueSize*MessagePacketSize   dup(0)
ExmtQueue               byte        QueueSize*MessagePacketSize   dup(0)
FxmtQueue               byte        QueueSize*MessagePacketSize   dup(0)


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

D_XMT_F byte PacketSize dup(0)
F_RCV_D byte PacketSize dup(0)
F_XMT_D label byte
D_RCV_F byte PacketSize dup(0)

F_XMT_E label byte
E_RCV_F byte PacketSize dup(0)
E_XMT_F byte PacketSize dup(0)
F_RCV_E byte PacketSize dup(0)

B_XMT_F byte PacketSize dup(0)
F_RCV_B byte PacketSize dup(0)
F_XMT_B label byte
B_RCV_F byte PacketSize dup(0)

C_XMT_E label byte
E_RCV_C byte PacketSize dup(0)
E_XMT_C label byte
C_RCV_E byte PacketSize dup(0)


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



.code

main PROC

    ; edi - Pointer to beginning of current Node structure
    ; esi - Pointer to connected Node struture
    ; edx - Used for WriteString
    ; ecx - Used for WriteString
    ; ebx - Used for connection counter
    ; eax - Temporary register for calculations and data

    mov edi, offset Network                     ; Put the start of the network address in edi

mainloop:

    mov edx, offset msg_CurrentNode             ; Build the Source Node Message
    mov ecx, sizeof msg_CurrentNode
    
    mov al, Node_Name[edi]                      ; Move the name of the current node into edx
    mov CN_Offset_Name[edx], al

    ; Continue Lesson 18


main ENDP
end main
