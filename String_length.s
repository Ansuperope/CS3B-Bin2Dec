// Sophia Omar
// CS3B - Lab 4-1 - String Length & Put String Functions
// 2/7/2026
// Function: String_length
// 	Returns a string's length in X0 when provided a pointer 
//	to a null terminated string in X0. 
// Registers
//	X0: Must point to null terminated string
//	LR: Must contain the return address (auto when BL is used for call)
// All registers except X0, X1, and X2 are preserved. 
// Algorithm/Psuedocode
//	Initialize the counter to 0
//	Get the first character in the string
//	Evaluate whether or not the value is the null termnator 
//	If not zero, then get the next character and increment counter by 1
//	If zero, then return the length in X0
.global String_length //Provide program starting address

String_length:	//Define the function name

        .text   // Code section
	MOV X2, #0 // initialize the length counter to 0
loop:
	LDRB W1, [X0], #1 //load a byte and increase ptr
	CMP W1, #0	//check if the terminator is there
	B.EQ done 	// if yes then jump to done
	ADD X2, X2, #1	// if not then increment length counter
	B loop		// repeat 

done: 
	MOV X0, X2 //returns the final length in X0
	RET	//return to the calling function


        .data   //data section



.end    //end of program
