// ---------------------------------------------------------------------
// getstring.s
// ---------------------------------------------------------------------
// 	PURPOSE:
// Will read a string of characters up to a specified length from the 
// console and save it in a specified buffer as a C-String (i.e. null
// terminated).
// ---------------------------------------------------------------------
//	VARAIBLES:
//  X0: Points to the first byte of the buffer to receive the string. This must
//      be preserved (i.e. X0 should still point to the buffer when this function
//      returns).
//  X1: The maximum length of the buffer pointed to by X0 (note this length
//      should account for the null termination of the read string (i.e. C-String)
//  LR: Must contain the return address (automatic when BL
//      is used for the call)
//  All AAPCS mandated registers are preserved.
// ---------------------------------------------------------------------
// 	PSUEDOCODE:
// 1. Get variables from main and save them
// 2. Get input from user
// 3. Process input
//	a. make sure input isnt over max length
//	b. make last letter \0
//  c. replace null with \0
// 4. Output input
// 5. Return to main
// ---------------------------------------------------------------------
.global getstring	// Provide program starting address 

getstring: 
	.EQU STDIN,		0	// starndard input
	.EQU STDOUT,	1	// standard output
	.EQU SYS_read,	63	// Linux read()
	.EQU SYS_write, 64	// Linux write()
	.EQU SYS_exit,  93	// exit() supervisor call code 

	.text  // code section 
	// -----------------------------------------------------------------
	// SAVE VARIABLES FROM MAIN
	//	X3: X0, input string
	//	X4: X1, input lenth
	// -----------------------------------------------------------------
	MOV X3, X0			// X3 = X0, variable to store string
	MOV X4, X1			// X4 = X1, input lenght

	// -----------------------------------------------------------------
	// READ KEYBOARD
	// -----------------------------------------------------------------
	MOV X0, STDIN  		// file descriptor for stdin (keyboard) 
	MOV X1, X3			// read() needs buffer pointer in X1 
	MOV X2, X4		 	// max amount of characters to read
	MOV X8, SYS_read 	// Linux read() system call number 
	SVC 0				// call Linux to execute commands

	// -----------------------------------------------------------------
	// ERROR: TERMINATE PROGRAM
	// -----------------------------------------------------------------
	CMP  X0, XZR
	B.GE done     		// jump if valid

	// INVALID - EXIT
	MOV X0, #1			// set return code to 0, all good 
	MOV X8, #SYS_exit	// set exit() supervisor call code 
	SVC 0				// call Linux to exit

	// -----------------------------------------------------------------
	// REMOVE NULL
	// -----------------------------------------------------------------
	STRB WZR, [X3, X0]  // X0[numCharsRead] = \0

    // -----------------------------------------------------------------
    // RETURN TO MAIN - NO ISSUES
    // -----------------------------------------------------------------
done:
	RET     // return to main

.end	// end of program, optional but good practice 
