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
        INSTR_DATA : in    std_logic_vector(C_MEM_WIDTH - 1 downto 0);
        RAM_DATA   : in    std_logic_vector(C_MEM_WIDTH - 1 downto 0);
        RD         : out std_logic_vector(4 downto 0);
        WE         : out std_logic;
        o_alu_op   : out std_logic_vector(3 downto 0);
        IF_RAM_O   : out t_dp_in;
        IF_REG_LOAD_O  : out   t_reg_in;
        RS1       : out    std_logic_vector(4 downto 0);
        RS2       : out    std_logic_vector(4 downto 0);
        REG1_I    : in   std_logic_vector(C_REG_WIDTH - 1 downto 0);
        REG2_I    : in   std_logic_vector(C_REG_WIDTH - 1 downto 0);
        OP1    : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
        OP2    : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
        ALU_RESULT : in   std_logic_vector(C_REG_WIDTH - 1 downto 0)
        
    );
end entity;

architecture rtl of risc_v2_decoder is
  signal alu_op : std_logic_vector(3 downto 0);
  signal imm    : t_im;
  signal funct7  : std_logic_vector(6 downto 0); 
  signal funct3  : std_logic_vector(2 downto 0); 
  signal op_code : std_logic_vector(6 downto 0);
  signal s_rs2      : std_logic_vector(4 downto 0);
  signal s_rs1      : std_logic_vector(4 downto 0);
  signal R_IF_RAM :  t_dp_in;
  signal r_reg_load,r1_reg_load :t_reg_in;

begin
  o_alu_op<=alu_op;

  -- I-type
  imm.i <= ( INSTR_DATA(31 downto 20) );
  
  -- S-type
  imm.s <= (INSTR_DATA(31 downto 25)) & (INSTR_DATA(11 downto 7));
  
  -- B-type
  imm.b <= (
             INSTR_DATA(31) &
             INSTR_DATA(30 downto 25) &
             INSTR_DATA(11 downto 8) &
             INSTR_DATA(7) &
             '0'
           );
  -- U-type
  imm.u <= ( INSTR_DATA(31 downto 12) );
  
  -- J-type 
  imm.j <= (
             INSTR_DATA(31) &
             INSTR_DATA(19 downto 12) &
             INSTR_DATA(20) &
             INSTR_DATA(30 downto 21) &
             '0'
           );
  funct7     <= (INSTR_DATA(31 downto 25));
  s_rs2     <= (INSTR_DATA(24 downto 20));
  s_rs1     <= (INSTR_DATA(19 downto 15));
  funct3  <= (INSTR_DATA(14 downto 12));
  rd      <= (INSTR_DATA(11 downto 7));
  op_code <= (INSTR_DATA(6 downto 0));

  WRITE_BACK : process (clk)
  begin
    if rising_edge(clk) then
      r1_reg_load<= r_reg_load;
      IF_REG_LOAD_O.WE<=r1_reg_load.WE;
      IF_REG_LOAD_O.RD<=r1_reg_load.RD;
      IF_RAM_O <= R_IF_RAM;
    end if;
  end process;
  
 with IF_RAM_o.be select
  IF_REG_LOAD_O.DIN <=
    std_logic_vector(resize( signed(RAM_DATA(7 downto 0)),  32)) when "000",
    std_logic_vector(resize( signed(RAM_DATA(15 downto 0)), 32)) when "001",
    RAM_DATA(31 downto 0)                   when "010",
    std_logic_vector(resize(unsigned(RAM_DATA(7 downto 0)),  32)) when "100",
    std_logic_vector(resize(unsigned(RAM_DATA(15 downto 0)), 32)) when "101",
    (others => '0') when others;


  process (all) is
  begin
    if reset='1' then
      WE <= '0';
      r_reg_load.WE <= '0';
      R_IF_RAM.en <= '0';
      R_IF_RAM.we <= '0';
    else
      WE <= '0';
      r_reg_load.WE <= '0';
      R_IF_RAM.en <= '0';
      R_IF_RAM.we <= '0';
      case op_code is

        when OPC_OP =>

              alu_op <= funct7(5)  & funct3 ;
              OP1 <= REG1_I;
              OP2 <= REG2_I;
              WE <= '1';
              rs1 <= s_rs1;
              rs2 <= s_rs2;
           

        when OPC_OP_IMM =>

              alu_op <= '0' & funct3 when ((op_code/=ALU_SRL)and (op_code/=ALU_SRA)) else imm.i(10)  & funct3 ;
              WE <= '1';

              rs1 <= s_rs1;
              OP1 <= REG1_I;
              OP2 <= x"00000" & imm.i;
         

        when OPC_LOAD =>

              alu_op <= ALU_ADD;
              R_IF_RAM.en <= '1';
              R_IF_RAM.be <= funct3;
              r_reg_load.WE <= '1';
              r_reg_load.RD <= rd;
              R_IF_RAM.addr <= ALU_RESULT(C_ADDR_WIDTH + 1 downto 2);

              rs1 <= s_rs1;
              rs2 <= s_rs2;
              OP1 <= REG1_I;
              OP2 <= x"00000" & imm.i;
              
        when OPC_STORE =>

              alu_op <= ALU_ADD;

              R_IF_RAM.en <= '1';
              R_IF_RAM.we <= '1';
              R_IF_RAM.be <= funct3;
              R_IF_RAM.di <= REG2_I;
              R_IF_RAM.addr <= ALU_RESULT(C_ADDR_WIDTH + 1 downto 2);

              rs1 <= s_rs1;
              rs2 <= s_rs2;
              OP1 <= REG1_I;
              OP2 <= x"00000" & imm.s;
          

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

          alu_op <= ALU_ADD;
          OP1 <= imm.u & x"000";
          OP2 <= x"00000000";


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