// ---------------------------------------------------------------------
// Aspen Cristobal & Sophia
// CS3b - Bin2 Dec
// 3/24/2026
// ---------------------------------------------------------------------
// 	PURPOSE:
// LOREM
// ---------------------------------------------------------------------
//	VARAIBLES:
// LOREM
// ---------------------------------------------------------------------
// 	PSUEDOCODE:
// 1. (getstring.s) Get user input
// 2. (getstring.s) Process User input
// 	a. get rid of non binary values (only 1 and 0 should remain)
// 	b. make it 16 bits long
//		i. if user entered less than 16 make the remaining 0
// 		ii. replace null with ‘\0’
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
.global _start	// Provide program starting address 

// functions
.extern getstring	// user input

_start: 
	// SYSTEM
	.EQU SYS_exit,  93	// exit() supervisor call code 
    
	// CONSTANTS
	.EQU IN_LEN,	64	// max input length
	.EQU BIN_LEN,	17	// max binary string length

	.text  // code section

	// -----------------------------------------------------------------
	// GET USER INPUT
	// -----------------------------------------------------------------
	LDR X0, =szInBuffer		// store input
	MOV X1, IN_LEN			// input max length
	BL  getstring

	// -----------------------------------------------------------------
	// TERMINATE PROGRAM
	// -----------------------------------------------------------------
	MOV X0, #0			// set return code to 0, all good 
	MOV X8, #SYS_exit	// set exit() supervisor call code 
	SVC 0				// call Linux to exit 

	.data	// data section
szInBuffer: 	.space 	IN_LEN		// holds user input, includes null
szBinBuffer:	.space	BIN_LEN		// holds binary string, includes null

.end	// end of program, optional but good practice 
