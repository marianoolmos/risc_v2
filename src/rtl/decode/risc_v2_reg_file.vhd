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
use work.risc_v2_pkg.all;

entity risc_v2_reg_file is
  port (
    CLK_I     : in  std_logic;
    RESET_I   : in  std_logic;
    RS1       : in    std_logic_vector(4 downto 0);
    RS2       : in    std_logic_vector(4 downto 0);
    INTF_REG,INTF_REG_LOAD  : in  t_reg_in;            
    DOUT1_O   : out std_logic_vector(C_REG_WIDTH-1 downto 0);
    DOUT2_O   : out std_logic_vector(C_REG_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of risc_v2_reg_file is

  type rf_t is array (0 to C_NUM_REGS-1) of std_logic_vector(C_REG_WIDTH-1 downto 0);
  signal rf : rf_t := (others => (others => '0'));
  function reg_idx(slv : std_logic_vector) return integer is
  begin
    return to_integer(unsigned(slv));
  end function;

  constant ZERO_REG : integer := 0;

begin


  p_write : process (CLK_I, RESET_I)
  begin
    if RESET_I = '1' then
      rf <= (others => (others => '0'));
    elsif rising_edge(CLK_I) then
      -- Puerto de ejecución (EX) escribe si WE=1 y RD/=x0
      if INTF_REG.WE = '1' then
        if reg_idx(INTF_REG.RD) /= ZERO_REG then
          rf(reg_idx(INTF_REG.RD)) <= INTF_REG.DIN;
        end if;
      end if;

      -- Puerto de load (WB) independiente; prioridad sobre EX si coincide dirección
      if INTF_REG_LOAD.WE = '1' then
        if reg_idx(INTF_REG_LOAD.RD) /= ZERO_REG then
          rf(reg_idx(INTF_REG_LOAD.RD)) <= INTF_REG_LOAD.DIN;
        end if;
      end if;
    end if;
  end process;

  -- Lecturas combinacionales con siempre lectura a 0 en 0
  DOUT1_O <= (others => '0') when reg_idx(RS1) = ZERO_REG
             else rf(reg_idx(RS1));

  DOUT2_O <= (others => '0') when reg_idx(RS2) = ZERO_REG
             else rf(reg_idx(RS2));

end architecture;
