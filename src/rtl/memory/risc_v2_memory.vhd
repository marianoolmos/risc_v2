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
  use work.risc_v2_pkg.all;

entity dp_bram is
  
  port (
    CLK    :     std_logic;
    
    PORT_A : view t_dp_ram_side;
    PORT_B : view t_dp_ram_side;
  );
end entity dp_bram;

architecture rtl of dp_bram is

  shared variable ram : ram_type := initRomFromFile(C_INIT_BRAM_DATA);
  signal s_ram : ram_type;
begin
  A : process (CLK) is
  begin

    if rising_edge(CLK) then
        s_ram<= ram;

        PORT_A.do <= RAM(to_integer(unsigned(PORT_A.addr)));

        if (PORT_A.we = '1') then

          case PORT_A.be is
            when "0001" =>
              ram(to_integer(unsigned(PORT_A.addr)))(7 downto 0) := PORT_A.di(7 downto 0);
            when "0011" =>
              ram(to_integer(unsigned(PORT_A.addr)))(15 downto 0) := PORT_A.di(15 downto 0);
            when "1111" =>
              ram(to_integer(unsigned(PORT_A.addr)))(31 downto 0) := PORT_A.di;         
            when others =>
              null;
          end case;

        end if;
    end if;

  end process A;

  B : process (CLK) is
  begin

    if rising_edge(CLK) then
      
        PORT_B.do(31 downto 0) <= RAM(to_integer(unsigned(PORT_B.addr)));

        if (PORT_B.we = '1') then
          case PORT_B.be is
            when "0001" =>
              ram(to_integer(unsigned(PORT_B.addr)))(7 downto 0) := PORT_B.di(7 downto 0);
            when "0011" =>
              ram(to_integer(unsigned(PORT_B.addr)))(15 downto 0) := PORT_B.di(15 downto 0);
            when "1111" =>
              ram(to_integer(unsigned(PORT_B.addr)))(31 downto 0) := PORT_B.di;         
            when others =>
              null;
          end case;
        end if;
    end if;

  end process B;

  -- sim
  -- pragma translate_off
  assert not (PORT_A.we = '1' and PORT_B.we = '1' and PORT_A.addr = PORT_B.addr)
    report "ERROR: WRITE/WRITE on the same address"
    severity error;

  assert not (PORT_A.we = '0' and PORT_B.we = '1' and PORT_A.addr = PORT_B.addr)
    report "ERROR: READ(A)/WRITE(B) on the same address"
    severity warning;

  assert not (PORT_A.we = '1' and PORT_B.we = '0' and PORT_A.addr = PORT_B.addr)
    report "ERROR: WRITE(A)/READ(B) on the same address"
    severity warning;
-- pragma translate_on

end architecture rtl;
