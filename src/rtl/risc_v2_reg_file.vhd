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
-- Module:       RISC_V2_REG_FILE
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

entity risc_v2_reg_file is
  port (
    CLK_I   : in    std_logic;
    RESET_I : in    std_logic;
    WE_I    : in    std_logic;
    LOAD_I  : in    std_logic;

    RS1_I      : in    std_logic_vector(C_REG_WIDTH - 1 downto 0);
    RS2_I      : in    std_logic_vector(C_REG_WIDTH - 1 downto 0);
    DIN_I      : in    std_logic_vector(C_REG_WIDTH - 1 downto 0);
    DIN_LOAD_I : in    std_logic_vector(C_REG_WIDTH - 1 downto 0);
    RD_I       : in    std_logic_vector(C_REG_WIDTH - 1 downto 0);
    RD_LOAD_I  : in    std_logic_vector(C_REG_WIDTH - 1 downto 0);
    DOUT1_O    : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
    DOUT2_O    : out   std_logic_vector(C_REG_WIDTH - 1 downto 0)
  );
end entity risc_v2_reg_file;

architecture rtl of risc_v2_reg_file is

  type rf_t is array(0 to 2 ** RD_I'length - 1) of std_logic_vector(DIN_I'length - 1 downto 0);

  shared variable rf : rf_t;

begin

  if_data : process (CLK_I, RESET_I) is
  begin

    if (RESET_I = '1') then
      rf := (others => (others => '0'));
    elsif rising_edge(CLK_I) then
      if (WE_I = '1') then
        rf(to_integer(unsigned(RD_I))) := DIN_I;
      end if;
    end if;

  end process if_data;

  if_load : process (CLK_I, RESET_I) is
  begin

    if rising_edge(CLK_I) then
      if (WE_I = '1') then
        if (LOAD_I = '1') then
          rf(to_integer(unsigned(RD_LOAD_I))) := DIN_LOAD_I;
        end if;
      end if;
    end if;

  end process if_load;

  -- Always 0 in register 0x0
  DOUT1_O <= (others => '0') when RS1_I = (others => '0') else
             rf(to_integer(unsigned(RS1_I)));
  DOUT2_O <= (others => '0') when RS2_I = (others => '0') else
             rf(to_integer(unsigned(RS2_I)));

end architecture rtl;
