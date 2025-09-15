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
-- Module:       TB_RISC_V2_MEMORY
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

use std.env.finish;

library osvvm;
context osvvm.OsvvmContext;

entity tb_ram_memory is
end;

architecture bench of tb_ram_memory is

  -- Generics
  constant mem_width : integer := 32;
  constant addr_width : integer := 17;
  -- Ports
  signal clk_b : std_logic;
  signal addr_b : std_logic_vector(addr_width - 1 downto 0);
  signal di_b : std_logic_vector(mem_width - 1 downto 0);
  signal en_b : std_logic;
  signal we_b : std_logic;
  signal be_a : std_logic_vector((mem_width / 8) - 1 downto 0);
  signal do_b : std_logic_vector(mem_width - 1 downto 0);
  signal clk_a : std_logic;
  signal addr_a : std_logic_vector(addr_width - 1 downto 0);
  signal di_a : std_logic_vector(mem_width - 1 downto 0);
  signal en_a : std_logic;
  signal we_a : std_logic;
  signal be_b : std_logic_vector((mem_width / 8) - 1 downto 0);
  signal do_a : std_logic_vector(mem_width - 1 downto 0);
begin

  ram_memory_inst : entity work.ram_memory
  generic map (
    mem_width => mem_width,
    addr_width => addr_width
  )
  port map (
    clk_b => clk_b,
    addr_b => addr_b,
    di_b => di_b,
    en_b => en_b,
    we_b => we_b,
    be_a => be_a,
    do_b => do_b,
    clk_a => clk_a,
    addr_a => addr_a,
    di_a => di_a,
    en_a => en_a,
    we_a => we_a,
    be_b => be_b,
    do_a => do_a
  );

 CreateClock(clk_a, 20 ns);
 CreateClock(clk_b, 20 ns);

 process 
 begin

  wait for 100 ns;

  --EndOfTestSummary;
  --EndOfTestReports;
  finish;

  
 end process;

end;
