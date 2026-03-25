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
.extern toDec
.extern two_check

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
    // 2. PROCESS USER INPUT - CREATE BINARY NUMBER STRING
    // 	X0: number of characters read
    // 	X1: buffer pointer (input)
    //  X2: buffer pointer to binary string
    // RETURN:
    // 	X0: pointer to binary string
    //  X1: last/sign bit (0 or 1)
    // -----------------------------------------------------------------
    MOV X9, X0
	LDR X1, =szInBuffer
    LDR X2, =szBinBuffer
	MOV X0, X9
	BL  processInput
	MOV X2, X0      // keep binary string pointer
	MOV X10, X1     // keep sign bit

    // -----------------------------------------------------------------
    // 3. OUTPUT BINARY STRING 
    // 	X0: binary string (int)
    //  X1: string to save binary to
    // RETURN:
    // 	X0: binary string 
    // -----------------------------------------------------------------
    // putstring reads pointer from X0
    BL putstring

    // -----------------------------------------------------------------
    // 4. OUTPUT ARROW
	// 	X0: string to output
    // RETURN:
    // 	nothing
    // -----------------------------------------------------------------
    LDR X0, =sArrow
    BL putstring

    // -----------------------------------------------------------------
    // -----------------------------------------------------------------
    // CONVERT SIGN BIT TO DECIMAL STRING
	//	X0: sign bit value (0/1)
	//	X1: output string buffer
	// RETURN:
	//	X0: string to save to 
    // -----------------------------------------------------------------
	MOV X0, X10
	LDR X1, =szBinBuffer
	BL toDec

	// -----------------------------------------------------------------
    // OUTPUT BINARY STRING 
    // 	X0: binary string (int)
    // RETURN:
    // 	X0: binary string 
    // -----------------------------------------------------------------
    LDR X0, =szBinBuffer
    BL  putstring

    // -----------------------------------------------------------------
    // OUTPUT DECIMAL
	//	X0: passing binary string 
    // -----------------------------------------------------------------
	LDR X0, =szBinBuffer
    BL putstring

    // -----------------------------------------------------------------
    // TERMINATE PROGRAM
    // -----------------------------------------------------------------
terminate:
    MOV X0, #0
    MOV X8, #SYS_exit
    SVC 0

    // -----------------------------------------------------------------
    // DATA SECTION
    // -----------------------------------------------------------------
    .data
szInBuffer:     .space IN_LEN
szBinBuffer:    .space BIN_LEN
sArrow:         .ascii " -> "

.end
