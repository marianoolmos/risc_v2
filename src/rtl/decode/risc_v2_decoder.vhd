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
-- Module:       RISC_V2_DECODER
-- Description:
--
-- Author:       Mariano Olmos Martin
-- Mail  :       mariano.olmos@outlook.com
-- Date:         29/9/2025
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
  use work.risc_v2_isa_pkg.all;

entity risc_v2_decoder is
  port (
    CLK           : in    std_logic;
    RESET         : in    std_logic;
    INSTR_DATA    : in    std_logic_vector(C_MEM_WIDTH - 1 downto 0);
    RAM_DATA      : in    std_logic_vector(C_MEM_WIDTH - 1 downto 0);
    O_ALU_OP      : out   std_logic_vector(3 downto 0);
    IF_RAM_O      : out   t_dp_in;
    IF_INSTR_O  : out t_dp_in;
    INTF_REG_LOAD : out   t_reg_in;
    INTF_REG      : out   t_reg_in;
    RS1           : out   std_logic_vector(4 downto 0);
    RS2           : out   std_logic_vector(4 downto 0);
    REG1_I        : in    std_logic_vector(C_REG_WIDTH - 1 downto 0);
    REG2_I        : in    std_logic_vector(C_REG_WIDTH - 1 downto 0);
    OP1           : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
    OP2           : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
    ALU_RESULT    : in    std_logic_vector(C_REG_WIDTH - 1 downto 0);
    O_EQ     : in std_logic;
    O_LT     : in std_logic;
    O_LTU    : in std_logic;
    new_pc   : out std_logic_vector(C_MEM_WIDTH-1 downto 0);
    new_pc_load : out std_logic;
    SEL_REG_FILE : out  std_logic_vector(2 downto 0);
    PC       : in std_logic_vector(C_MEM_WIDTH - 1 downto 0)

  );
end entity risc_v2_decoder;

architecture rtl of risc_v2_decoder is
  constant NOP : std_logic_vector(31 downto 0) := x"00000013";
  signal s_INSTR_DATA    :    std_logic_vector(C_MEM_WIDTH - 1 downto 0);
  signal alu_op                  : std_logic_vector(3 downto 0);
  signal rd                      : std_logic_vector(4 downto 0);
  signal imm                     : t_im;
  signal funct7                  : std_logic_vector(6 downto 0);
  signal funct3                  : std_logic_vector(2 downto 0);
  signal op_code                 : std_logic_vector(6 downto 0);
  signal s_rs2                   : std_logic_vector(4 downto 0);
  signal s_rs1                   : std_logic_vector(4 downto 0);
  signal r_if_ram                : t_dp_in;
  signal r_reg_load, r1_reg_load : t_reg_in;
  signal branch_taken,flush_if_id : std_logic;

