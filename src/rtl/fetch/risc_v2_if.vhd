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
-- Module:       RISC_V2_IF(INSTRUCTION FETCH)
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

entity risc_v2_if is
  port (
    CLK      : in    std_logic;
    RESET    : in    std_logic;
    IF_INSTR_O : out   t_dp_in;
    PC       : in std_logic_vector(C_MEM_WIDTH - 1 downto 0)
  );
end entity;

architecture rtl of risc_v2_if is

begin
  instr_reg : process (all) is
  begin
    
      if (RESET = '1') then
        IF_INSTR_O.en <= '0';
      else
        IF_INSTR_O.en <= '1';
        IF_INSTR_O.ADDR <= std_logic_vector(pc(C_ADDR_WIDTH + 1 downto 2));
      end if;


  end process instr_reg;
    

end architecture;