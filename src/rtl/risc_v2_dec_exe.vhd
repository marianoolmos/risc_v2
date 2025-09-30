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
  use work.risc_v2_isa_pkg.all;

entity risc_v2_dec_exe is
  port (
    CLK_I      : in    std_logic;
    RESET_I    : in    std_logic;
    IF_RAM_I   : in    t_dp_out;
    IF_INSTR_I : in    t_dp_out;
    IF_RAM_O   : out   t_dp_in
  );
end entity risc_v2_dec_exe;

architecture rtl of risc_v2_dec_exe is

  signal alu_op   : std_logic_vector(3 downto 0);
  signal rs1_data : std_logic_vector(C_REG_WIDTH - 1 downto 0);
  signal rs2_data : std_logic_vector(C_REG_WIDTH - 1 downto 0);
  signal result   : std_logic_vector(C_REG_WIDTH - 1 downto 0);
  signal if_reg   : t_reg_in;
  signal rs2      : std_logic_vector(4 downto 0);
  signal rs1      : std_logic_vector(4 downto 0);
  signal rd       : std_logic_vector(4 downto 0);

begin

  risc_v2_decoder_inst : entity work.risc_v2_decoder
    port map (
      clk        => CLK_I,
      reset      => RESET_I,
      if_ram_o   => IF_RAM_O,
      if_instr_i => IF_INSTR_I,
      o_alu_op   => alu_op,
      if_reg_o   => if_reg
    );

  risc_v2_reg_file_inst : entity work.risc_v2_reg_file
    port map (
      clk_i    => CLK_I,
      reset_i  => RESET_I,
      if_reg_i => if_reg,
      dout1_o  => rs1_data,
      dout2_o  => rs2_data
    );

  risc_v2_alu_inst : entity work.risc_v2_alu
    port map (
      clk    => CLK_I,
      reset  => RESET_I,
      rs1    => rs1_data,
      rs2    => rs2_data,
      o_result => result,
      alu_op => alu_op

    );

end architecture rtl;
