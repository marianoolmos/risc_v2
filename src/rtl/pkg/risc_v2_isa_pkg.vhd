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
-- Module:       risc_v2_isa_pkg
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

package risc_v2_isa_pkg is

  -- Operation Codes (6 downto 0)
  -- ***************

  subtype t_opcode is std_logic_vector(6 downto 0);

  subtype t_funct3 is std_logic_vector(2 downto 0);

  subtype t_funct7 is std_logic_vector(6 downto 0);

  constant OPC_OP     : t_opcode := "0110011"; -- R
  constant OPC_OP_IMM : t_opcode := "0010011"; -- I (ALU immed)
  constant OPC_LOAD   : t_opcode := "0000011"; -- I (loads)
  constant OPC_STORE  : t_opcode := "0100011"; -- S
  constant OPC_BRANCH : t_opcode := "1100011"; -- B
  constant OPC_LUI    : t_opcode := "0110111"; -- U
  constant OPC_AUIPC  : t_opcode := "0010111"; -- U
  constant OPC_JAL    : t_opcode := "1101111"; -- J
  constant OPC_JALR   : t_opcode := "1100111"; -- I (jump reg)
  constant OPC_SYSTEM : t_opcode := "1110011"; -- I (CSR/ECALL/EBREAK)
  constant OPC_FENCE  : t_opcode := "0001111"; -- I (misc-mem)

  -- FUNCT3 (14 downto 12)
  -- **********************

  -- ALU (R/OP e I/OP-IMM)
  constant F3_ADD_SUB_ADDI      : t_funct3 := "000";
  constant F3_SLL_SLLI          : t_funct3 := "001";
  constant F3_SLT_SLTI          : t_funct3 := "010";
  constant F3_SLTU_SLTIU        : t_funct3 := "011";
  constant F3_XOR_XORI          : t_funct3 := "100";
  constant F3_SRL_SRA_SRLI_SRAI : t_funct3 := "101";
  constant F3_OR_ORI            : t_funct3 := "110";
  constant F3_AND_ANDI          : t_funct3 := "111";
  -- LOAD
  constant F3_LB  : t_funct3 := "000";
  constant F3_LH  : t_funct3 := "001";
  constant F3_LW  : t_funct3 := "010";
  constant F3_LBU : t_funct3 := "100";
  constant F3_LHU : t_funct3 := "101";
  -- STORE
  constant F3_SB : t_funct3 := "000";
  constant F3_SH : t_funct3 := "001";
  constant F3_SW : t_funct3 := "010";
  -- BRANCH
  constant F3_BEQ  : t_funct3 := "000";
  constant F3_BNE  : t_funct3 := "001";
  constant F3_BLT  : t_funct3 := "100";
  constant F3_BGE  : t_funct3 := "101";
  constant F3_BLTU : t_funct3 := "110";
  constant F3_BGEU : t_funct3 := "111";
  -- SYSTEM (ECALL/EBREAK/CSR)
  constant F3_PRIV_CSRRW : t_funct3 := "000"; -- ECALL/EBREAK/URET/SRET/WFI si rs1/rd=0 e imm especial
  constant F3_CSRRW      : t_funct3 := "001";
  constant F3_CSRRS      : t_funct3 := "010";
  constant F3_CSRRC      : t_funct3 := "011";
  constant F3_CSRRWI     : t_funct3 := "101";
  constant F3_CSRRSI     : t_funct3 := "110";
  constant F3_CSRRCI     : t_funct3 := "111";

  -- FUNCT7 (31 downto 25)
  -- **********************
  constant F7_STD : t_funct7 := "0000000"; -- operaciones “normales” (ADD, SLL, SLT, SLTU, XOR, SRL, OR, AND)
  constant F7_ALT : t_funct7 := "0100000"; -- SUB y SRA (y SRAI en OP-IMM)
  -- Extension M (multiplicación/división)
  constant F7_M : t_funct7 := "0000001"; -- MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU

  -- Types of high level operators
  -- ******************************
  -- Inmediatos RISC-V (ancho real de cada tipo)
  -- I: 12 bits, S: 12 bits, B: 13 bits, U: 20 bits, J: 21 bits

  type t_im is record
    i : signed(11 downto 0); -- I-type  imm[11:0]
    s : signed(11 downto 0); -- S-type  imm[11:0]
    b : signed(12 downto 0); -- B-type  imm[12:0]
    u : signed(19 downto 0); -- U-type  imm[31:12] (20 bits)
    j : signed(20 downto 0); -- J-type  imm[20:0]
  end record t_im;

  type t_instr_sig is record
    funct7  : signed(31 downto 25);
    rs2     : signed(24 downto 20);
    rs1     : signed(19 downto 15);
    funct3  : signed(14 downto 12);
    rd      : signed(11 downto 7);
    op_code : signed(6 downto 0);
  end record t_instr_sig;

  type inst_type_t is (r_type, i_type, s_type, b_type, u_type, j_type, other);

  -- Códigos ALU (bit30 & funct3)
  constant ALU_ADD  : std_logic_vector(3 downto 0) := "0000";
  constant ALU_SUB  : std_logic_vector(3 downto 0) := "1000";
  constant ALU_SLL  : std_logic_vector(3 downto 0) := "0001";
  constant ALU_SLT  : std_logic_vector(3 downto 0) := "0010";
  constant ALU_SLTU : std_logic_vector(3 downto 0) := "0011";
  constant ALU_XOR  : std_logic_vector(3 downto 0) := "0100";
  constant ALU_SRL  : std_logic_vector(3 downto 0) := "0101";
  constant ALU_SRA  : std_logic_vector(3 downto 0) := "1101";
  constant ALU_OR   : std_logic_vector(3 downto 0) := "0110";
  constant ALU_AND  : std_logic_vector(3 downto 0) := "0111";
  constant ALU_NOP  : std_logic_vector(3 downto 0) := "1111";

end package risc_v2_isa_pkg;

package body risc_v2_isa_pkg is

end package body risc_v2_isa_pkg;
