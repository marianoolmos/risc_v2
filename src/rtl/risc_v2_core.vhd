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
-- Module:       RISC_V2_CORE
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

entity risc_v2_core is
    port (
      
        clk   : in std_logic;
        reset : in std_logic;
        IF_INSTR_O : out  t_dp_in;
        IF_INSTR_I : in   t_dp_out;
        IF_RAM_DATA_O : out  t_dp_in;
        IF_RAM_DATA_I : in   t_dp_out
        
    );
end entity;

architecture rtl of risc_v2_core is

    signal ALU_OP     :  std_logic_vector(3 downto 0);
    signal OP1        :   std_logic_vector(C_REG_WIDTH-1 downto 0);
    signal OP2        :   std_logic_vector(C_REG_WIDTH-1 downto 0);
    signal ALU_RESULT : std_logic_vector(C_REG_WIDTH - 1 downto 0);

begin

 fetch : entity work.risc_v2_fetch
  port map (
    CLK => CLK,
    IF_INSTR_O => IF_INSTR_O,
    RESET => RESET
  );

 decode : entity work.risc_v2_decode
  port map (
    CLK_I => CLK,
    RESET_I => RESET,
    IF_RAM_I => IF_RAM_DATA_I,
    IF_INSTR_I => IF_INSTR_I,
    IF_RAM_O => IF_RAM_DATA_O,
    ALU_OP => ALU_OP,
    OP1 => OP1,
    OP2 => OP2,
    ALU_RESULT => ALU_RESULT
  );
  
  execute : entity work.risc_v2_execute
  port map (
    CLK => CLK,
    RESET => RESET,
    ALU_OP => ALU_OP,
    OP1 => OP1,
    OP2 => OP2,
    ALU_RESULT => ALU_RESULT
  );



end architecture;