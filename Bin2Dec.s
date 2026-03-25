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
.extern cstr2int
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
    // 	X0: last/sign bit (0 or 1)
    // -----------------------------------------------------------------
    MOV X9, X0
	LDR X1, =szInBuffer
    LDR X2, =szBinBuffer
	MOV X0, X9
	BL  processInput

    // SAVE SIGN VARIABLE TO USE FOR LATER
    MOV X4, X0

    // -----------------------------------------------------------------
    // CHECK IF WE DO 2S COMPLEMENT 
	// 	X0: string to output
    // RETURN:
    // 	nothing
    // -----------------------------------------------------------------
    CMP X4, #0      // check if positive
    B.EQ notNeg

    // DO 2S COMPLEMENT, NUM IS NEG
    // pass sign to it
    BL two_check

notNeg:
    // -----------------------------------------------------------------
    // 3. OUTPUT BINARY STRING 
    // 	X0: binary string (int)
    // RETURN:
    // 	nothing
    // -----------------------------------------------------------------
    // putstring reads pointer from X0
    LDR X0, =szBinBuffer
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
    // OUTPUT DECIMAL
	//	X0: passing binary string 
    // -----------------------------------------------------------------
    // PASS NEGATIVE SIGN
    CMP X4, #1
    B   printPos

    LDR X0, =sNegSign
    BL  putstring
    B   terminate

    // PASS POSITIVE SIGN
printPos:
	LDR X0, =sPosSign
    BL  putstring

    // -----------------------------------------------------------------
    // CONVERT SIGN BIT TO DECIMAL STRING
	//	X0: sign bit value (0/1)
	//	X1: output string buffer
	// RETURN:
	//	X0: string to save to 
    // -----------------------------------------------------------------
    // CONVERT BIN STRING TO AN INT
    LDR X0, =szBinBuffer
    BL  cstr2int

    // CONVERT BIN INT TO DEC

    // OUTPUT CONVERT INT 
	LDR X1, =szStrBuffer
	BL int2cstr

    // -----------------------------------------------------------------
    // OUTPUT DECIMAL
	//	X0: passing binary string 
    // -----------------------------------------------------------------
	LDR X0, =szStrBuffer 
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
szStrBuffer:    .space 24

sArrow:         .ascii " -> "
sPosSign:       .ascii "+"
sNegSign:       .ascii "-"

.end
