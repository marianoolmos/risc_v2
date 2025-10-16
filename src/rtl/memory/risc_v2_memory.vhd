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
-- Module:       RISC_V2_MEMORY
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
  use ieee.std_logic_textio.all;
  use std.textio.all;
  use work.risc_v2_pkg.all;

entity ram_memory is
  
  port (
    CLK    :     std_logic;
    
    PORT_A_I : in    t_dp_in;
    PORT_A_O : out   std_logic_vector(C_MEM_WIDTH - 1 downto 0);

    PORT_B_I : in    t_dp_in;
    PORT_B_O : out   std_logic_vector(C_MEM_WIDTH - 1 downto 0)
  );
end entity ram_memory;

architecture rtl of ram_memory is

  shared variable ram : ram_type := initRomFromFile("/home/cafecafe/Documents/git/risc_v2/src/rtl/pkg/init_file.hex");
  signal s_ram : ram_type ;
begin

  port_a : process (CLK) is
  begin

    if rising_edge(CLK) then
      s_ram<=ram;
        PORT_A_O <= RAM(to_integer(unsigned(port_a_i.addr)));
        if (port_a_i.we = '1') then

            if (port_a_i.be = "00") then
              ram(to_integer(unsigned(port_a_i.addr)))(7 downto 0) := port_a_i.di(7 downto 0);
            end if;

            if (port_a_i.be = "01") then
              ram(to_integer(unsigned(port_a_i.addr)))(15 downto 0) := port_a_i.di(15 downto 0);
            end if;

            if (port_a_i.be = "10") then
              ram(to_integer(unsigned(port_a_i.addr)))(31 downto 0) := port_a_i.di(31 downto 0);
            end if;

        end if;
      end if;

  end process port_a;

  port_b : process (CLK) is
  begin

    if rising_edge(CLK) then
        if (port_b_i.be(1 downto 0) = "00") then
          PORT_B_O(7 downto 0) <= RAM(to_integer(unsigned(port_b_i.addr)))(7 downto 0);
        end if;
        if (port_b_i.be(1 downto 0) = "01") then
          PORT_B_O(15 downto 0) <= RAM(to_integer(unsigned(port_b_i.addr)))(15 downto 0);
        end if;
        if (port_b_i.be(1 downto 0) = "10") then
          PORT_B_O(31 downto 0) <= RAM(to_integer(unsigned(port_b_i.addr)))(31 downto 0);
        end if;
        if (port_b_i.we = '1') then

            if (port_b_i.be(1 downto 0) = "00") then
              ram(to_integer(unsigned(port_b_i.addr)))(7 downto 0) := port_b_i.di(7 downto 0);
            end if;

            if (port_b_i.be(1 downto 0) = "01") then
              ram(to_integer(unsigned(port_b_i.addr)))(15 downto 0) := port_b_i.di(15 downto 0);
            end if;

            if (port_b_i.be(1 downto 0) = "10") then
              ram(to_integer(unsigned(port_b_i.addr)))(31 downto 0) := port_b_i.di(31 downto 0);
            end if;

        end if;
      end if;

  end process port_b;

  -- sim
  -- pragma translate_off
  assert not (port_a_i.we = '1' and port_b_i.we = '1' and port_a_i.addr = port_b_i.addr)
    report "ERROR: WRITE/WRITE on the same address"
    severity error;

  assert not (port_a_i.we = '0' and port_b_i.we = '1' and port_a_i.addr = port_b_i.addr)
    report "ERROR: READ(A)/WRITE(B) on the same address"
    severity warning;

  assert not (port_a_i.we = '1' and port_b_i.we = '0' and port_a_i.addr = port_b_i.addr)
    report "ERROR: WRITE(A)/READ(B) on the same address"
    severity warning;
-- pragma translate_on

end architecture rtl;
