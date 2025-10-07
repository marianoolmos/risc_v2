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
        clk   : in std_logic;
        reset : in std_logic;
        IF_INSTR_I : in    t_dp_out;

        o_alu_op : out std_logic_vector(3 downto 0);
        IF_RAM_I   : in    t_dp_out;
        IF_RAM_O : out t_dp_in;
        IF_REG_O  : out   t_reg_in;
        REG1_I    : in   std_logic_vector(C_REG_WIDTH - 1 downto 0);
        REG2_I    : in   std_logic_vector(C_REG_WIDTH - 1 downto 0);
        RS1_VAL_O    : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
        RS2_VAL_O    : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
        ALU_RESULT   : in   std_logic_vector(C_REG_WIDTH - 1 downto 0)
        
    );
end entity;

architecture rtl of risc_v2_decoder is
  signal alu_op : std_logic_vector(3 downto 0);
  signal imm    : t_im;
  signal rd       : std_logic_vector(4 downto 0);
  signal funct7  : std_logic_vector(6 downto 0); 
  signal funct3  : std_logic_vector(2 downto 0); 
  signal op_code : std_logic_vector(6 downto 0);
  signal rs2      : std_logic_vector(4 downto 0);
  signal rs1      : std_logic_vector(4 downto 0);
  signal R_IF_RAM :  t_dp_in;
  signal r_reg_load,r1_reg_load :t_reg_load;

begin
  o_alu_op<=alu_op;

  -- I-type
  imm.i <= ( IF_INSTR_I.do(31 downto 20) );
  
  -- S-type
  imm.s <= (IF_INSTR_I.do(31 downto 25)) & (IF_INSTR_I.do(11 downto 7));
  
  -- B-type
  imm.b <= (
             IF_INSTR_I.do(31) &
             IF_INSTR_I.do(30 downto 25) &
             IF_INSTR_I.do(11 downto 8) &
             IF_INSTR_I.do(7) &
             '0'
           );
  -- U-type
  imm.u <= ( IF_INSTR_I.do(31 downto 12) );
  
  -- J-type 
  imm.j <= (
             IF_INSTR_I.do(31) &
             IF_INSTR_I.do(19 downto 12) &
             IF_INSTR_I.do(20) &
             IF_INSTR_I.do(30 downto 21) &
             '0'
           );
  funct7     <= (IF_INSTR_I.do(31 downto 25));
  rs2     <= (IF_INSTR_I.do(24 downto 20));
  rs1     <= (IF_INSTR_I.do(19 downto 15));
  funct3  <= (IF_INSTR_I.do(14 downto 12));
  rd      <= (IF_INSTR_I.do(11 downto 7));
  op_code <= (IF_INSTR_I.do(6 downto 0));

  WRITE_BACK : process (clk)
  begin
    if rising_edge(clk) then
      r1_reg_load<= r_reg_load;
      IF_REG_O.LOAD<=r1_reg_load.LOAD;
      IF_REG_O.RD_LOAD<=r1_reg_load.RD_LOAD;
      IF_RAM_O <= R_IF_RAM;
    end if;
  end process;
  
 with IF_RAM_o.be select
  IF_REG_O.DIN_LOAD <=
    std_logic_vector(resize( signed(IF_RAM_I.do(7 downto 0)),  32)) when "000",
    std_logic_vector(resize( signed(IF_RAM_I.do(15 downto 0)), 32)) when "001",
    IF_RAM_I.do(31 downto 0)                   when "010",
    std_logic_vector(resize(unsigned(IF_RAM_I.do(7 downto 0)),  32)) when "100",
    std_logic_vector(resize(unsigned(IF_RAM_I.do(15 downto 0)), 32)) when "101",
    (others => '0') when others;


  process (all) is
  begin
    if reset='1' then
      IF_REG_O.we <= '0';
      R_REG_LOAD.LOAD <= '0';
      R_IF_RAM.en <= '0';
      R_IF_RAM.we <= '0';
    else
      IF_REG_O.we <= '0';
      R_REG_LOAD.LOAD <= '0';
      R_IF_RAM.en <= '0';
      R_IF_RAM.we <= '0';
      case op_code is

        when OPC_OP =>

              alu_op <= funct7(5)  & funct3 ;
              RS1_VAL_O <= REG1_I;
              RS2_VAL_O <= REG2_I;
              IF_REG_O.we <= '1';
              IF_REG_O.rd <= rd;
              IF_REG_O.rs1<=rs1;
              IF_REG_O.rs2<=rs2;
              IF_REG_O.DIN<=ALU_RESULT;

        when OPC_OP_IMM =>

              alu_op <= '0' & funct3 when ((op_code/=ALU_SRL)and (op_code/=ALU_SRA)) else imm.i(10)  & funct3 ;
              IF_REG_O.we <= '1';
              IF_REG_O.rd <= rd;

              IF_REG_O.rs1<=rs1;
              RS1_VAL_O <= REG1_I;
              RS2_VAL_O <= x"00000" & imm.i;
              IF_REG_O.DIN<=ALU_RESULT;

        when OPC_LOAD =>

              alu_op <= ALU_ADD;
              R_IF_RAM.en <= '1';
              R_IF_RAM.be <= funct3;
              R_IF_RAM.addr <= ALU_RESULT(C_ADDR_WIDTH + 1 downto 2);
              R_REG_LOAD.LOAD <= '1';
              R_REG_LOAD.RD_LOAD <=rd;

              IF_REG_O.rs1 <= rs1;
              IF_REG_O.rs2 <=rs2;
              RS1_VAL_O <= REG1_I;
              RS2_VAL_O <= x"00000" & imm.i;
              
        when OPC_STORE =>

              alu_op <= ALU_ADD;

              R_IF_RAM.en <= '1';
              R_IF_RAM.we <= '1';
              R_IF_RAM.be <= funct3;
              R_IF_RAM.di <= REG2_I;
              R_IF_RAM.addr <= ALU_RESULT(C_ADDR_WIDTH + 1 downto 2);

              IF_REG_O.rs1<=rs1;
              IF_REG_O.rs2<=rs2;
              RS1_VAL_O <= REG1_I;
              RS2_VAL_O <= x"00000" & imm.s;
          

        when OPC_BRANCH =>

          case funct3 is

            when F3_BEQ =>

              alu_op <= '0' &funct3;

            when F3_BNE =>

              alu_op <= '0' &funct3;

            when F3_BLT =>

              alu_op <= '0' &funct3;

            when F3_BGE =>

              alu_op <= '0' &funct3;

            when F3_BLTU =>

              alu_op <= '0' &funct3;

            when F3_BGEU =>

              alu_op <= '0' &funct3;

            when others =>

              alu_op <= '0' &funct3;

          end case;

        when OPC_JAL =>

          alu_op <= '0' &funct3;

        when OPC_JALR =>

          alu_op <= '0' &funct3;

        when OPC_LUI =>

          alu_op <= ALU_NOP;
          IF_REG_O.DIN<= imm.u & x"000";

          IF_REG_O.we <= '1';
          IF_REG_O.rd <= rd;


        when OPC_AUIPC =>

          alu_op <= '0' &funct3;

        when OPC_SYSTEM =>

          alu_op <= '0' &funct3;

        -- when OPC_FENCE =>
        when others =>

          alu_op <= '0' &funct3;

      end case;
    end if;
  end process;

    

end architecture;