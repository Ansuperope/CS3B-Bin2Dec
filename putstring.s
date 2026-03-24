// ---------------------------------------------------------------------
// putstring.s
// ---------------------------------------------------------------------
// 	PURPOSE:
// Will read a string of characters up to a specified length from the 
// console and output the result
// ---------------------------------------------------------------------
//  PSUEDOCODE:
// 1. Receive values from main and save them:
//  a. Save string X0 to X3
//  b. Save length X1 to X4
//
// 2. Output
//  a. Give file descriptor
//  b. pass string to output
//  c. pass lenght of output
//  d. do system call
//
// 3. Return to main
// ---------------------------------------------------------------------
.global putstring

putstring:
    // SYSTEM CALLS
	.EQU STDOUT,	1	// standard output
    .EQU SYS_write, 64	// Linux write()

    .text   // code section

    // RECEIVE AND SAVE VARAIBLES FROM MAIN
    MOV X3, X0      // string to output
    MOV X4, LR	    // save the return in x3 so it doesnt get overwritten

    // -----------------------------------------------------------------
    // GET STRING LENGTH
    // -----------------------------------------------------------------
	BL String_length	// call the String_length function 
	MOV X2, X0	        // save the length from x0

    // -----------------------------------------------------------------
    // OUTPUT
    //  X0: file descriptor
    //  X1: string to output (X3, from main)
    //  X2: length (received from String_length)
    //  X8: system call
    // -----------------------------------------------------------------
    MOV X0, STDOUT			// tells program we will output
	MOV X1, X3	            // string to output
		        		    // number of characters to output - already set
	MOV X8, SYS_write		// Linux write() sys call
	SVC 0					// call Linux to execute commands

    // -----------------------------------------------------------------
    // RETURN TO MAIN
    // -----------------------------------------------------------------
    MOV LR, X4 	    // get return and put it back into LR
    RET

.end	// end of program, optional but good practice 
