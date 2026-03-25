// Sophia Omar
// CS3B - Bin2Dec helper function
// Function: two_check
//	Checks a value to determine if it is negative and handles the case
//	in that the most negative value can skipped 
// Algorithm/Psuedocode : 
//	Check if number is positive
//		if it is, then just go to return
//	Check if it matches the most negative special case
//		skip it if it does 
//	If neither of those apply (meaning the value is a normal negative number) 
//		negate the value 
.global two_check //Provide program starting address

two_check:

        .EQU SYS_exit, 93       //exit() supervisor call code

        .text   // Code section
	
	// Check if num is positive 
	CMP X0, #0	// compare the contents with 0 
	B.GE done	// return if X0 >= 0	
	
 	// handle the most negative case 
	MOV X1, #1
	LSL X1, X1, #63	//Shift 1 to the most significant bit
	CMP X0, X1 	
	B.EQ done	// if it is the same as the special case then just RET

	//if it not pos or special then negate
	NEG X0, X0	 
	
        //Return to the calling location
done: 
	RET

.end    //end of program
