--====================================================================
--
--   /$$$$$$$  /$$$$$$  /$$$$$$   /$$$$$$        /$$    /$$  /$$$$$$
--  | $$__  $$|_  $$_/ /$$__  $$ /$$__  $$      | $$   | $$ /$$__  $$
--  | $$  \ $$  | $$  | $$  \__/| $$  \__/      | $$   | $$|__/  \ $$
--  | $$$$$$$/  | $$  |  $$$$$$ | $$            |  $$ / $$/  /$$$$$$/
--  | $$__  $$  | $$   \____  $$| $$             \  $$ $$/  /$$____/
--  | $$  \ $$  | $$   /$$  \ $$| $$    $$        \  $$$/  | $$
--  | $$  | $$ /$$$$$$|  $$$$$$/|  $$$$$$/         \  $/   | $$$$$$$$
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

entity ram_memory is
  generic (
    mem_width  : integer := 32;
    addr_width : integer := 17
  );
  port (
    clk_b  : in    std_logic;
    addr_b : in    std_logic_vector(addr_width - 1 downto 0);
    di_b   : in    std_logic_vector(mem_width - 1 downto 0);
    en_b   : in    std_logic;
    we_b   : in    std_logic;
    be_a   : in    std_logic_vector((mem_width / 8) - 1 downto 0);
    do_b   : out   std_logic_vector(mem_width - 1 downto 0);

    clk_a  : in    std_logic;
    addr_a : in    std_logic_vector(addr_width - 1 downto 0);
    di_a   : in    std_logic_vector(mem_width - 1 downto 0);
    en_a   : in    std_logic;
    we_a   : in    std_logic;
    be_b   : in    std_logic_vector((mem_width / 8) - 1 downto 0);
    do_a   : out   std_logic_vector(mem_width - 1 downto 0)
  );
end entity ram_memory;

architecture syn of ram_memory is

  type ram_type is array ((2 ** ADDR_WIDTH) - 1 downto 0) of std_logic_vector(MEM_WIDTH - 1 downto 0);

  constant num_bytes  : integer                                := mem_width / 8;
  shared variable ram : ram_type;

begin

  port_a : process (clk_a) is
  begin

    if rising_edge(clk_a) then
      if (en_a = '1') then
        do_a <= RAM(to_integer(unsigned(addr_a)));
        if (we_a = '1') then

          write_byte_a : for i in 0 to num_bytes-1 loop

            if (be_a(i)='1') then
              ram(to_integer(unsigned(addr_a)))(8*i+7 downto 8*i) := di_a(8*i+7 downto 8*i);
            end if;

          end loop;

        end if;
      end if;
    end if;

  end process port_a;

  port_b : process (clk_b) is
  begin

    if rising_edge(clk_b) then
      if (en_b = '1') then
        do_b <= RAM(to_integer(unsigned(addr_b)));
        if (we_b = '1') then

          write_byte_b : for i in 0 to num_bytes-1 loop

            if (be_b(i) = '1') then
              ram(to_integer(unsigned(addr_b)))(8*i+7 downto 8*i) := di_b(8*i+7 downto 8*i);
            end if;

          end loop;

        end if;
      end if;
    end if;

  end process port_b;

--sim
-- pragma translate_off
assert not (en_a='1' and we_a='1' and en_b='1' and we_b='1' and addr_a=addr_b)
  report "ERROR: WRITE/WRITE on the same address"
  severity error;

assert not (en_a='1' and we_a='0' and en_b='1' and we_b='1' and addr_a=addr_b)
  report "ERROR: READ(A)/WRITE(B) on the same address"
  severity warning;

assert not (en_a='1' and we_a='1' and en_b='1' and we_b='0' and addr_a=addr_b)
  report "ERROR: WRITE(A)/READ(B) on the same address"
  severity warning;
-- pragma translate_on

end architecture syn;
