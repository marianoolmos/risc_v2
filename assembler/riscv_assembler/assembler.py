"""--====================================================================
--
--   /@@@@@@@  /@@@@@@  /@@@@@@   /@@@@@@        /@@    /@@  /@@@@@@
--  | @@__  @@|_  @@_/ /@@__  @@ /@@__  @@      | @@   | @@ /@@__  @@
--  | @@  \ @@  | @@  | @@  \__/| @@  \__/      | @@   | @@|__/  \ @@
--  | @@@@@@@/  | @@  |  @@@@@@ | @@            |  @@ / @@/  /@@@@@@/
--  | @@__  @@  | @@   \____  @@| @@             \  @@ @@/  /@@____/
--  | @@  \ @@  | @@   /@@  \ @@| @@    @@        \  @@@/  | @@
--  | @@  | @@ /@@@@@@|  @@@@@@/|  @@@@@@/         \  @/   | @@@@@@@@
--  |__/  |__/|______/ \______/  \______/           \_/    |________/
--
-- Description:
--
-- Author:       Mariano Olmos Martin
-- Mail  :       mariano.olmos@outlook.com
-- Date:         13/9/2025
-- Version:      v0.0
-- License: MIT License
--
-- Copyright (c) 2025 Mariano Olmos
--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this VHDL code and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject
-- to the following conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--======================================================================"""
from .opcodes import OPCODES
from .registers import parse_reg
from .utils import parse_imm, clean_line, split_args

class AssemblerError(Exception):
    pass
def sign_mask(val, bits):
    if val < 0:
        val = (1 << bits) + val
    return val & ((1 << bits) - 1)
def encode_R(funct7, rs2, rs1, funct3, rd, opcode):
    return ((funct7 & 0x7F) << 25) | ((rs2 & 0x1F) << 20) | ((rs1 & 0x1F) << 15) | ((funct3 & 0x7) << 12) | ((rd & 0x1F) << 7) | (opcode & 0x7F)
def encode_I(imm, rs1, funct3, rd, opcode, shamt_width=5, has_funct7=False, funct7=0):
    imm = sign_mask(imm, 12)
    return ((imm & 0xFFF) << 20) | ((rs1 & 0x1F) << 15) | ((funct3 & 0x7) << 12) | ((rd & 0x1F) << 7) | (opcode & 0x7F)
def encode_S(imm, rs2, rs1, funct3, opcode):
    imm = sign_mask(imm, 12)
    imm11_5 = (imm >> 5) & 0x7F
    imm4_0 = imm & 0x1F
    return (imm11_5 << 25) | ((rs2 & 0x1F) << 20) | ((rs1 & 0x1F) << 15) | ((funct3 & 0x7) << 12) | (imm4_0 << 7) | (opcode & 0x7F)
def encode_B(off, rs2, rs1, funct3, opcode):
    off = sign_mask(off, 13)
    b12 = (off >> 12) & 0x1
    b10_5 = (off >> 5) & 0x3F
    b4_1 = (off >> 1) & 0xF
    b11 = (off >> 11) & 0x1
    return (b12 << 31) | (b10_5 << 25) | ((rs2 & 0x1F) << 20) | ((rs1 & 0x1F) << 15) | ((funct3 & 0x7) << 12) | (b4_1 << 8) | (b11 << 7) | (opcode & 0x7F)
def encode_U(imm, rd, opcode):
    imm = sign_mask(imm, 32)
    return ((imm & 0xFFFFF000)) | ((rd & 0x1F) << 7) | (opcode & 0x7F)
def encode_J(off, rd, opcode):
    off = sign_mask(off, 21)
    b20 = (off >> 20) & 0x1
    b10_1 = (off >> 1) & 0x3FF
    b11 = (off >> 11) & 0x1
    b19_12 = (off >> 12) & 0xFF
    return (b20 << 31) | (b19_12 << 12) | (b11 << 20) | (b10_1 << 21) | ((rd & 0x1F) << 7) | (opcode & 0x7F)
def parse_mem_operand(op):
    if '(' in op and op.endswith(')'):
        imm_str, rs1_str = op.split('(')
        rs1_str = rs1_str[:-1]
        return parse_imm(imm_str), parse_reg(rs1_str)
    raise AssemblerError(f"Operando de memoria inválido: {op} (usa formato imm(rs1))")
