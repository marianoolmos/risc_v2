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
-- Module:       RISC_V2_EXECUTE
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

entity risc_v2_execute is
  port (
    CLK      : in    std_logic;
    RESET    : in    std_logic;
    ALU_OP     : in  std_logic_vector(3 downto 0);
    OP1        : in  std_logic_vector(C_REG_WIDTH-1 downto 0);
    OP2        : in  std_logic_vector(C_REG_WIDTH-1 downto 0);
    ALU_RESULT : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
    O_EQ     : out std_logic;
    O_LT     : out std_logic;
    O_LTU    : out std_logic
  );
end entity risc_v2_execute;

architecture rtl of risc_v2_execute is

begin

risc_v2_alu_inst : entity work.risc_v2_alu
  port map (
    CLK => CLK,
    RESET => RESET,
    ALU_OP => ALU_OP,
    OP_1 => OP1,
    OP_2 => OP2,
    O_RESULT => ALU_RESULT,
    O_EQ     =>O_EQ,
    O_LT     =>O_LT,
    O_LTU    =>O_LTU  );


end architecture rtl;
