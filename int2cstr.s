// Sophia Omar
// CS3B - Lab 5-2 - int2cstr function
// Purpose: Function converts a signed integer to a C-string stored in 
//	stored in memory to a provided pointer.  
// Registers:
// 	X0: Contains the binary (signed) value to be converted to a C-String
// 	X1: Must point to address large enough to hold the converted value.
// 	LR: Contains the return address (automatic when BL is used)
// Registers X0 - X8 are modified and not preserved
// Algorithm/Psuedocode: 
//	Check if the input is zero (return to driver if it is)  
//	Check if the int is negative (and add sign if it is but negate it if nont) 
//	Loop through using signed division to convert each digit
//		until the quotient is zero
//	Loop to save each digit to memory from the stack 
//	Add the null terminatoe to the new string
//	Return to the driver 
.global int2cstr //Provide program starting address

int2cstr:


        .text   // Code section
	//Check if the int is zero 
	CMP X0, #0 
	B.NE not_zero
	
	MOV W2, #'0'		//get the ascii character 0 
	STRB W2, [X1], #1	// Store that and then move the pointer
	MOV W2, #0	// get the null terminator
	STRB W2, [X1]	//store the null terminator
	RET	//return to the driver (since it is zero and you can just print that) 
not_zero:
	//start the negative loop 
	MOV X2, #10 	//using 10 to divide to get each digit
	MOV X5, #0 	//using this as a counter 
	
	// check for the negative and negate it if it's not
	CMP X0, #0
	B.LT is_negative //just proceed if it's already negative

	NEG X0, X0	//flip it to negative if it is positive
	B start_loop
is_negative: 	 
	// adds the negative sign to the string at this point 
	MOV W3, #'-' 	//ascii for the negative sign
	STRB W3, [X1], #1	// store the sign and then increment X1

start_loop:
	SDIV X3, X0, X2	//divide the int by 10 then save the quotient in X3
	// get the remainder 
	MUL X4, X3, X2	
	SUB X4, X0, X4 	
	
	//switch the remainder to ascii
	MOV X6, #'0'	// get the ascii for 0 
	SUB X4, X6, X4	//convert it to whatever digit it is
	
	SUB SP, SP, #16 //push to the stack 
	STR X4, [SP]
	ADD X5, X5, #1	// increase the digit counter 
		
	MOV X0, X3	//update the quotient
	CMP X0, #0 	//check if it's zero
	B.NE start_loop  //if not, then keep looping for the next digit
save_loop:
	CMP X5, #0	//check if there's any digits left
	B.EQ done	//go to done if theres not
	
	LDR X4, [SP], #16 //pop the digit
	STRB W4, [X1], #1 //save it to memory 
	SUB X5, X5, #1 //decrement the counter 
	B save_loop	//repeat until there's no more digits
done: 
	MOV W4, #0
	STRB W4, [X1]	//null terminate the string
	RET	//go back to the driver

	.data	//data section of code
.end    //end of program
