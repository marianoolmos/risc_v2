
    # Demo: 
    lui  x1, 0x1C3DC000
    addi x1, x1, 0xAFE
    sw   x1, 64(x0) 
    addi x2,  x0, 2
    addi x3,  x0, 8
    add  x9,  x3, x2
    
    sw   x9,  8(x3) 
    lbu  x4, 64(x0)

    
    