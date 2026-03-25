// ---------------------------------------------------------------------
// processInput.s
// ---------------------------------------------------------------------
//  PSUEDOCODE:
// 1. Get values from main
//  a. number of characters read
//  b. input string
//
// 2. Process user input, check each input
//  a. check if user input 'q' or 'Q' -> terminate program
//  b. check if user input 'c' or 'C' -> clear collected binary
//  c. check if user input '1' or '0' -> add to binary string
//  d. ignore everything else
// ---------------------------------------------------------------------
.global processInput

processInput:
    // ---------------------------------------------------------------
    // SYSTEM CONSTANTS
    // ---------------------------------------------------------------
    .EQU SYS_exit,  93

    // ---------------------------------------------------------------
    // PROGRAM CONSTANTS
    // ---------------------------------------------------------------
    .EQU IN_LEN,    64      // max input length
    .EQU BIN_LEN,   16      // 16 bits

    .text

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
	MOV X3, #-1			// input string counter = -1, doing do while loop
    MOV X4, #0          // binary string counter = 0

forInString:
	// GET CURRENT CHARACTER
	ADD  X3, X3, #1	// inCounter++ (starts with 0, b/c intalized to -1)
	
	// -----------------------------------------------------------------
	// EXIT: CHECK IF COUNTER == NUMBER OF CHARACTERS READ (X0)
	// -----------------------------------------------------------------
	CMP  X3, X0		// inCounter == num of character read (X0), exit
	B.EQ done

    // -----------------------------------------------------------------
	// EXIT: CHECK IF COUNTER == IN_LEN
	// -----------------------------------------------------------------
	CMP  X3, IN_LEN		// inCounter == IN_LEN, exit
	B.EQ done

    LDRB W5, [X1, X3] 	// X6 = inString[inCounter]

	// -----------------------------------------------------------------
	// TERMINATE: CHECK IF CHAR == 'q' or CHAR == 'Q'
	// -----------------------------------------------------------------
    // LOWERCASE
    CMP  W5, #'q'
    B.EQ terminate

    // UPPERCASE
    CMP W5, #'Q'
    B.EQ terminate

	// -----------------------------------------------------------------
	// CLEAR BINARY STRING: CHECK IF CHAR == 'c' or CHAR == 'C'
	// -----------------------------------------------------------------
    // LOWERCASE
    CMP  W5, #'c'
    B.EQ clearBin

    // UPPERCASE
    CMP W5, #'C'
    B.EQ clearBin
	
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
    // CLEAR BINARY STRING
    //  X2: binary buffer
    //  X4: current length
    // -----------------------------------------------------------------
terminate: 
    MOV X0, #0
    MOV X8, #SYS_exit
    SVC 0

    // -----------------------------------------------------------------
    // CLEAR BINARY STRING
    //  X2: binary buffer
    //  X4: current length
    // -----------------------------------------------------------------
clearBin:
    CMP X4, #0
    B.EQ forInString

    MOV W6, #0              // null / 0
    STRB W6, [X2, X4]       // clear each byte

    SUB X4, X4, #1
    B clearBin

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
    // RETURN TO MAIN
    //  X0: pointer to binary output string
    //  X1: last stored bit as integer (0/1)
    // -----------------------------------------------------------------
done:
    // null-terminate output string
    MOV W6, #0
    STRB W6, [X2, X4]

    MOV X0, X2
    RET

.end
