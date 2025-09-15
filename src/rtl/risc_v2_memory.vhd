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

  use work.risc_v2_pkg.all;


entity ram_memory is
  generic (
    G_MEM_WIDTH  : integer := 32;
    G_ADDR_WIDTH : integer := 17
  );
  port (
    
    clk_a  :     std_logic;
    port_a_i : in t_dp_in;
    port_a_o : out t_dp_out;

    clk_b  :     std_logic;
    port_b_i : in t_dp_in;
    port_b_o : out t_dp_out


  );
end entity ram_memory;

architecture syn of ram_memory is

  type ram_type is array ((2 ** G_ADDR_WIDTH) - 1 downto 0) of std_logic_vector(G_MEM_WIDTH - 1 downto 0);

  constant num_bytes  : integer                                := G_MEM_WIDTH / 8;
  shared variable ram : ram_type;

begin

  port_a : process (clk_a) is
  begin

    if rising_edge(clk_a) then
      if (port_a_i.en = '1') then
        port_a_o.do <= RAM(to_integer(unsigned(port_a_i.addr)));
        if (port_a_i.we = '1') then

          write_byte_a : for i in 0 to num_bytes-1 loop

            if (port_a_i.be(i)='1') then
              ram(to_integer(unsigned(port_a_i.addr)))(8*i+7 downto 8*i) := port_a_i.di(8*i+7 downto 8*i);
            end if;

          end loop;

        end if;
      end if;
    end if;

  end process port_a;

  port_b : process (clk_b) is
  begin

    if rising_edge(clk_b) then
      if (port_b_i.en = '1') then
        port_b_o.do <= RAM(to_integer(unsigned(port_b_i.addr)));
        if (port_b_i.we = '1') then

          write_byte_b : for i in 0 to num_bytes-1 loop

            if (port_b_i.be(i) = '1') then
              ram(to_integer(unsigned(port_b_i.addr)))(8*i+7 downto 8*i) := port_b_i.di(8*i+7 downto 8*i);
            end if;

          end loop;

        end if;
      end if;
    end if;

  end process port_b;

--sim
-- pragma translate_off
assert not (port_a_i.en='1' and port_a_i.we='1' and port_b_i.en='1' and port_b_i.we='1' and port_a_i.addr=port_b_i.addr)
  report "ERROR: WRITE/WRITE on the same address"
  severity error;

assert not (port_a_i.en='1' and port_a_i.we='0' and port_b_i.en='1' and port_b_i.we='1' and port_a_i.addr=port_b_i.addr)
  report "ERROR: READ(A)/WRITE(B) on the same address"
  severity warning;

assert not (port_a_i.en='1' and port_a_i.we='1' and port_b_i.en='1' and port_b_i.we='0' and port_a_i.addr=port_b_i.addr)
  report "ERROR: WRITE(A)/READ(B) on the same address"
  severity warning;
-- pragma translate_on

end architecture syn;
