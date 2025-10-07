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
-- Module:       RISC_V2_PKG
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

package risc_v2_pkg is

  -- Memory DualPort RAM Configuration
  -- *********************************
  constant C_ADDR_WIDTH : integer := 17;
  constant C_MEM_WIDTH  : integer := 32;
  constant C_NUM_BYTES  : integer := C_MEM_WIDTH / 8;
  constant C_MEM_DEPTH  : integer := ((2 ** C_ADDR_WIDTH) - 1);
  constant C_INIT_FILE  : string  := "rom_init.hex";

  -- Reg File Configuration
  -- **********************
  constant C_REG_WIDTH : integer := 32;
    constant C_NUM_REGS : integer := 32;

  type ram_type is array (0 to C_MEM_DEPTH) of std_logic_vector(C_MEM_WIDTH - 1 downto 0);

  impure function initromfromfile (
    fname : in string
  ) return ram_type;

  type t_dp_in is record
    addr :     std_logic_vector(C_ADDR_WIDTH - 1 downto 0);
    di   :     std_logic_vector(C_MEM_WIDTH - 1 downto 0);
    en   :     std_logic;
    we   :     std_logic;
    be   :     std_logic_vector((C_MEM_WIDTH / 16) downto 0);
  end record t_dp_in;

  type t_reg_in is record
    WE       :     std_logic;
    LOAD     :     std_logic;
    RS1      :     std_logic_vector(4 downto 0);
    RS2      :     std_logic_vector(4 downto 0);
    DIN      :     std_logic_vector(C_REG_WIDTH - 1 downto 0);
    DIN_LOAD :     std_logic_vector(C_REG_WIDTH - 1 downto 0);
    RD       :     std_logic_vector(4 downto 0);
    RD_LOAD  :     std_logic_vector(4 downto 0);
  end record t_reg_in;


  type t_reg_load is record
    LOAD     :     std_logic;
    RD_LOAD  :     std_logic_vector(4 downto 0);
  end record t_reg_load;

  type t_dp_out is record
    do :    std_logic_vector(C_MEM_WIDTH - 1 downto 0);
  end record t_dp_out;



end package risc_v2_pkg;

package body risc_v2_pkg is

  impure function initromfromfile (
    fname : in string
  ) return ram_type is

    file     data_file : text open read_mode is fname;
    variable data_line : line;
    variable rom       : ram_type := (others => (others => '0'));

  begin

    for i in ram_type'range loop

      exit when endfile(data_file);
      readline(data_file, data_line);
      hread(data_line, rom(i));

    end loop;

    return rom;

  end function initromfromfile;

end package body risc_v2_pkg;
