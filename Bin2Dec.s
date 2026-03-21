// ---------------------------------------------------------------------
// Aspen Cristobal & Sophia
// CS3b - Bin2 Dec
// ---------------------------------------------------------------------
// 	PSUEDOCODE:
// 1. (getstring.s) Get user input
// 
// 2. Process User input, check each input
//	a. check if user input 'q' or 'Q'
//		i. terminate program
//	b. check if user input 'c' or 'C'
//		i. clear binary string
//		ii. loop again
//	c. check if user input '1' or '0'
//		i. add to binary string
//	d. ignore everything else / do nothing
//
// 3. Make binary string 16 bits long
// 	 a. replace null with ‘\0’
//
// 3. (putstring.s) Output binary
// 4. (putstring.s) Output arrow ->
// 5. Do 2s complement if needed
// 	a. Check sign
// 		i. If neg (1) convert to 2s complement 
// 		ii. If pos (0) skip
// 		iii. If special case skip (Most negative)
// 6. (Bin2dec.s) Convert binary to decimal
// 7. (putstring.s) Output decimal
// ---------------------------------------------------------------------
.global _start

// functions
.extern getstring
.extern putstring
.extern int2cstr

_start:
    // ---------------------------------------------------------------
    // SYSTEM CONSTANTS
    // ---------------------------------------------------------------
    .EQU SYS_exit,  93
    .EQU STDOUT,    1

    // ---------------------------------------------------------------
    // PROGRAM CONSTANTS
    // ---------------------------------------------------------------
    .EQU IN_LEN,    64      // max input length
    .EQU BIN_LEN,   17      // 16 bits + null

    .text

    // ---------------------------------------------------------------
    // 1. GET USER INPUT
    // X0 = buffer pointer
    // X1 = max length
    // returns:
    // X0 = number of characters read
    // ---------------------------------------------------------------
    LDR X0, =szInBuffer
    MOV X1, IN_LEN
    BL  getstring

    // ---------------------------------------------------------------
    // INITIALIZE REGISTERS
    // X0 = number of chars read
    // X1 = input buffer pointer
    // X2 = output binary string buffer
    // X3 = input index
    // X4 = bit counter
    // X5 = current char
    // X6 = current bit (0 or 1)
    // X7 = FINAL INTEGER VALUE (IMPORTANT)
    // ---------------------------------------------------------------
    LDR X1, =szInBuffer
    LDR X2, =szBinBuffer

    MOV X3, #0          // input index = 0
    MOV X4, #0          // bit count = 0
    MOV X7, #0          // final integer = 0

// ---------------------------------------------------------------
// LOOP THROUGH INPUT STRING
// ---------------------------------------------------------------
forInString:

    // check if reached end of input
    CMP X3, X0
    B.EQ signExtend

    // check max input length
    CMP X3, IN_LEN
    B.EQ signExtend

    // load current character
    LDRB W5, [X1, X3]

    // increment index
    ADD X3, X3, #1

    // -----------------------------------------------------------
    // CHECK FOR TERMINATE ('q' or 'Q')
    // -----------------------------------------------------------
    CMP W5, #'q'
    B.EQ terminate

    CMP W5, #'Q'
    B.EQ terminate

    // -----------------------------------------------------------
    // CHECK FOR CLEAR ('c' or 'C')
    // -----------------------------------------------------------
    CMP W5, #'c'
    B.EQ clearBin

    CMP W5, #'C'
    B.EQ clearBin

    // -----------------------------------------------------------
    // CHECK IF '1'
    // -----------------------------------------------------------
    CMP W5, #'1'
    B.EQ addOne

    // -----------------------------------------------------------
    // CHECK IF '0'
    // -----------------------------------------------------------
    CMP W5, #'0'
    B.EQ addZero

    // ignore all other characters
    B forInString

// ---------------------------------------------------------------
// CLEAR BINARY (reset everything)
// ---------------------------------------------------------------
clearBin:
    MOV X7, #0      // reset integer value
    MOV X4, #0      // reset bit count
    B forInString

// ---------------------------------------------------------------
// ADD BIT = 1
// ---------------------------------------------------------------
addOne:
    CMP X4, #16     // if already 16 bits, ignore
    B.EQ forInString

    LSL X7, X7, #1  // shift left
    ORR X7, X7, #1  // add 1

    ADD X4, X4, #1  // increment bit count
    B forInString

// ---------------------------------------------------------------
// ADD BIT = 0
// ---------------------------------------------------------------
addZero:
    CMP X4, #16
    B.EQ forInString

    LSL X7, X7, #1  // shift left (adds 0)

    ADD X4, X4, #1
    B forInString

// ---------------------------------------------------------------
// SIGN EXTEND (ONLY IF < 16 BITS)
// ---------------------------------------------------------------
signExtend:

    // if exactly 16 bits → skip
    CMP X4, #16
    B.EQ buildString

    // if 0 bits → skip
    CMP X4, #0
    B.EQ buildString

    // shift amount = 16 - bit_count
    MOV X6, #16
    SUB X6, X6, X4

    // sign extend using shift trick
    LSL X7, X7, X6
    ASR X7, X7, X6

// ---------------------------------------------------------------
// BUILD BINARY STRING (for display)
// ---------------------------------------------------------------
buildString:

    MOV X3, #15     // index = last position
    MOV X5, #16     // loop counter

buildLoop:
    CMP X5, #0
    B.EQ doneBuild

    // extract lowest bit
    AND X6, X7, #1

    // convert to ASCII
    ADD W6, W6, #'0'

    // store in buffer
    STRB W6, [X2, X3]

    // shift right
    ASR X7, X7, #1

    SUB X3, X3, #1
    SUB X5, X5, #1
    B buildLoop

doneBuild:
    // null terminate
    STRB WZR, [X2, #16]

// ---------------------------------------------------------------
// OUTPUT
// ---------------------------------------------------------------

    // print binary string
    MOV X0, X2
    MOV X1, BIN_LEN
    BL putstring

    // print arrow
    LDR X0, =sArrow
    MOV X1, #4
    BL putstring

    // convert integer to string
    MOV X0, X7
    LDR X1, =szOutBuffer
    BL int2cstr

    // print decimal string
    LDR X0, =szOutBuffer
    MOV X1, #20
    BL putstring

// ---------------------------------------------------------------
// TERMINATE PROGRAM
// ---------------------------------------------------------------
terminate:
    MOV X0, #0
    MOV X8, #SYS_exit
    SVC 0

// ---------------------------------------------------------------
// DATA SECTION
// ---------------------------------------------------------------
.data
szInBuffer:     .space IN_LEN
szBinBuffer:    .space BIN_LEN
szOutBuffer:    .space 32

sArrow:         .ascii " -> "

.end
