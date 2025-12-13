# RISC-V Assembly - Todas las operaciones producen 0x1CEDCAFE

# ADD - 0x1458BA13 + 0x089510EB = 0x1CEDCAFE
    lui  x1, 0x1458B000
    addi x1, x1, 0xA13
    lui  x2, 0x08951000
    addi x2, x2, 0x0EB
    add  x3, x1, x2
    # dir = 0x0FA0 (4000)
    addi x8, x0, 0x0FA0
    sw   x3, 0(x8)

# SUB - 0x2582DBE9 - 0x089510EB = 0x1CEDCAFE
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x2582D000
    addi x1, x1, 0xBE9
    lui  x2, 0x08951000
    addi x2, x2, 0x0EB
    sub  x3, x1, x2
    # dir = 0x0FA4 (4004)
    addi x8, x0, 0x0FA4
    sw   x3, 0(x8)

# XOR - 0x10101010 XOR 0x0C3C36EE XOR 0x10101010 = 0x1CEDCAFE
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x10101000
    addi x1, x1, 0x010
    lui  x2, 0x1CEDC000
    addi x2, x2, 0xAFE
    xor  x3, x1, x2
    xor  x3, x3, x1
    # dir = 0x0FA8 (4008)
    addi x8, x0, 0x0FA8
    sw   x3, 0(x8)

# OR - 0x1CEDC000 OR 0xAFE = 0x1CEDCAFE
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x2, x0, 0xAFE
    or   x3, x1, x2
    # dir = 0x0FAC (4012)
    addi x8, x0, 0x0FAC
    sw   x3, 0(x8)

# AND - 0x1CEDCAFE AND 0xFFFFFFFF = 0x1CEDCAFE
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    lui  x2, 0xFFFFF000
    addi x2, x2, 0xFFF
    and  x3, x1, x2
    # dir = 0x0FB0 (4016)
    addi x8, x0, 0x0FB0
    sw   x3, 0(x8)

# Shift Left Logical - mantener 0x1CEDCAFE
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    addi x2, x0, 0
    sll  x3, x1, x2
    # dir = 0x0FB4 (4020)
    addi x8, x0, 0x0FB4
    sw   x3, 0(x8)

# Shift Right Logical - mantener 0x1CEDCAFE
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    addi x2, x0, 0
    srl  x3, x1, x2
    # dir = 0x0FB8 (4024)
    addi x8, x0, 0x0FB8
    sw   x3, 0(x8)

# Shift Right Arithmetic - mantener 0x1CEDCAFE
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    addi x2, x0, 0
    sra  x3, x1, x2
    # dir = 0x0FBC (4028)
    addi x8, x0, 0x0FBC
    sw   x3, 0(x8)

# Set Less Than - resultado 0, guardar X3
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
    addi x1, x0, 10
    addi x2, x0, 5
    slt  x4, x1, x2
    # dir = 0x0FC0 (4032)
    addi x8, x0, 0x0FC0
    sw   x3, 0(x8)

# Set Less Than (U) - resultado 0, guardar X3
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
    addi x1, x0, 10
    addi x2, x0, 5
    sltu x4, x1, x2
    # dir = 0x0FC4 (4036)
    addi x8, x0, 0x0FC4
    sw   x3, 0(x8)

# ADD Immediate - 0x1CEDC000 + 0xAFE = 0x1CEDCAFE
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x3, x1, 0xAFE
    # dir = 0x0FC8 (4040)
    addi x8, x0, 0x0FC8
    sw   x3, 0(x8)

# XOR Immediate - ejemplo
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    ori  x1, x1, 0x9FE
    xori x3, x1, 0x500
    # dir = 0x0FCC (4044)
    addi x8, x0, 0x0FCC
    sw   x3, 0(x8)

# OR Immediate - 0x1CEDC000 OR 0xAFE = 0x1CEDCAFE
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    ori  x3, x1, 0xAFE
    # dir = 0x0FD0 (4048)
    addi x8, x0, 0x0FD0
    sw   x3, 0(x8)

# AND Immediate - mantener valor completo
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    andi x3, x1, 0x7FF
    or   x3, x3, x1
    # dir = 0x0FD4 (4052)
    addi x8, x0, 0x0FD4
    sw   x3, 0(x8)

# SLLI - shift 0
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    slli x3, x1, 0
    # dir = 0x0FD8 (4056)
    addi x8, x0, 0x0FD8
    sw   x3, 0(x8)

# SRLI - shift 0
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    and  x8, x8, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    srli x3, x1, 0
    # dir = 0x0FDC (4060)
    addi x8, x0, 0x0FDC
    sw   x3, 0(x8)

# SRAI - shift 0
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    srai x3, x1, 0
    # dir = 0x0FE0 (4064)
    addi x8, x0, 0x0FE0
    sw   x3, 0(x8)

# SLTI - resultado 0, guardar X3
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
    addi x1, x0, 10
    slti x4, x1, 5
    # dir = 0x0FE4 (4068)
    addi x8, x0, 0x0FE4
    sw   x3, 0(x8)

# SLTIU - resultado 0, guardar X3
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
    addi x1, x0, 10
    sltiu x4, x1, 5
    # dir = 0x0FE8 (4072)
    addi x8, x0, 0x0FE8
    sw   x3, 0(x8)

