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
-- Module:       RISC_V2_DEC_EXE
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

entity risc_v2_dec_exe is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        IF_RAM_DATA_O : out  t_dp_in;
        IF_RAM_DATA_I : in   t_dp_out;
        IF_INSTR_DATA_I : in t_dp_out
        
    );
end entity;

architecture rtl of risc_v2_dec_exe is
  signal s_rs1,s_rs2 : std_logic_vector(C_MEM_WIDTH - 1 downto 0);

  alias op_code : std_logic_vector(6 downto 0) is IF_INSTR_DATA_I.do(6 downto 0);
  
begin

  process (clk)
  begin
    if rising_edge(clk) then
      case op_code is
        when OPC_OP    =>
        when OPC_OP_IMM=>
        when OPC_LOAD=>
        when OPC_STORE=>
        when OPC_BRANCH=>
        when OPC_LUI=>
        when OPC_AUIPC=>
        when OPC_JAL=>
        when OPC_JALR=>
        when OPC_SYSTEM=>
        when OPC_FENCE=>
        when others =>
          null;
      end case;
    end if;
  end process;

  
risc_v2_reg_file_inst : entity work.risc_v2_reg_file
  port map (
    CLK_I => CLK_I,
    RESET_I => RESET_I,
    WE_I => WE_I,
    LOAD_I => LOAD_I,
    RS1_I => RS1_I,
    RS2_I => RS2_I,
    DIN_I => DIN_I,
    DIN_LOAD_I => DIN_LOAD_I,
    RD_I => RD_I,
    RD_LOAD_I => RD_LOAD_I,
    DOUT1_O => DOUT1_O,
    DOUT2_O => DOUT2_O
  );

risc_v2_alu_inst : entity work.risc_v2_alu
  port map (
    clk => clk,
    rs1 => s_rs1,
    rs2 => s_rs2,
    imm => imm,
    rsi => rsi,
    rd => rd,
    reset => reset
  );

    

end architecture;