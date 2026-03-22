// *********************************************************************
// Aspen Cristobal
// CS3b - lab-LOREM_NUM - LOREM_ASSIGN
// mm/dd/2026
// ---------------------------------------------------------------------
// 	PURPOSE:
// Provided a signed integer, will convert it to a C-String 
// stored stored in memory pointed to by a provided pointer
// that must be large enough to hold the converted value. 
// Usually a string of 21 bytes is more than sufficient to allow  
// for a sign as well as the largest possible value a word could be.
// ---------------------------------------------------------------------
//	VARAIBLES:
// X0: Contains the binary (signed) value to be converted to a C-String
//	   Will be used to store final result
// X1: Must point to address large enough to hold the converted value.
// LR: Contains the return address (automatic when BL is used)
// Registers X0 - X8 are modified and not preserved
// ---------------------------------------------------------------------
// 	PSUEDOCODE:
// 1. Check if number is negative or positive
// 2. Get the digits of the number and store in array (using negative loop)
// 3. Add a negative sign (if applicable)
// 4. Add null terminator
// 5. Flip array to be in correct order
// 6. Send and return to main
// *********************************************************************
.global toDec

toDec:

    .text

    // -------------------------------------------------
    // INITIALIZATION
    // -------------------------------------------------
    MOV X5, #0          // index = 0
    MOV X6, #10         // divisor = 10
    MOV X2, #0          // sign flag (0 = positive, 1 = negative)

    // -------------------------------------------------
    // STEP 1 - CHECK IF POS OR NEG
    // -------------------------------------------------
    CMP X0, #0
    B.GE digitLoop      // if >= 0 → skip

    // number is negative
    MOV X2, #1          // mark negative
    NEG X0, X0          // make positive

// -------------------------------------------------
// STEP 2 - EXTRACT DIGITS
// -------------------------------------------------
digitLoop:

    // quotient = number / 10
    UDIV X3, X0, X6

    // remainder = number - (quotient * 10)
    MUL X4, X3, X6
    SUB X4, X0, X4

    // convert remainder to ASCII
    ADD X4, X4, #'0'

    // store digit (backwards)
    STRB W4, [X1, X5]

    // update number
    MOV X0, X3

    // increment index
    ADD X5, X5, #1

    // loop until number == 0
    CMP X0, #0
    B.NE digitLoop

// -------------------------------------------------
// STEP 3 - ADD NEGATIVE SIGN (if needed)
// -------------------------------------------------
    CMP X2, #1
    B.NE addNull

    MOV W4, #'-'
    STRB W4, [X1, X5]
    ADD X5, X5, #1

// -------------------------------------------------
// STEP 4 - ADD NULL TERMINATOR
// -------------------------------------------------
addNull:
    MOV W6, #0
    STRB W6, [X1, X5]

// -------------------------------------------------
// STEP 5 - REVERSE STRING
// -------------------------------------------------
    MOV X6, #0          // left index
    SUB X7, X5, #1      // right index (before null)

reverseLoop:

    CMP X6, X7
    B.GE done

    // load left and right chars
    LDRB W3, [X1, X6]
    LDRB W4, [X1, X7]

    // swap
    STRB W4, [X1, X6]
    STRB W3, [X1, X7]

    // move indices
    ADD X6, X6, #1
    SUB X7, X7, #1

    B reverseLoop

// -------------------------------------------------
// DONE
// -------------------------------------------------
done:
    MOV X0, X1      // return pointer
    RET

.end