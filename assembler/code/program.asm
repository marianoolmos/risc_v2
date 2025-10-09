#XOR

    #lbu  x4, 64(x0)
    #jal  x20, 12 
    ##beq  x3, x4, +4
    

# ADD
    lui  x1, 0x1458B000
    addi x1, x1, 0xA13
    lui  x2, 0x08951000
    addi x2, x2, 0x0EB
    add  x3, x1, x2
    sw   x3, 4000(x0) 
# SUB
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x2582D000
    addi x1, x1, 0xBE9
    lui  x2, 0x08951000
    addi x2, x2, 0x0EB
    sub  x3, x1, x2   
    sw   x3, 4004(x0) 
# XOR
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x10101000
    addi x1, x1, 0x010
    lui  x2, 0x1CEDC000
    addi x2, x2, 0xAFE
    xor  x3, x1, x2
    xor  x3, x3, x1   
    sw   x3, 4008(x0) 
# OR
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x2, x0, 0xAFE
    or   x3, x1, x2
    sw   x3, 4012(x0) 
# AND
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0
    lui  x1, 0x1CEDC000
    addi x1, x1, 0xAFE
    lui  x2, 0xFFFFF000
    addi x2, x2, 0xFFF
    and  x3, x1, x2
    sw   x3, 4016(x0) 
# Shift Left Logical
    and  x1, x1, x0
    and  x2, x2, x0
    and  x3, x3, x0

    sw   x3, 4020(x0) 
# Shift Right Logical
    sw   x3, 4024(x0) 
# Shift Right Arith*
    sw   x3, 4028(x0) 
# Set Less Than
    sw   x3, 4032(x0) 
# Set Less Than (U)
    sw   x3, 4036(x0) 
# ADD Immediate
    sw   x3, 4040(x0) 
# XOR Immediate
    sw   x3, 4042(x0) 
# OR Immediate
    sw   x3, 4046(x0) 
# AND Immediate
    sw   x3, 4050(x0) 
# Shift Left Logical Imm
    sw   x3, 4054(x0) 
# Shift Right Logical Imm
    sw   x3, 4058(x0) 
# Shift Right Arith Imm
    sw   x3, 4062(x0) 
# Set Less Than Imm
    sw   x3, 4068(x0) 
# Set Less Than Imm (U)
    sw   x3, 4072(x0) 
# Load Byte
    sw   x3, 4076(x0) 
# Load Half
    sw   x3, 4080(x0) 
# Load Word
    sw   x3, 4082(x0) 
# Load Byte (U)
    sw   x3, 4086(x0) 
# Load Half (U)
    sw   x3, 4090(x0) 
# Store Byte
    sw   x3, 4092(x0) 
# Store Half
    sw   x3, 4096(x0) 
# Store Word

    lui  x1, 0x1C3DC000
    addi x1, x1, 0xAFE
    #sw   x1, 4100(x0) 
    #sh   x1, 4104(x0)
    #sb   x1, 4108(x0)

# Branch ==
    sw   x3, 4112(x0) 
# Branch !=
    sw   x3, 4116(x0) 
# Branch <
    sw   x3, 4120(x0) 
# Branch ≥
    sw   x3, 4124(x0) 
# Branch < (U)
    sw   x3, 4128(x0) 
# Branch ≥ (U)
    sw   x3, 4132(x0) 
# Jump And Link
    sw   x3, 4136(x0) 
# Jump And Link Reg
    sw   x3, 4140(x0) 
# Load Upper Imm
    sw   x3, 4144(x0) 
# Add Upper Imm to PC
    sw   x3, 4148(x0) 
# Environment Call
    sw   x3, 4152(x0) 
# Environment Break
    sw   x3, 4156(x0) 
    