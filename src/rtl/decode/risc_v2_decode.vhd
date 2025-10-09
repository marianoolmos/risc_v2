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
-- Module:       RISC_V2_DECODE
-- Description:
--
-- Author:       Mariano Olmos Martin
-- Mail  :       mariano.olmos@outlook.com
-- Date:         07/10/2025
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

entity risc_v2_decode is
  port (
    CLK_I      : in    std_logic;
    RESET_I    : in    std_logic;
    RAM_DATA   : in    std_logic_vector(C_MEM_WIDTH - 1 downto 0);
    INSTR_DATA : in    std_logic_vector(C_MEM_WIDTH - 1 downto 0);
    IF_RAM_O   : out   t_dp_in;
    ALU_OP     : out   std_logic_vector(3 downto 0);
    OP1        : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
    OP2        : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
    ALU_RESULT : in    std_logic_vector(C_REG_WIDTH - 1 downto 0);
    O_EQ       : in std_logic;
    O_LT       : in std_logic;
    O_LTU      : in std_logic;
    INTF_REG_DECODE : out    t_reg_in;
    INTF_REG : in    t_reg_in;
    new_pc   : out std_logic_vector(C_MEM_WIDTH-1 downto 0);
    new_pc_load : out std_logic;

    SEL_REG_FILE : out  std_logic_vector(2 downto 0);
    PC       : in std_logic_vector(C_MEM_WIDTH - 1 downto 0)
  );
end entity risc_v2_decode;

architecture rtl of risc_v2_decode is

  signal reg1 : std_logic_vector(C_REG_WIDTH - 1 downto 0);
  signal reg2 : std_logic_vector(C_REG_WIDTH - 1 downto 0);
  signal rs1  : std_logic_vector(4 downto 0);
  signal rs2  : std_logic_vector(4 downto 0);

  signal intf_reg_load : t_reg_in;

begin

  risc_v2_decoder_inst : entity work.risc_v2_decoder
    port map (
      clk           => CLK_I,
      reset         => RESET_I,
      ram_data      => RAM_DATA,
      if_ram_o      => IF_RAM_O,
      instr_data    => INSTR_DATA,
      o_alu_op      => ALU_OP,
      intf_reg      => INTF_REG_DECODE,
      intf_reg_load => intf_reg_load,
      rs1           => rs1,
      rs2           => rs2,
      reg1_i        => reg1,
      reg2_i        => reg2,
      op1           => OP1,
      op2           => OP2,
      alu_result    => ALU_RESULT,
      O_EQ     =>O_EQ,
      O_LT     =>O_LT,
      O_LTU    =>O_LTU,
      new_pc => new_pc,
      new_pc_load => new_pc_load,
      SEL_REG_FILE => SEL_REG_FILE,
      PC => PC

    );

  risc_v2_reg_file_inst : entity work.risc_v2_reg_file
    port map (
      clk_i         => CLK_I,
      reset_i       => RESET_I,
      intf_reg      => INTF_REG,
      intf_reg_load => intf_reg_load,
      rs1           => rs1,
      rs2           => rs2,
      dout1_o       => reg1,
      dout2_o       => reg2
    );

end architecture rtl;