# Load Byte - guardar resultado final
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    sw   x1, 8000(x0)
    lb   x4, 8000(x0)
    and  x3, x3, x0
    or   x3, x3, x1
    # dir = 0x0FEC (4076)
    addi x8, x0, 0x0FEC
    sw   x3, 0(x8)

# Load Half - guardar resultado final
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    sw   x1, 8004(x0)
    lh   x4, 8004(x0)
    and  x3, x3, x0
    or   x3, x3, x1
    # dir = 0x0FF0 (4080)
    addi x8, x0, 0xFF0
    sw   x3, 0(x8)

# Load Word - guardar resultado final
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    and  x8, x8, x0
    lui  x8, 0x00001000
    addi x8, x8, 0xF48
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    sw   x1, 0(x8)
    and  x1, x1, x0
    lw   x1, 0(x8)
    #dir = 0x0FF4 (4084)
    and  x8, x8, x0
    addi x8, x0, 0xFF4
    sw   x1, 0(x8)

# Load Byte (U) - guardar resultado final
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    sw   x1, 8012(x0)
    lbu  x4, 8012(x0)
    and  x3, x3, x0
    or   x3, x3, x1
    # dir = 0x0FF8 (4088)
    addi x8, x0, 0xFF8
    sw   x3, 0(x8)

# Load Half (U) - guardar resultado final
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    sw   x1, 8016(x0)
    lhu  x4, 8016(x0)
    and  x3, x3, x0
    or   x3, x3, x1
    # dir = 0x0FFC (4092)
    addi x8, x0, 0x0FFC
    sw   x3, 0(x8)

# Store Byte - guardar resultado final
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    sb   x1, 68(x0)
    add  x3, x1, x0
    # dir = 0x1000 (4096)
    lui  x8, 0x00001000
    addi x8, x8, 0x000
    sw   x3, 0(x8)

# Store Half - guardar resultado final
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    sh   x1, 72(x0)
    add  x3, x1, x0
    # dir = 0x1004 (4100)
    lui  x8, 0x00001000
    addi x8, x8, 0x004
    sw   x3, 0(x8)

# Store Word - guardar resultado final
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    sw   x1, 76(x0)
    add  x3, x1, x0
    # dir = 0x1008 (4104)
    lui  x8, 0x00001000
    addi x8, x8, 0x008
    sw   x3, 0(x8)

# Branch ==
    and   x1, x1, x0
    and   x2, x2, x0
    and   x3, x3, x0
    addi  x1, x0, 5
    addi  x2, x0, 5
    lui   x3, 0x1CEDC000
    addi  x3, x3, 0xAFE
    beq   x1, x2, beq_skip
    lui   x3, 0xFFFFF000
    addi  x3, x3, 0xFFF
beq_skip:
    lui   x8, 0x00001000
    addi  x8, x8, 0x00C
    sw    x3, 0(x8)

# Branch !=
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    addi x1, x0, 5
    addi x2, x0, 3
    beq  x1, x2, bne_skip
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
bne_skip:
    # dir = 0x1010 (4112)
    lui  x8, 0x00001000
    addi x8, x8, 0x010
    sw   x3, 0(x8)

# Branch <
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    addi x1, x0, 3
    addi x2, x0, 5
    bge  x1, x2, blt_skip
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
blt_skip:
    # dir = 0x1014 (4116)
    lui  x8, 0x00001000
    addi x8, x8, 0x014
    sw   x3, 0(x8)

# Branch ≥
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    addi x1, x0, 5
    addi x2, x0, 3
    blt  x1, x2, bge_skip
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
bge_skip:
    # dir = 0x1018 (4120)
    lui  x8, 0x00001000
    addi x8, x8, 0x018
    sw   x3, 0(x8)

# Branch < (U)
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    addi x1, x0, 3
    addi x2, x0, 5
    bgeu x1, x2, bltu_skip
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
bltu_skip:
    # dir = 0x101C (4124)
    lui  x8, 0x00001000
    addi x8, x8, 0x01C
    sw   x3, 0(x8)

# Branch ≥ (U)
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    addi x1, x0, 5
    addi x2, x0, 3
    bltu x1, x2, bgeu_skip
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
bgeu_skip:
    # dir = 0x1020 (4128)
    lui  x8, 0x00001000
    addi x8, x8, 0x020
    sw   x3, 0(x8)

# Jump And Link
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    and  x8, x8, x0
    addi x10, x0, 0xBEF
    addi x11, x0, 0xBEF
    addi x12, x0, 0xBEF
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
    jal  x1, jal_skip
    lui  x3, 0xFFFFF000
    addi x3, x3, 0xFFF
jal_skip:
    # dir = 0x1024 (4132)
    lui  x8, 0x00001000
    addi x8, x8, 0x024
    sw   x3, 0(x8)

# Jump And Link Reg
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    auipc x1, 0
    addi x1, x1, 12
    jalr x2, x1, 0
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
    # dir = 0x1028 (4136)
    lui  x8, 0x00001000
    addi x8, x8, 0x028
    sw   x3, 0(x8)

 # Load Upper Imm dir = 0x102C (4140)
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    and  x8, x8, x0
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
    lui  x8, 0x00001000
    addi x8, x8, 0x02C
    sw   x3, 0(x8)

# Add Upper Imm to PC
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x3, 0x1CEDC000
    addi x3, x3, 0xAFE
    # dir = 0x1030 (4144)
    lui  x8, 0x00001000
    addi x8, x8, 0x030
    sw   x3, 0(x8)
