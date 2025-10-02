
# RISC-V Assembler (RV32I) en Python

Ensamblador sencillo para un subconjunto de **RV32I** que genera archivos `init_file.hex` con **32 bits por línea en hexadecimal**.

## Uso rápido

```bash
python -m riscv_assembler.cli -i examples/demo.asm -o init_file.hex --pad-words 26 --fill 0x00000000
```

Mira la ayuda:
```bash
python -m riscv_assembler.cli -h
```

## Formato del archivo de salida

Cada línea es una palabra de 32 bits en hexadecimal (8 dígitos, mayúsculas), por ejemplo:

```
00000000
00400093
...
```

## Instrucciones soportadas

RV32I básico: R (add, sub, sll, slt, sltu, xor, srl, sra, or, and),
I (addi, xori, ori, andi, slli, srli, srai, lb, lh, lw, lbu, lhu, jalr),
S (sb, sh, sw),
B (beq, bne, blt, bge, bltu, bgeu),
U (lui, auipc),
J (jal).

## Labels

El ensamblador hace dos pasadas y resuelve labels (`mi_label:`) automáticamente en ramas/jumps.

## Ejemplo

`examples/demo.asm` carga una constante, incrementa un contador y hace un bucle.

