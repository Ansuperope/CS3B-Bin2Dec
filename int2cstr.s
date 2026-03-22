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
.global int2cstr

int2cstr:

    .text

    // -----------------------------------------------------------------
    // CONVERT BINARY NUMBER TO 16-BIT BINARY STRING
    // X0: binary number (16-bit, sign-extended)
    // X1: output buffer pointer
    // Returns: X0 = pointer to output buffer
    // Output format: "XXXXXXXXXXXXXXXX\0" (16 bits, no spaces)
    // -----------------------------------------------------------------
    MOV X5, #0          // output character index
    MOV X6, #15         // start from bit 15 (MSB)

    // -----------------------------------------------------------------
    // STEP 1 - OUTPUT ALL 16 BITS WITH SPACES EVERY 4 BITS
    // -----------------------------------------------------------------
bitLoop:
    // Extract the bit at position X6
    LSR X3, X0, X6      // shift right by bit position
    AND X3, X3, #1      // mask to get only that bit

    // convert bit to ASCII '0' or '1'
    ADD X3, X3, #'0'
    STRB W3, [X1, X5]
    ADD X5, X5, #1

    // move to next bit
    SUB X6, X6, #1

    // Continue loop
    CMP X6, #-1
    B.NE bitLoop
    B addNull

    // -----------------------------------------------------------------
    // STEP 2 - ADD NULL TERMINATOR
    // -----------------------------------------------------------------
addNull:
    MOV W3, #0
    STRB W3, [X1, X5]

    // -----------------------------------------------------------------
    // DONE
    // -----------------------------------------------------------------
done:
    MOV X0, X1      // return pointer
    RET

.end
