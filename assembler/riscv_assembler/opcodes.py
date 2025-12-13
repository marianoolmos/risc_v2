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
OPCODES = {
    "add":  {"type":"R","opcode":0b0110011,"funct3":0b000,"funct7":0b0000000},
    "sub":  {"type":"R","opcode":0b0110011,"funct3":0b000,"funct7":0b0100000},
    "sll":  {"type":"R","opcode":0b0110011,"funct3":0b001,"funct7":0b0000000},
    "slt":  {"type":"R","opcode":0b0110011,"funct3":0b010,"funct7":0b0000000},
    "sltu": {"type":"R","opcode":0b0110011,"funct3":0b011,"funct7":0b0000000},
    "xor":  {"type":"R","opcode":0b0110011,"funct3":0b100,"funct7":0b0000000},
    "srl":  {"type":"R","opcode":0b0110011,"funct3":0b101,"funct7":0b0000000},
    "sra":  {"type":"R","opcode":0b0110011,"funct3":0b101,"funct7":0b0100000},
    "or":   {"type":"R","opcode":0b0110011,"funct3":0b110,"funct7":0b0000000},
    "and":  {"type":"R","opcode":0b0110011,"funct3":0b111,"funct7":0b0000000},
    "addi": {"type":"I","opcode":0b0010011,"funct3":0b000},
    "xori": {"type":"I","opcode":0b0010011,"funct3":0b100},
    "ori":  {"type":"I","opcode":0b0010011,"funct3":0b110},
    "andi": {"type":"I","opcode":0b0010011,"funct3":0b111},
    "slli": {"type":"I","opcode":0b0010011,"funct3":0b001,"funct7":0b0000000},
    "srli": {"type":"I","opcode":0b0010011,"funct3":0b101,"funct7":0b0000000},
    "srai": {"type":"I","opcode":0b0010011,"funct3":0b101,"funct7":0b0100000},
    "slti":  {"type":"I","opcode":0b0010011,"funct3":0b010},
    "sltiu": {"type":"I","opcode":0b0010011,"funct3":0b011},
    "lb":   {"type":"I","opcode":0b0000011,"funct3":0b000},
    "lh":   {"type":"I","opcode":0b0000011,"funct3":0b001},
    "lw":   {"type":"I","opcode":0b0000011,"funct3":0b010},
    "lbu":  {"type":"I","opcode":0b0000011,"funct3":0b100},
    "lhu":  {"type":"I","opcode":0b0000011,"funct3":0b101},
    "jalr": {"type":"I","opcode":0b1100111,"funct3":0b000},
    "sb":   {"type":"S","opcode":0b0100011,"funct3":0b000},
    "sh":   {"type":"S","opcode":0b0100011,"funct3":0b001},
    "sw":   {"type":"S","opcode":0b0100011,"funct3":0b010},
    "beq":  {"type":"B","opcode":0b1100011,"funct3":0b000},
    "bne":  {"type":"B","opcode":0b1100011,"funct3":0b001},
    "blt":  {"type":"B","opcode":0b1100011,"funct3":0b100},
    "bge":  {"type":"B","opcode":0b1100011,"funct3":0b101},
    "bltu": {"type":"B","opcode":0b1100011,"funct3":0b110},
    "bgeu": {"type":"B","opcode":0b1100011,"funct3":0b111},
    "lui":   {"type":"U","opcode":0b0110111},
    "auipc": {"type":"U","opcode":0b0010111},
    "jal":   {"type":"J","opcode":0b1101111},
}
