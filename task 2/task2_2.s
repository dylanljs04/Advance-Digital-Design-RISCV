        .text
        .globl _start

_start:
        lui t5, 0x80000      # t5 gets 0x7FFFF000
        addi t5, t5, 0xFFC    # t5 becomes 0x7FFFF000 + 0xFFC = 0x7FFFFFFC

        add t1, zero, zero            # initialise P to 0 
        add t2, zero,  zero            # initialise i to 0 
        addi t3, zero, 0            # initialise t3 to 0      
        addi t4, zero, 8            # initialise t4 to 8

        addi s0, zero, 3        # initialise s0 to 3
        addi s1, zero, 4        # initialise s1 to 4
loop1:
        andi t3, s1, 1        # check if the LSB of t0 is 1
        beq t3, zero, loop2  # if LSB is zero, jump to loop2
        add t1, t1, s0        # increment sum by 1

loop2:
        slli s0, s0 , 1        # left shift s0 by 1
        srli s1, s1, 1        # right shift t0 by 1
        addi t2, t2, 1        # increment i by 1
        bne t2, t4, loop1     # if i is not equal to 8, jump to loop1

        sw t1, 0(t5)        # Store sum in CPUOut

stop:
        # Instead of "j stop", use an infinite loop
        beq  zero, zero, stop  # Loop forever
