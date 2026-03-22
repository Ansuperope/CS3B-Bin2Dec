// ---------------------------------------------------------------------
// Aspen Cristobal & Sophia
// CS3b - Bin2 Dec
// ---------------------------------------------------------------------
// 	PSUEDOCODE:
// 1. (getstring.s) Get user input
// 
// 2. Process User input / get binary
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
// 4. Convert binary to decimal
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
.extern processInput
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

    // -----------------------------------------------------------------
    // 1. GET USER INPUT
    // 	X0: buffer pointer
    //	X1: max length
    // RETURN:
    // 	X0: number of characters read
    // -----------------------------------------------------------------
    LDR X0, =szInBuffer
    MOV X1, IN_LEN
    BL  getstring

	// -----------------------------------------------------------------
    // 2. PROCESS USER INPUT - CREATE BINARY
    // 	X0: number of characters read
    //	X1: buffer point
	//	X2:
    // RETURN:
    // 	X0: binary string
    // -----------------------------------------------------------------
	MOV X0, X0
	LDR X1, =szInBuffer
	BL  processInput

	// -----------------------------------------------------------------
    // 2. BINARY TO STRING
    // 	X0: number of characters read
    //	X1: buffer point
	//	X2:
    // RETURN:
    // 	X0: binary string
    // -----------------------------------------------------------------
    MOV X0, X0
    LDR X1, =szBinBuffer
    BL int2cstr

	// print decimal string
    LDR X0, =szBinBuffer
    MOV X1, BIN_LEN
    BL putstring

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
