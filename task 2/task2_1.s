        .text
        .globl _start

_start:
        # Load CPUIn address (0x7FFFFFFC) using lui and addi
        lui     t0, 0x7FFFF       # Upper 20 bits of 0x7FFFFFFC
        addi    t0, t0, 0xFF4     # Lower 12 bits (0xFFC) to form 0x7FFFFFFC

        # Load CPUIn value from memory
        lw      t1, 0(t0)         # Load CPUIn into t1

        # Initialize sum = 0
        lui     t2, 0             # Set sum (t2) upper 20 bits to 0
        addi    t2, t2, 0         # Set sum (t2) lower 12 bits to 0

        # Initialize i = 0
        lui     t3, 0             # Set i (t3) upper 20 bits to 0
        addi    t3, t3, 0         # Set i (t3) lower 12 bits to 0

loop:
        # Compare i == 8 (Exit Condition)
        lui     t4, 0             # Load upper 20 bits of 8
        addi    t4, t4, 8         # Load lower 12 bits of 8
        beq     t3, t4, done      # if (i == 8) exit loop

        # Check LSB of t1 (a[0])
        andi    t5, t1, 1         # t5 = a & 1 (Extract LSB)
        beq     t5, zero, skip    # If LSB is 0, skip incrementing sum
        addi    t2, t2, 1         # sum = sum + 1

skip:
        # Right shift a (t1) by 1 bit
        srai    t1, t1, 1         # a >>= 1

        # Increment i
        addi    t3, t3, 1         # i++

        # Instead of "j loop", use bne to branch back
        bne     t3, t4, loop      # if (i != 8) go back to loop

done:
        # Store sum back to 0x7FFFFFFC as CPUOut
        sw      t2, 0(t0)         # Store sum in CPUOut

stop:
        # Instead of "j stop", use an infinite loop
        beq     zero, zero, stop  # Loop forever
