 --====================================================================
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
-- Module:       RISC_V2_INSTR_SET_PKG
-- Description:  
--
-- Author:       Mariano Olmos Martin 
-- Mail  :       mariano.olmos@outlook.com
-- Date:         27/9/2025
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
--======================================================================
 
 library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;

package risc_v2_instr_set_pkg is
 --Operation Codes (6 downto 0)
  --***************
  subtype opcode_t is std_logic_vector(6 downto 0);
  subtype funct3_t is std_logic_vector(2 downto 0);
  subtype funct7_t is std_logic_vector(6 downto 0);

  constant OPC_OP       : opcode_t := "0110011"; -- R
  constant OPC_OP_IMM   : opcode_t := "0010011"; -- I (ALU immed)
  constant OPC_LOAD     : opcode_t := "0000011"; -- I (loads)
  constant OPC_STORE    : opcode_t := "0100011"; -- S
  constant OPC_BRANCH   : opcode_t := "1100011"; -- B
  constant OPC_LUI      : opcode_t := "0110111"; -- U
  constant OPC_AUIPC    : opcode_t := "0010111"; -- U
  constant OPC_JAL      : opcode_t := "1101111"; -- J
  constant OPC_JALR     : opcode_t := "1100111"; -- I (jump reg)
  constant OPC_SYSTEM   : opcode_t := "1110011"; -- I (CSR/ECALL/EBREAK)
  constant OPC_FENCE    : opcode_t := "0001111"; -- I (misc-mem)

  -- FUNCT3 (14 downto 12)
  --**********************

  -- ALU (R/OP e I/OP-IMM)
  constant F3_ADD_SUB_XORI_ADDI    : funct3_t := "000";
  constant F3_SLL_SLLI             : funct3_t := "001";
  constant F3_SLT_SLTI             : funct3_t := "010";
  constant F3_SLTU_SLTIU           : funct3_t := "011";
  constant F3_XOR_XORI             : funct3_t := "100";
  constant F3_SRL_SRA_SRLI_SRAI    : funct3_t := "101";
  constant F3_OR_ORI               : funct3_t := "110";
  constant F3_AND_ANDI             : funct3_t := "111";
  -- LOAD
  constant F3_LB   : funct3_t := "000";
  constant F3_LH   : funct3_t := "001";
  constant F3_LW   : funct3_t := "010";
  constant F3_LBU  : funct3_t := "100";
  constant F3_LHU  : funct3_t := "101";
  -- STORE
  constant F3_SB   : funct3_t := "000";
  constant F3_SH   : funct3_t := "001";
  constant F3_SW   : funct3_t := "010";
  -- BRANCH
  constant F3_BEQ  : funct3_t := "000";
  constant F3_BNE  : funct3_t := "001";
  constant F3_BLT  : funct3_t := "100";
  constant F3_BGE  : funct3_t := "101";
  constant F3_BLTU : funct3_t := "110";
  constant F3_BGEU : funct3_t := "111";
  -- SYSTEM (ECALL/EBREAK/CSR)
  constant F3_PRIV_CSRRW : funct3_t := "000"; -- ECALL/EBREAK/URET/SRET/WFI si rs1/rd=0 e imm especial
  constant F3_CSRRW      : funct3_t := "001";
  constant F3_CSRRS      : funct3_t := "010";
  constant F3_CSRRC      : funct3_t := "011";
  constant F3_CSRRWI     : funct3_t := "101";
  constant F3_CSRRSI     : funct3_t := "110";
  constant F3_CSRRCI     : funct3_t := "111";

  -- FUNCT7 (31 downto 25)
  --**********************
  constant F7_STD : funct7_t := "0000000"; -- operaciones “normales” (ADD, SLL, SLT, SLTU, XOR, SRL, OR, AND)
  constant F7_ALT : funct7_t := "0100000"; -- SUB y SRA (y SRAI en OP-IMM)
  -- Extension M (multiplicación/división)
  constant F7_M   : funct7_t := "0000001"; -- MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU
   
end package;
 