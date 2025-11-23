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
-- Module:       RISC_V2_FECTH
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

entity risc_v2_fetch is
  port (
    CLK         : in    std_logic;
    new_pc      : in std_logic_vector(C_MEM_WIDTH-1 downto 0);
    new_pc_load : in std_logic;
    PC           : out std_logic_vector(C_MEM_WIDTH - 1 downto 0);
    ADDR : OUT std_logic_vector(C_ADDR_WIDTH - 1 downto 0);
    RESET       : in    std_logic
  ); 
end entity risc_v2_fetch;

architecture rtl of risc_v2_fetch is

  signal s_pc,s_act_pc : std_logic_vector(C_MEM_WIDTH - 1 downto 0);

begin
  pc<= s_act_pc;
risc_v2_if_inst : entity work.risc_v2_if
  port map (
    CLK => CLK,
    RESET => RESET,
    ADDR => ADDR,
    PC => s_PC
  );

risc_v2_pc_inst : entity work.risc_v2_pc
  port map (
    CLK => CLK,
    RESET => RESET,
    new_pc => new_pc,
    new_pc_load => new_pc_load,
    PC => s_PC,
    actual_pc => s_act_pc
  );

end architecture rtl;
