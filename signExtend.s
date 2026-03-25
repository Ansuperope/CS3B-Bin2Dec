
// ---------------------------------------------------------------
// SIGN EXTEND (ONLY IF < 16 BITS)
//  X6: how many bits to extend
// ---------------------------------------------------------------
.global signExtend

signExtend:
    // 
    .text
    .EQU BIN_LEN,   17      // 16 bits + null
    

    // shift amount = 16 - bitCount
    MOV X6, BIN_LEN
    SUB X6, X6, X4

    // sign extend using shift trick
    LSL X7, X7, X6
    ASR X7, X7, X6

    RET

.end