def assemble_lines(lines, base_address=0):
    pc = base_address
    cleaned = []
    labels = {}
    for raw in lines:
        line = clean_line(raw)
        if not line:
            continue
        while ':' in line:
            label, rest = line.split(':',1)
            label = label.strip()
            if not label:
                break
            labels[label] = pc
            line = rest.strip()
        if not line:
            continue
        cleaned.append((pc, line))
        pc += 4
    machine = []
    for pc, line in cleaned:
        if ' ' in line:
            mnemonic, argstr = line.split(None,1)
            args = split_args(argstr)
        else:
            mnemonic, args = line, []
        m = mnemonic.lower()
        if m not in OPCODES:
            raise AssemblerError(f"Instrucción no soportada: {mnemonic}")
        spec = OPCODES[m]; t = spec["type"]
        if t == "R":
            rd, rs1, rs2 = [parse_reg(a) for a in args]
            inst = encode_R(spec["funct7"], rs2, rs1, spec["funct3"], rd, spec["opcode"])
        elif t == "I":
            if m in ("lb","lh","lw","lbu","lhu"):
                rd = parse_reg(args[0]); imm, rs1 = parse_mem_operand(args[1])
                inst = encode_I(imm, rs1, spec["funct3"], rd, spec["opcode"])
            elif m in ("slli","srli","srai"):
                rd = parse_reg(args[0]); rs1 = parse_reg(args[1]); shamt = parse_imm(args[2])
                funct7 = spec.get("funct7",0)
                inst = ((funct7 & 0x7F) << 25) | ((shamt & 0x1F) << 20) | ((rs1 & 0x1F) << 15) | ((spec["funct3"] & 0x7) << 12) | ((rd & 0x1F) << 7) | (spec["opcode"] & 0x7F)
            elif m == "jalr":
                rd = parse_reg(args[0])
            
                if len(args) == 2 and '(' in args[1]:
                    # jalr rd, imm(rs1)
                    imm, rs1 = parse_mem_operand(args[1])
            
                elif len(args) == 3:
                    # Acepta:
                    #   - jalr rd, imm, rs1
                    #   - jalr rd, rs1, imm  (estilo GNU)
                    a1, a2 = args[1], args[2]
                    # Si el segundo parece registro, interpretamos rd, rs1, imm
                    try:
                        rs1_candidate = parse_reg(a1)
                        imm_candidate = parse_imm(a2)
                        rs1, imm = rs1_candidate, imm_candidate
                    except Exception:
                        # si no, probamos rd, imm, rs1
                        imm = parse_imm(a1)
                        rs1 = parse_reg(a2)
                else:
                    # fallback: rd, imm, rs1
                    imm = parse_imm(args[1])
                    rs1 = parse_reg(args[2])
            
                inst = encode_I(imm, rs1, spec["funct3"], rd, spec["opcode"])

            else:
                rd = parse_reg(args[0]); rs1 = parse_reg(args[1]); imm = parse_imm(args[2])
                inst = encode_I(imm, rs1, spec["funct3"], rd, spec["opcode"])
        elif t == "S":
            rs2 = parse_reg(args[0]); imm, rs1 = parse_mem_operand(args[1])
            inst = encode_S(imm, rs2, rs1, spec["funct3"], spec["opcode"])
        elif t == "B":
            rs1 = parse_reg(args[0]); rs2 = parse_reg(args[1]); target = args[2]
            if target in labels:
                off = labels[target] - pc
            else:
                off = parse_imm(target)
            inst = encode_B(off, rs2, rs1, spec["funct3"], spec["opcode"])
        elif t == "U":
            rd = parse_reg(args[0]); imm = parse_imm(args[1])
            inst = encode_U(imm, rd, spec["opcode"])
        elif t == "J":
            rd = parse_reg(args[0]); target = args[1]
            if target in labels:
                off = labels[target] - pc
            else:
                off = parse_imm(target)
            inst = encode_J(off, rd, spec["opcode"])
        else:
            raise AssemblerError(f"Tipo desconocido: {t}")
        machine.append(inst & 0xFFFFFFFF)
    return machine, labels
def write_hex(words, out_path, pad_words=None, fill_value=0):
    with open(out_path, "w") as f:
        for w in words:
            f.write(f"{w:08X}\n")
        if pad_words is not None and pad_words > len(words):
            for _ in range(pad_words - len(words)):
                f.write(f"{fill_value & 0xFFFFFFFF:08X}\n")