begin

  O_ALU_OP <= alu_op;
  s_INSTR_DATA <= INSTR_DATA when flush_if_id = '0' else NOP;

  -- I-type
  imm.i <= (S_INSTR_DATA(31 downto 20));

  -- S-type
  imm.s <= (S_INSTR_DATA(31 downto 25)) & (S_INSTR_DATA(11 downto 7));

  -- B-type
  imm.b <= (
            S_INSTR_DATA(31) &
            S_INSTR_DATA(7) &
            S_INSTR_DATA(30 downto 25) &
            S_INSTR_DATA(11 downto 8)  &
            '0'
          );
  -- U-type
  imm.u <= (S_INSTR_DATA(31 downto 12));

  -- J-type
  imm.j       <= (
                  S_INSTR_DATA(31) &
                  S_INSTR_DATA(19 downto 12) &
                  S_INSTR_DATA(20) &
                  S_INSTR_DATA(30 downto 21) &
                  '0'
                );
  funct7      <= (S_INSTR_DATA(31 downto 25));
  s_rs2       <= (S_INSTR_DATA(24 downto 20));
  s_rs1       <= (S_INSTR_DATA(19 downto 15));
  funct3      <= (S_INSTR_DATA(14 downto 12));
  rd          <= (S_INSTR_DATA(11 downto 7));
  INTF_REG.rd <= rd;
  op_code     <= (S_INSTR_DATA(6 downto 0));

  sync : process (CLK) is
  begin

    if rising_edge(CLK) then
      r1_reg_load      <= r_reg_load;
      INTF_REG_LOAD.WE <= r1_reg_load.WE;
      INTF_REG_LOAD.RD <= r1_reg_load.RD;
      IF_RAM_O         <= r_if_ram;
      flush_if_id <= new_pc_load;
    end if;

  end process;

  with IF_RAM_o.be select INTF_REG_LOAD.DIN <=
    std_logic_vector(resize(signed(RAM_DATA(7 downto 0)),  32)) when "000",
    std_logic_vector(resize(signed(RAM_DATA(15 downto 0)), 32)) when "001",
    RAM_DATA(31 downto 0) when "010",
    std_logic_vector(resize(unsigned(RAM_DATA(7 downto 0)),  32)) when "100",
    std_logic_vector(resize(unsigned(RAM_DATA(15 downto 0)), 32)) when "101",
    (others => '0') when others;

  process (all) is
  begin

    if (RESET = '1') then
      INTF_REG.WE   <= '0';
      r_reg_load.WE <= '0';
      R_IF_RAM.en   <= '0';
      R_IF_RAM.we   <= '0';
      new_pc_load<='0';
    else
      INTF_REG.WE   <= '0';
      r_reg_load.WE <= '0';
      R_IF_RAM.en   <= '0';
      R_IF_RAM.we   <= '0';
      new_pc_load<='0';
      SEL_REG_FILE <="000";

      case op_code is

        when OPC_OP =>

          alu_op      <= funct7(5) & funct3;
          RS1         <= s_rs1;
          RS2         <= s_rs2;
          OP1         <= REG1_I;
          OP2         <= REG2_I;
          INTF_REG.WE <= '1';

        when OPC_OP_IMM =>

          alu_op      <= '0' & funct3 when ((op_code /= ALU_SRL) and (op_code /= ALU_SRA)) else imm.i(10) & funct3;

          RS1 <= s_rs1;
          OP1 <= REG1_I;
          OP2 <= x"00000" & imm.i;
          INTF_REG.WE <= '1';

        when OPC_LOAD =>

          alu_op        <= ALU_ADD;

          R_IF_RAM.en   <= '1';
          R_IF_RAM.be   <= funct3;
          R_IF_RAM.addr <= ALU_RESULT(C_ADDR_WIDTH + 1 downto 2);

          RS1 <= s_rs1;
          RS2 <= s_rs2;
          OP1 <= REG1_I;
          OP2 <= x"00000" & imm.i;

          r_reg_load.WE <= '1';
          r_reg_load.RD <= rd;

        when OPC_STORE =>

          alu_op <= ALU_ADD;

          R_IF_RAM.en   <= '1';
          R_IF_RAM.we   <= '1';
          R_IF_RAM.be   <= funct3;
          R_IF_RAM.di   <= REG2_I;
          R_IF_RAM.addr <= ALU_RESULT(C_ADDR_WIDTH + 1 downto 2);

          RS1 <= s_rs1;
          RS2 <= s_rs2;
          OP1 <= REG1_I;
          OP2 <= x"00000" & imm.s;

        when OPC_BRANCH =>

          alu_op <= ALU_SUB;
          RS1 <= s_rs1;
          RS2 <= s_rs2;
          OP1 <= REG1_I;
          OP2 <= REG2_I;
          new_pc <= "000" & x"0000" & imm.b ;

          case funct3 is
            when F3_BEQ  => branch_taken <= O_EQ;
            when F3_BNE  => branch_taken <= not O_EQ;
            when F3_BLT  => branch_taken <= O_LT;
            when F3_BGE  => branch_taken <= not O_LT;
            when F3_BLTU => branch_taken <= O_LTU;
            when F3_BGEU => branch_taken <= not O_LTU;
            when others  => branch_taken <= '0';
          end case;

          new_pc_load <= branch_taken;

        when OPC_JAL =>

          alu_op <= ALU_NOP;
          
          SEL_REG_FILE <="010";
          INTF_REG.WE <= '1';

          new_pc <= "000" & x"00" & imm.j ;
          new_pc_load <= '1';

        when OPC_JALR =>

          alu_op <= ALU_ADD;
          
          SEL_REG_FILE <="010";
          INTF_REG.WE <= '1';

          RS1         <= s_rs1;
          OP1         <= REG1_I;
          OP2         <= x"00000" & imm.i;

          new_pc <= ALU_RESULT;
          new_pc_load <= '1';

        when OPC_LUI =>

          alu_op <= ALU_ADD;
          OP1    <= imm.u & x"000";
          OP2    <= x"00000000";
          INTF_REG.WE <= '1';

        when OPC_AUIPC =>

          alu_op <= ALU_ADD;
          OP1    <= PC;
          OP2    <= imm.u & x"000";
          INTF_REG.WE <= '1';

        when OPC_SYSTEM =>

          alu_op <= '0' & funct3;

        -- when OPC_FENCE =>
        when others =>

          alu_op <= '0' & funct3;

      end case;

    end if;

  end process;

end architecture rtl;
