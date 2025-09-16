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
  use ieee.math_real.all;
  use std.env.finish;
  use work.risc_v2_pkg.all;

library osvvm;
  context osvvm.osvvmcontext;
  use osvvm.scoreboardpkg_slv.all;

entity tb_ram_memory is
end entity tb_ram_memory;

architecture bench of tb_ram_memory is

  signal clk_a, clk_b : std_logic;
  -- Ports

  signal s_if_instr_i : t_dp_in;
  signal s_if_instr_o : t_dp_out;

  signal s_if_data_i : t_dp_in;
  signal s_if_data_o : t_dp_out;

  signal sb : scoreboardidtype;

begin

  CreateClock(clk_a, 20 ns);
  CreateClock(clk_b, 20 ns);

  ram_memory_inst : entity work.ram_memory
    generic map (
      g_mem_width  => C_MEM_WIDTH,
      g_addr_width => C_ADDR_WIDTH
    )
    port map (
      clk_a    => clk_a,
      port_a_i => s_if_instr_i,
      port_a_o => s_if_instr_o,

      clk_b    => clk_b,
      port_b_i => s_if_data_i,
      port_b_o => s_if_data_o
    );

  process is

    variable vdata_in : std_logic_vector(31 downto 0);
    variable tmp :unsigned((C_MEM_WIDTH/8)-1  downto 0):=(others => '1') ;
  begin

    sb <= NewID("DP_SB");
    SetTestName("WRITE-READ");
    -- BYTE ENABLE
    for j in 0 to (C_MEM_WIDTH/8)-1 loop
      -- ADDR A read B
      for i in 0 to ((2 ** C_ADDR_WIDTH) - 1) loop

        s_if_instr_i.en   <= '1';
        s_if_instr_i.we   <= '1';
        tmp:= (shift_left(to_unsigned(1, tmp), j));
        s_if_instr_i.be   <= std_logic_vector(tmp);
        s_if_instr_i.addr <= std_logic_vector(to_unsigned(i, C_ADDR_WIDTH));
        s_if_instr_i.di   <= std_logic_vector(to_unsigned(i, C_MEM_WIDTH));
        vdata_in          :=std_logic_vector(to_unsigned(i, C_MEM_WIDTH));
        wait for 100 ns;
        Push(sb, vdata_in(8 * j + 7 downto 8 * j));
        s_if_instr_i.en   <= '0';
        s_if_instr_i.we   <= '0';
        s_if_data_i.en    <= '1';
        s_if_data_i.we    <= '0';
        s_if_data_i.be    <= "1111";
        wait for 0 ns;
        s_if_data_i.addr  <= std_logic_vector(to_unsigned(i, C_ADDR_WIDTH));
        wait for 100 ns;
        Check(sb, s_if_data_o.do(8 * j + 7 downto 8 * j));

      end loop;
      --ADDR B READ A
      for i in 0 to ((2 ** C_ADDR_WIDTH) - 1) loop

        s_if_data_i.en    <= '1';
        s_if_data_i.we    <= '1';
        tmp:= (shift_left(to_unsigned(1, tmp), j));
        s_if_data_i.be   <= std_logic_vector(tmp);
        s_if_data_i.addr  <= std_logic_vector(to_unsigned(i, C_ADDR_WIDTH));
        s_if_data_i.di    <= std_logic_vector(to_unsigned(i, C_MEM_WIDTH));
        vdata_in          :=std_logic_vector(to_unsigned(i, C_MEM_WIDTH));
        wait for 100 ns;
        Push(sb, vdata_in(8 * j + 7 downto 8 * j));
        s_if_data_i.en    <= '0';
        s_if_data_i.we    <= '0';
        s_if_instr_i.en   <= '1';
        s_if_instr_i.we   <= '0';
        s_if_instr_i.be   <= "1111";
        wait for 0 ns;
        s_if_instr_i.addr <= std_logic_vector(to_unsigned(i, C_ADDR_WIDTH));
        wait for 100 ns;
        Check(sb, s_if_instr_o.do(8 * j + 7 downto 8 * j));

      end loop;
    end loop;

    ReportAlerts;
    finish;

  end process;

end architecture bench;
