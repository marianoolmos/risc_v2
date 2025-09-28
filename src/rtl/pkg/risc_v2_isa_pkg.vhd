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
  subtype t_opcode is std_logic_vector(6 downto 0);
  subtype t_funct3 is std_logic_vector(2 downto 0);
  subtype t_funct7 is std_logic_vector(6 downto 0);

  constant OPC_OP       : t_opcode := "0110011"; -- R
  constant OPC_OP_IMM   : t_opcode := "0010011"; -- I (ALU immed)
  constant OPC_LOAD     : t_opcode := "0000011"; -- I (loads)
  constant OPC_STORE    : t_opcode := "0100011"; -- S
  constant OPC_BRANCH   : t_opcode := "1100011"; -- B
  constant OPC_LUI      : t_opcode := "0110111"; -- U
  constant OPC_AUIPC    : t_opcode := "0010111"; -- U
  constant OPC_JAL      : t_opcode := "1101111"; -- J
  constant OPC_JALR     : t_opcode := "1100111"; -- I (jump reg)
  constant OPC_SYSTEM   : t_opcode := "1110011"; -- I (CSR/ECALL/EBREAK)
  constant OPC_FENCE    : t_opcode := "0001111"; -- I (misc-mem)

  -- FUNCT3 (14 downto 12)
  --**********************

  -- ALU (R/OP e I/OP-IMM)
  constant F3_ADD_SUB_ADDI         : t_funct3 := "000";
  constant F3_SLL_SLLI             : t_funct3 := "001";
  constant F3_SLT_SLTI             : t_funct3 := "010";
  constant F3_SLTU_SLTIU           : t_funct3 := "011";
  constant F3_XOR_XORI             : t_funct3 := "100";
  constant F3_SRL_SRA_SRLI_SRAI    : t_funct3 := "101";
  constant F3_OR_ORI               : t_funct3 := "110";
  constant F3_AND_ANDI             : t_funct3 := "111";
  -- LOAD
  constant F3_LB   : t_funct3 := "000";
  constant F3_LH   : t_funct3 := "001";
  constant F3_LW   : t_funct3 := "010";
  constant F3_LBU  : t_funct3 := "100";
  constant F3_LHU  : t_funct3 := "101";
  -- STORE
  constant F3_SB   : t_funct3 := "000";
  constant F3_SH   : t_funct3 := "001";
  constant F3_SW   : t_funct3 := "010";
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
  --**********************
  constant F7_STD : t_funct7 := "0000000"; -- operaciones “normales” (ADD, SLL, SLT, SLTU, XOR, SRL, OR, AND)
  constant F7_ALT : t_funct7 := "0100000"; -- SUB y SRA (y SRAI en OP-IMM)
  -- Extension M (multiplicación/división)
  constant F7_M   : t_funct7 := "0000001"; -- MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU

  -- Types of high level operators
  --******************************
  type inst_type_t is (R_TYPE, I_TYPE, S_TYPE, B_TYPE, U_TYPE, J_TYPE, OTHER);
  type t_op is (
    -- ALU R/I
    OP_ADD, OP_SUB, OP_AND, OP_OR, OP_XOR, OP_SLL, OP_SRL, OP_SRA, OP_SLT, OP_SLTU,
    OP_ADDI, OP_ANDI, OP_ORI, OP_XORI, OP_SLTI, OP_SLTIU, OP_SLLI, OP_SRLI, OP_SRAI,
    -- Loads/Stores
    OP_LB, OP_LH, OP_LW, OP_LBU, OP_LHU, OP_SB, OP_SH, OP_SW,
    -- Branch/Jump
    OP_BEQ, OP_BNE, OP_BLT, OP_BGE, OP_BLTU, OP_BGEU, OP_JAL, OP_JALR,
    -- U-type
    OP_LUI, OP_AUIPC,
    -- System/Misc
    OP_ECALL, OP_EBREAK, OP_FENCE,
    -- Otros/ilegal
    OP_ILLEGAL,OP_NOP
  );
  attribute enum_encoding : string;
  attribute enum_encoding of t_op : type is "sequential";
  function decode_op(op_code : t_opcode;  funct3  : t_funct3;  funct7  : t_funct7) return t_op;
  

end package;
 
package body risc_v2_instr_set_pkg is

 function decode_op(
  op_code : t_opcode;
  funct3  : t_funct3;
  funct7  : t_funct7
) return t_op is
  variable res : t_op := OP_NOP;  
begin
  case op_code is
    when OPC_OP =>
      case funct3 is
        when F3_ADD_SUB_ADDI =>
          res := (OP_ADD) when (funct7 = F7_STD) else OP_SUB;
        when F3_XOR_XORI =>
          res := OP_XOR;
        when F3_OR_ORI =>
          res := OP_OR;
        when F3_AND_ANDI =>
          res := OP_AND;
        when F3_SLL_SLLI =>
          res := OP_SLL;
        when F3_SRL_SRA_SRLI_SRAI =>
          res := (OP_SRL) when (funct7 = F7_STD) else OP_SRA;
        when F3_SLT_SLTI =>
          res := OP_SLT;
        when F3_SLTU_SLTIU =>
          res := OP_SLTU;
        when others =>
          res:=  OP_NOP;
          null;
      end case;

    when OPC_OP_IMM =>
      case funct3 is
        when F3_ADD_SUB_ADDI =>
          res := OP_ADDI;
        when F3_XOR_XORI =>
          res := OP_XORI;
        when F3_OR_ORI =>
          res := OP_ORI;
        when F3_AND_ANDI =>
          res := OP_ANDI;
        when F3_SLL_SLLI =>
          res := OP_SLLI;
        when F3_SRL_SRA_SRLI_SRAI =>
          -- En OP-IMM, SRLI/SRAI se distinguen por funct7/imm[10:5]
          res := (OP_SRLI) when (funct7= F7_STD) else OP_SRAI;
        when F3_SLT_SLTI =>
          res := OP_SLTI;
        when F3_SLTU_SLTIU =>
          res := OP_SLTIU;
        when others =>
          res:=  OP_NOP;
          null;
      end case;

    when OPC_LOAD =>
      case funct3 is
        when F3_LB  => res := OP_LB;
        when F3_LH  => res := OP_LH;
        when F3_LW  => res := OP_LW;
        when F3_LBU => res := OP_LBU;
        when F3_LHU => res := OP_LHU;
        when others =>
          res:=  OP_NOP;
          null;
      end case;

    when OPC_STORE =>
      case funct3 is
        when F3_SB => res := OP_SB;
        when F3_SH => res := OP_SH;
        when F3_SW => res := OP_SW;
        when others =>
          res:=  OP_NOP;
          null;
      end case;

    when OPC_BRANCH =>
      case funct3 is
        when F3_BEQ  => res := OP_BEQ;
        when F3_BNE  => res := OP_BNE;
        when F3_BLT  => res := OP_BLT;
        when F3_BGE  => res := OP_BGE;
        when F3_BLTU => res := OP_BLTU;
        when F3_BGEU => res := OP_BGEU;
        when others =>
          res:=  OP_NOP;
          null;
      end case;

    when OPC_JAL    => res := OP_JAL;
    when OPC_JALR   => res := OP_JALR;
    when OPC_LUI    => res := OP_LUI;
    when OPC_AUIPC  => res := OP_AUIPC;
    when OPC_SYSTEM => res := (OP_ECALL) when (funct7 = F7_STD) else OP_EBREAK;
    when others     => 
             res:=  OP_NOP;
          null;
  end case;

  return res;
end function;

end package body;