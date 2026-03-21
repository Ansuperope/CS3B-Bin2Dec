// Aspen Cristobal
// CS3B - lab5-2 int2cstr function
// 2/7/2026
// Converts a signed integer to a null-terminated C-string
//
// Algorithm/Pseudocode:
//
//   1. Save the number in a register
//   2. Check if number is negative
//   3. If negative, save sign and make positive
//   4. Extract digits from right to left using division by 10
//   5. Store each digit as ASCII in the output buffer
//   6. Add minus sign at the beginning if needed
//   7. Add null terminator at the end
//   8. Return to caller
//
//********************************************************************
//int2cstr
//  Function int2cstr: Provided a signed integer, will convert it to 
//  a C-String stored in memory pointed to by a provided pointer
//  X0: Contains the binary (signed) value to be converted
//  X1: Must point to address large enough to hold the converted value
//  LR: Must contain the return address (automatic when BL is used)
//  All registers except X0, X1, and X2 are preserved
//********************************************************************

.global int2cstr

int2cstr:

    .text

    MOV     X2, X0          // X2 = number to convert
    MOV     X3, X1          // X3 = output buffer pointer
    MOV     X4, #0          // X4 = negative flag (0 = positive, 1 = negative)
    MOV     X5, #0          // X5 = digit count
    
    CMP     X2, #0          // Check if number is 0 or negative
    B.GE    check_zero      // If >= 0, go to check if zero
    
    MOV     X4, #1          // Set negative flag = 1
    NEG     X2, X2          // Make number positive
    
check_zero:
    CMP     X2, #0          // Check if number is 0
    B.NE    digit_loop      // If not 0, go to digit extraction
    
    MOV     W6, #0x30       // ASCII code for '0'
    STRB    W6, [X3]        // Store '0' in buffer
    ADD     X3, X3, #1      // Move pointer forward
    MOV     W6, #0          // ASCII code for null terminator
    STRB    W6, [X3]        // Store null terminator
    RET                     // Return early
    
digit_loop:
    CMP     X2, #0          // Check if number is 0 (all digits extracted)
    B.EQ    add_sign        // If 0, go add minus sign if needed
    
    MOV     X6, #10         // X6 = 10
    UDIV    X7, X2, X6      // X7 = X2 / 10 quotient
    MUL     X8, X7, X6      // X8 = X7 * 10
    SUB     X9, X2, X8      // X9 = X2 - X8 remainder is the digit
    
    ADD     X9, X9, #0x30   // Convert the digit to ASCII
    STRB    W9, [X3, X5]    // Store the digit in buffer
    ADD     X5, X5, #1      // Increment the digit counter
    
    MOV     X2, X7          // X2 = quotient 
    B       digit_loop      // Loop back for next digit
    
add_sign:
    CMP     X4, #1          // Check if negative flag is set
    B.NE    reverse_digits  // If not negative, skip minus sign
    
    MOV     W6, #0x2d       // ASCII code for '-' sign
    STRB    W6, [X3, X5]    // Store '-' sign at end of the digits
    ADD     X5, X5, #1      // Increment digit counter
    
reverse_digits:
    MOV     X6, #0          // X6 = left index
    MOV     X7, X5          // X7 = right index
    SUB     X7, X7, #1      // X7 = right index - 1
    
reverse_loop:
    CMP     X6, X7          // Check if indices crossed
    B.GE    done            // If left greater that right, done reversing
    
    LDRB    W8, [X3, X6]    // Load character at the left
    LDRB    W9, [X3, X7]    // Load character at the right
    
    STRB    W9, [X3, X6]    // Store right character at left
    STRB    W8, [X3, X7]    // Store left character at right
    
    ADD     X6, X6, #1      // Move the left index forward
    SUB     X7, X7, #1      // Move the right index backward
    B       reverse_loop    // Continue reversing
    
done:
    MOV     W6, #0          // Null terminator
    STRB    W6, [X3, X5]    // Store null terminator at end
    
    RET                     // Return to caller
.end // End of program
