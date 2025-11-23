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
-- Module:       RISC_V2_EXECUTE
-- Description:
--
-- Author:       Mariano Olmos Martin
-- Mail  :       mariano.olmos@outlook.com
-- Date:         07/10/2025
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
  use work.risc_v2_isa_pkg.all;

entity risc_v2_execute is
  generic (
    N                  : integer := 32;
    ARCHITECTURE_TYPE  : integer := C_DIV_PIPELINE
  );
  port (
    CLK      : in    std_logic;
    RESET    : in    std_logic;
    --ALU INPUTS
    ALU_OP     : in  std_logic_vector(3 downto 0);
    OP1        : in  std_logic_vector(C_REG_WIDTH-1 downto 0);
    OP2        : in  std_logic_vector(C_REG_WIDTH-1 downto 0);
    --ALU OUTPUTS
    ALU_RESULT : out   std_logic_vector(C_REG_WIDTH - 1 downto 0);
    O_EQ     : out std_logic;
    O_LT     : out std_logic;
    O_LTU    : out std_logic;
    --DIV EXT. INPUTS
    valid_i      : in  std_logic;  
    dividend_i   : in  STD_LOGIC_VECTOR(N-1 downto 0); 
    divisor_i    : in  STD_LOGIC_VECTOR(N-1 downto 0); 
    --DIV EXT. OUTPUTS
    quotient_o   : out STD_LOGIC_VECTOR(N-1 downto 0); 
    remainder_o  : out STD_LOGIC_VECTOR(N-1 downto 0); 
    ready_o      : out std_logic;                      
    done_o       : out std_logic    

  );
end entity risc_v2_execute;

architecture rtl of risc_v2_execute is

begin

ALU : entity work.risc_v2_alu
  port map (
    CLK => CLK,
    RESET => RESET,
    ALU_OP => ALU_OP,
    OP_1 => OP1,
    OP_2 => OP2,
    O_RESULT => ALU_RESULT,
    O_EQ     =>O_EQ,
    O_LT     =>O_LT,
    O_LTU    =>O_LTU  );

  DIV : entity work.ris_v2_div_cfg
  generic map (
    N => N,
    ARCHITECTURE_TYPE => ARCHITECTURE_TYPE
  )
  port map (
    clk => clk,
    rst => reset,
    valid_i => valid_i,
    dividend_i => dividend_i,
    divisor_i => divisor_i,
    quotient_o => quotient_o,
    remainder_o => remainder_o,
    ready_o => ready_o,
    done_o => done_o
  );


end architecture rtl;
