// *********************************************************************
// cstr2int.s
// ---------------------------------------------------------------------
// 	PURPOSE:
// Provided a pointer to a C-String representing a valid signed integer,
// converts it to a quad integer. If under/overflow occurs, then the 
// overflow flag must be set and a value of 0 returned.
// ---------------------------------------------------------------------
//	VARAIBLES:
// X0: Must point to a null terminated string that is a valid signed 64
//     bit decimal number
// X0: signed quad result
// X1 / W1: sign flag
// X2: sum
// X3: current digit
// X4: index
// X5: max minimum value
// LR: Contains the return address (automatic when BL is used)
// Registers X0 - X8 are modified and not preserved
// ---------------------------------------------------------------------
// 	PSUEDOCODE:
// 1. Initalize variables
// 2. Check sign
// 3. Convert to integer (using neg loop)
// 4. Convert back to pos if needed
// 5. Send and return to main
// *********************************************************************
.global cstr2int	// Provide program starting address 

cstr2int:
    
	.text  // code section
	// INTITALIZATIONS
	MOV W1, 1		// sign flag = 1 (pos)
	MOV X2, 0		// sum = 0
	MOV X4, 0		// index = 0
	MOV X6, #10		// X6 = 10, for multiplication

	// maximum min value / 10 = -922337203685477580 / 0xF333333333333334
	MOV  X5, #0x3334			// load last num
	MOVK X5, #0x3333, LSL #16	// load second to last
	MOVK X5, #0x3333, LSL #32	// load second to first
	MOVK X5, #0xF333, LSL #48	// load first

	// -----------------------------------------------------------------
	// CHECK SIGN	
	//	X1: stores sign. 0 = negative | 1 = positive
	// 	X3: current digit
	//  X4: index
	// -----------------------------------------------------------------
	LDR X3, [X0, X4]	// get first char
	CMP X3, #'-'		// check if first index is -
	B.NE doStrToInt		// jump if positive / X0 != '-'

	// IF NUMBER IS NEGATIVE
	MOV W1, 0			// change flag to negative (0)
	ADD X4, X4, #1		// index++

	// -----------------------------------------------------------------
	// CONVERT TO INTEGER
	//	X0: string array
	//	X2: sum 
	// 	X3: current digit
	//  X4: index
	//  X5: max minimum value
	//  X6: 10 because immediate values cannot be used for mult
	// -----------------------------------------------------------------
doStrToInt: 
	LDR X3, [X0, X4]	// get character
	CMP	X3, #0			// check if char is null / 0
	B.EQ checkSign		// if null go next step (check sign flag)

	// CONVERT TO INT
	SUB X3, X3, #'0'	// X3 = X3 - 30 (ASCII nums start at 30)
	NEG X3, X3			// X3 = -X3 / convert to neg (for neg loop)

	// CHECK FOR MULT OVERFLOW
	CMP  X2, X5			// -sum < max minimum value
	B.LT overflow		// branch if overflow
	MUL  X2, X2, X6		// if no overflow: -sum = -sum * 10

	// CHECK FOR ADDITION OVERFLOW
	ADDS X2, X2, X3		// -sum = -sum + -currentDigit
	B.VS overflow		// branch if overflow

	// INCREMENT NEXT INDEX
	ADD X4, X4, #1		// index = index + 1

	// REPEAT LOOP
	B doStrToInt

	// -----------------------------------------------------------------
	// CHECK SIGN FLAG - CONVERT TO POS IF OG NUM WAS POS
	//	X1: stores sign. 0 = negative | 1 = positive
	//	X2: sum / number
	// -----------------------------------------------------------------
checkSign:
	CMP  X1, #0		// sign == negative
	B.EQ end		// exit if negative / dont need to convert

	// SIGN IS POSTIVE
	NEG X2, X2		// make number positive
	B end

	// -----------------------------------------------------------------
	// OVERFLOW
	//	X2: sum
	// -----------------------------------------------------------------
overflow:
	MOV X2, #0	// change sum to be 0
	B end

end:
	// terminate the program 
	MOV X0, X2	// return X0 to main
	RET			// terminate

.end	// end of program, optional but good practice 