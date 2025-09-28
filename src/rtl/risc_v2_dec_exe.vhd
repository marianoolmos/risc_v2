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
-- Module:       RISC_V2_DEC_EXE
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
--======================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.risc_v2_pkg.all;
  use work.risc_v2_instr_set_pkg.all;

entity risc_v2_dec_exe is
  port (
    CLK_I           : in    std_logic;
    RESET_I         : in    std_logic;
    IF_RAM_DATA_O   : out   t_dp_in;
    IF_RAM_DATA_I   : in    t_dp_out;
    IF_INSTR_DATA_I : in    t_dp_out
  );
end entity risc_v2_dec_exe;

architecture rtl of risc_v2_dec_exe is

  signal op : t_op;

  alias funct7  : std_logic_vector(31 downto 25) is IF_INSTR_DATA_I.do(31 downto 25);
  alias rs2     : std_logic_vector(24 downto 20) is IF_INSTR_DATA_I.do(24 downto 20);
  alias rs1     : std_logic_vector(19 downto 15) is IF_INSTR_DATA_I.do(19 downto 15);
  alias funct3  : std_logic_vector(14 downto 12) is IF_INSTR_DATA_I.do(14 downto 12);
  alias rd      : std_logic_vector(11 downto 7) is IF_INSTR_DATA_I.do(11 downto 7);
  alias op_code : std_logic_vector(6 downto 0) is IF_INSTR_DATA_I.do(6 downto 0);

begin

  process (op_code,funct3,funct7) is
  begin

      case op_code is

        when OPC_OP =>

          case funct3 is

            when F3_ADD_SUB_ADDI =>

              op <= OP_ADD when (funct7 = F7_STD) else OP_SUB;

            when F3_XOR_XORI =>

              op <= OP_XOR;

            when F3_OR_ORI =>

              op <= OP_OR;

            when F3_AND_ANDI =>

              op <= OP_AND;

            when F3_SLL_SLLI =>

              op <= OP_SLL;

            when F3_SRL_SRA_SRLI_SRAI =>

              op <= OP_SRL when (funct7 = F7_STD) else OP_SRA;

            when F3_SLT_SLTI =>

              op <= OP_SLT;

            when F3_SLTU_SLTIU =>

              op <= OP_SLTU;

            when others =>

              op <= OP_NOP;

          end case;

        when OPC_OP_IMM =>

          case funct3 is

            when F3_ADD_SUB_ADDI =>

              op <= OP_ADDI;

            when F3_XOR_XORI =>

              op <= OP_XORI;

            when F3_OR_ORI =>

              op <= OP_ORI;

            when F3_AND_ANDI =>

              op <= OP_ANDI;

            when F3_SLL_SLLI =>

              op <= OP_SLLI;

            when F3_SRL_SRA_SRLI_SRAI =>

              op <= OP_SRLI;

            when F3_SLT_SLTI =>

              op <= OP_SLTI;

            when F3_SLTU_SLTIU =>

              op <= OP_SLTIU;

            when others =>

              op <= OP_NOP;

          end case;

        when OPC_LOAD =>

          case funct3 is

            when F3_LB =>

              op <= OP_LB;

            when F3_LH =>

              op <= OP_LH;

            when F3_LW =>

              op <= OP_LW;

            when F3_LBU =>

              op <= OP_LBU;

            when F3_LHU =>

              op <= OP_LHU;

            when others =>

              op <= OP_NOP;

          end case;

        when OPC_STORE =>

          case funct3 is

            when F3_SB =>

              op <= OP_SB;

            when F3_SH =>

              op <= OP_SH;

            when F3_SW =>

              op <= OP_SW;

            when others =>

              op <= OP_NOP;

          end case;

        when OPC_BRANCH =>

          case funct3 is

            when F3_BEQ =>

              op <= OP_BEQ;

            when F3_BNE =>

              op <= OP_BNE;

            when F3_BLT =>

              op <= OP_BLT;

            when F3_BGE =>

              op <= OP_BGE;

            when F3_BLTU =>

              op <= OP_BLTU;

            when F3_BGEU =>

              op <= OP_BGEU;

            when others =>

              op <= OP_NOP;

          end case;

        when OPC_JAL =>

          op <= OP_JAL;

        when OPC_JALR =>

          op <= OP_JALR;

        when OPC_LUI =>

          op <= OP_LUI;

        when OPC_AUIPC =>

          op <= OP_AUIPC;

        when OPC_SYSTEM =>

          op <= OP_ECALL when funct7 = F7_STD else OP_EBREAK;

        -- when OPC_FENCE =>
        when others =>

          op <= OP_NOP;

      end case;

    end if;

  end process;

  risc_v2_reg_file_inst : entity work.risc_v2_reg_file
    port map (
      clk_i      => CLK_I,
      reset_i    => RESET_I,
      we_i       => WE_I,
      load_i     => LOAD_I,
      rs1_i      => rs1,
      rs2_i      => rs2,
      din_i      => DIN_I,
      din_load_i => DIN_LOAD_I,
      rd_i       => RD_I,
      rd_load_i  => RD_LOAD_I,
      dout1_o    => DOUT1_O,
      dout2_o    => DOUT2_O
    );

  risc_v2_alu_inst : entity work.risc_v2_alu
    port map (
      clk   => CLK_I,
      op_i  => op,
      rs1_i => unsigned(rs1),
      rs2_i => unsigned(rs2),
      rd    => rd,
      reset => reset
    );

end architecture rtl;
