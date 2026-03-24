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

inputReady:
	// -----------------------------------------------------------------
    // 2. PROCESS USER INPUT - CREATE BINARY NUMBER
    // 	X0: number of characters read
    // 	X1: buffer pointer (input)
    // RETURN:
    // 	X0 -> X4: binary number (integer)
    // -----------------------------------------------------------------
    MOV X0, X2
	LDR X1, =szInBuffer
	BL  processInput
	MOV X2, X0

	// -----------------------------------------------------------------
    // 3. CONVERT BINARY NUMBER TO BINARY STRING
    // 	X0: binary number
    // 	X1: string to save binary to
    // RETURN:
    // 	X0: pointer to binary string
    // -----------------------------------------------------------------
	MOV X0, X2
	LDR X1, =szInBuffer
	BL int2cstr

	// -----------------------------------------------------------------
    // OUTPUT BINARY STRING 
    // 	X0: binary string (int)
    //  X1: string to save binary to
    // RETURN:
    // 	X0: binary string 
    // -----------------------------------------------------------------
	MOV X1, BIN_LEN
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
    // DO 2S COMPLEMENT (IF NEG)
	// 	X0: string to output
    // RETURN:
    // 	nothing
    // -----------------------------------------------------------------

	// -----------------------------------------------------------------
    // CONVERTING BINARY TO DECIMAL
	//	X0: passing binary number
	//	X1: register to save to
	// RETURN:
	//	X0: string to save to 
    // -----------------------------------------------------------------
	MOV X0, X2
	LDR X1, =szBinBuffer
	BL toDec

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
