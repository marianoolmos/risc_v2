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
-- Module:       risc_v2_sb(SCOREBOARD)
-- Description:
--
-- Author:       Mariano Olmos Martin
-- Mail  :       mariano.olmos@outlook.com
-- Date:         09/10/2025
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
  use std.env.all;

library osvvm;
  context osvvm.osvvmcontext;
  use osvvm.scoreboardpkg_slv.all;
  use work.risc_v2_pkg.all;

entity risc_v2_sb is
  port (
    CLK   : in    std_logic;
    RESET : in    std_logic
  );
end entity risc_v2_sb;

architecture scoreboard of risc_v2_sb is
  subtype str5_t is string(1 to 5);
  type str5_array_t is array (natural range <>) of str5_t;

  constant OPCODES : str5_array_t := (
    "add  ", "sub  ", "xor  ", "or   ", "and  ",
    "sll  ", "srl  ", "sra  ", "slt  ", "sltu ",
    "addi ", "xori ", "ori  ", "andi ", "slli ",
    "srli ", "srai ", "slti ", "sltiu", "lb   ",
    "lh   ", "lw   ", "lbu  ", "lhu  ", "sb   ",
    "sh   ", "sw   ", "beq  ", "bne  ", "blt  ",
    "bge  ", "bltu ", "bgeu ", "jal  ", "jalr ",
    "lui  ", "auipc"
  );
  constant BASE_ADDR : integer := 1000;

  alias a_ram        is << signal .tb_risc_v2_top.risc_v2_top_inst.memory_inst.s_ram : ram_type >>;
  type t_inst_sb  is array (0 to 36) of scoreboardidtype;
  signal inst_sb : t_inst_sb;

begin

  -- prueba<= a_ram;
  INST_SCOEBOARD : process is
  begin
    wait until reset='0';

    for i in 0 to 36 loop
        inst_sb(i)<=NewID(OPCODES(i));
        wait for 0 ns;
        Push(inst_sb(i),x"1CEDCAFE");
    end loop;

    wait for 1500 ns;

    for i in 0 to 36 loop
        Check(inst_sb(i),a_ram(BASE_ADDR+i));
    end loop;
    wait;

  end process;

end architecture scoreboard;
