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
-- Module:       RISC_V2_ALU
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

  entity risc_v2_alu is
    port (
        clk   : in std_logic;
        rs1   : in    std_logic_vector(31 downto 0);
        imm   : in    std_logic_vector(31 downto 0);
        rsi   : in    std_logic_vecotr(11 downto 0);
        rd    : out    std_logic_vector(31 downto 0);
        reset : in std_logic
        
    );
  end entity;

  architecture rtl of risc_v2_alu is
  
  begin
  
    process (clk)
    begin
      if rising_edge(clk) then
        case ins is
          when c_add =>
            rd <= rs1 + rs2;
          when c_sub =>
            rd <= rs1 - rs2;
          when c_xor =>
            rd <= rs1 xor rs2;
          when c_or =>
            rd <= rs1 or rs2;
          when c_and =>
            rd <= rs1 and rs2;
          when c_sll =>
            rd <= shift_left(rs1, rs2);
          when c_srl =>
            rd <= shift_right(rs1, rs2);
          when c_sra =>
            rd <= rs1 xor rs2;
          when c_slt =>
            rd <= rs1 xor rs2;
          when c_sltu =>
            rd <= rs1 xor rs2;
          when others =>
            null;
        end case;
      end if;
    end process;
  
    process (clk)
    begin
      if rising_edge(clk) then
        case insi is
          when c_addi =>
            rd <= rs1 + imm;
          when c_subi =>
            rd <= rs1 - imm;
          when c_xori =>
            rd <= rs1 xor imm;
          when c_ori =>
            rd <= rs1 or imm;
          when c_andi =>
            rd <= rs1 and imm;
          when c_slli =>
            rd <= shift_left(rs1, imm);
          when c_srl =>
            rd <= shift_right(rs1, imm);
          when c_srai =>
            rd <= rs1 xor imm;
          when c_slti =>
            rd <= rs1 xor imm;
          when c_sltui =>
            rd <= rs1 xor imm;
          when others =>
            null;
        end case;
      end if;
    end process;
  
  end architecture;