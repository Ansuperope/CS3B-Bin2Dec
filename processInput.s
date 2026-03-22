// ---------------------------------------------------------------------
// processInput.s
// ---------------------------------------------------------------------
// 	PSUEDOCODE:
// 1. Get values from main
//  a. number of characters read
//  b. input string
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
    // INITIALIZE REGISTERS
    //  X0: number of chars read
    //  X1: input buffer pointer
    //  X2: input counter
    //  X3: 
    //  X4: bit counter
    //  X5: current char
    //  X6: current bit (0 or 1)
    //  X7: FINAL INTEGER VALUE (IMPORTANT)
    // -----------------------------------------------------------------
    // INITALIZE
    MOV X3, #0          // input index = 0
    MOV X4, #0          // bit count = 0
    MOV X7, #0          // final integer = 0

    // -----------------------------------------------------------------
    // LOOP THROUGH INPUT STRING
    // -----------------------------------------------------------------
forInString:

    // CHECK IF AT END 
    CMP X3, X0
    B.EQ signExtend

    // CHECK IF AT MAX LENGTH
    CMP X3, IN_LEN
    B.EQ signExtend

    // LOAD CURRENT CHARACTER
    LDRB W5, [X1, X3]

    // INCREMENT INDEX
    ADD X3, X3, #1

    // -----------------------------------------------------------------
    // CHECK FOR TERMINATE ('q' or 'Q')
    // -----------------------------------------------------------------
    CMP W5, #'q'
    B.EQ terminate

    CMP W5, #'Q'
    B.EQ terminate

    // -----------------------------------------------------------------
    // CHECK FOR CLEAR ('c' or 'C')
    // -----------------------------------------------------------------
    CMP W5, #'c'
    B.EQ clearBin

    CMP W5, #'C'
    B.EQ clearBin

    // -----------------------------------------------------------------
    // CHECK IF '1'
    // -----------------------------------------------------------------
    CMP W5, #'1'
    B.EQ addBit

    // -----------------------------------------------------------------
    // CHECK IF '0'
    // -----------------------------------------------------------------
    CMP W5, #'0'
    B.EQ addBit

    // ignore all other characters
    B forInString

    // -----------------------------------------------------------------
    // END PROGRAM
    // -----------------------------------------------------------------
terminate:
    MOV X0, #0
    MOV X8, #SYS_exit
    SVC 0

    // -----------------------------------------------------------------
    // CLEAR BINARY (reset everything)
    // -----------------------------------------------------------------
clearBin:
    MOV X7, #0      // reset integer value
    MOV X4, #0      // reset bit count
    B forInString

// ---------------------------------------------------------------
// ADD BIT = 1
// ---------------------------------------------------------------
addBit:
    CMP X4, BIN_LEN     // if already 16 bits, ignore
    B.EQ forInString

    LSL X7, X7, #1  // shift left
    ORR X7, X7, #1  // add 1

    ADD X4, X4, #1  // increment bit count
    B forInString

// ---------------------------------------------------------------
// SIGN EXTEND (ONLY IF < 16 BITS)
//  X6: how many bits to extend
// ---------------------------------------------------------------
signExtend:

    // if exactly 16 bits → skip
    CMP X4, BIN_LEN
    B.EQ done

    // shift amount = 16 - bitCount
    MOV X6, BIN_LEN
    SUB X6, X6, X4

    // sign extend using shift trick
    LSL X7, X7, X6
    ASR X7, X7, X6

    // -----------------------------------------------------------------
    // RETURN TO MAIN
    //  X0: binary
    // -----------------------------------------------------------------
done: 
    MOV X0, X7
    RET


.end
