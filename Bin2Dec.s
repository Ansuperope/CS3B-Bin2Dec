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
.global _start	// Provide program starting address 

// functions
.extern getstring	// user input
.extern putstring	// output text to terminal

_start: 
	// SYSTEM
	.EQU SYS_exit,  93	// exit() supervisor call code
	.EQU SYS_write, 64	// Linux write()
	.EQU STDOUT,	1	// standard output
    
	// CONSTANTS
	.EQU IN_LEN,	64	// max input length
	.EQU BIN_LEN,	17	// max binary string length

	.text  // code section

	// -----------------------------------------------------------------
	// 1. GET USER INPUT
	// -----------------------------------------------------------------
	LDR X0, =szInBuffer		// store input string
	MOV X1, IN_LEN			// input max length
	BL  getstring

	// -----------------------------------------------------------------
	// CREATE BINARY STRING
	//  X0: number of characters read
	//	X1: input string 
    //  X2: binary string
    //  X3: input counter
    //	X4: biary counter
	//	X5 / W5: current input character
    //  X6 / W6: current binary character
	// -----------------------------------------------------------------
	// INITALIZATIONS
	LDR X1, =szInBuffer
	LDR X2, =szBinBuffer

	MOV X3, #-1			// input string counter = -1, doing do while loop
    MOV X4, #0          // binary string counter = 0

forInString:
	// INCREMENT COUNTER
	ADD  X3, X3, #1	// inCounter++ (starts with 0, b/c intalized to -1)

	// -----------------------------------------------------------------
	// EXIT: CHECK IF COUNTER == NUMBER OF CHARACTERS READ (X0)
	// -----------------------------------------------------------------
	CMP  X3, X0		// inCounter == num of character read (X0), exit
	B.EQ output

    // -----------------------------------------------------------------
	// EXIT: CHECK IF COUNTER == IN_LEN
	// -----------------------------------------------------------------
	CMP  X3, IN_LEN		// inCounter == IN_LEN, exit
	B.EQ output

	// GET CURRENT CHARACTER
    LDRB W5, [X1, X3] 	// X6 = inString[inCounter]

	// -----------------------------------------------------------------
	// TERMINATE: CHECK IF CHAR == 'q' or CHAR == 'Q'
	// -----------------------------------------------------------------
    // LOWERCASE
    CMP  W5, #'q'
    B.EQ done

    // UPPERCASE
    CMP W5, #'Q'
    B.EQ done

	// -----------------------------------------------------------------
	// CLEAR BINARY STRING: CHECK IF CHAR == 'c' or CHAR == 'C'
	// -----------------------------------------------------------------
    // LOWERCASE
    CMP  W5, #'c'
    B.EQ done

    // UPPERCASE
    CMP W5, #'C'
    B.EQ done
	
	// -----------------------------------------------------------------
	// CHECK IF CHAR == 1 or CHAR == 0 - ENTER TO BINARY STRING
	// -----------------------------------------------------------------
    // 1
    CMP  W5, #'1'
    B.EQ addBin

    // 0
    CMP  W5, #'0'
    B.EQ addBin

	// -----------------------------------------------------------------
	// LOOP AGAIN: ELSE / DO NOTHING
	// -----------------------------------------------------------------	
	B forInString

	// -----------------------------------------------------------------
	// 	ADD BINARY - 1 OR 0 INPUT
	//  X0: number of characters read
	//	X1: input string 
    //  X2: binary string
    //  X3: input counter
    //	X4: binary counter
	//	X5 / W5: current input character
    //  X6 / W6: current binary character
	// -----------------------------------------------------------------
addBin:
	// -----------------------------------------------------------------
	// EXIT: CHECK IF AT MAX - binCounter < 16
	// -----------------------------------------------------------------
    CMP X4, BIN_LEN - 1            // 15 because start at 0
    B.EQ forInString

	// -----------------------------------------------------------------
    // NOT AT MAX, ADD TO STRING
    // -----------------------------------------------------------------
    // GET CURRENT CHARACTER 
    MOV W6, W5          // binaryString[binaryCounter] = input[inCounter]

    // SAVE INPUT TO BINARY STRING
    STRB W6, [X2, X4] 	// X6 = binaryString[binaryCounter]
    
    // INCREMENT COUNTER
    ADD X4, X4, #1

    // JUMP BACK TO INPUT LOOP
    B forInString

	// -----------------------------------------------------------------
	// OUTPUT BINARY
	//  X0 <- X2: string to output
	//	X1 <- X4: length of output
	// -----------------------------------------------------------------
output: 
	// MAKE LAST INDEX OF BINARY STRING '0'
	STRB WZR, [X2, X4]  // X0[16] = \0
	
	// OUTPUT
	MOV X0, X2
	MOV X1, BIN_LEN
	BL putstring
	
	// -----------------------------------------------------------------
	// TERMINATE PROGRAM
	// -----------------------------------------------------------------
done:
	MOV X0, #0			// set return code to 0, all good 
	MOV X8, #SYS_exit	// set exit() supervisor call code 
	SVC 0				// call Linux to exit 

	.data	// data section
szInBuffer: 	.space 	IN_LEN		// holds user input, includes null
szBinBuffer:	.space	BIN_LEN		// holds binary string, includes null

.end	// end of program, optional but good practice 
