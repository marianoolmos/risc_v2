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
  use work.risc_v2_pkg.all;
  use work.risc_v2_isa_pkg.all;

entity risc_v2_alu is
  port (
    CLK      : in  std_logic;
    RESET    : in  std_logic;
    ALU_OP   : in  std_logic_vector(3 downto 0);
    OP_1      : in  std_logic_vector(C_REG_WIDTH-1 downto 0);
    OP_2      : in  std_logic_vector(C_REG_WIDTH-1 downto 0);
    O_RESULT : out std_logic_vector(C_REG_WIDTH-1 downto 0);
    O_EQ     : out std_logic;
    O_LT     : out std_logic;
    O_LTU    : out std_logic
  );
end entity risc_v2_alu;

architecture rtl of risc_v2_alu is
  
  signal result : std_logic_vector(C_REG_WIDTH-1 downto 0);  
begin


  
  process(OP_1, OP_2, ALU_OP)
    variable v_sub : signed(C_REG_WIDTH downto 0);
  begin
    

    if (ALU_OP = ALU_SUB or ALU_OP = ALU_SLT or ALU_OP = ALU_SLTU) then
      v_sub := signed('0' & OP_1) - signed('0' & OP_2);
    else
      v_sub := (others => '0');  
    end if;
    
    case ALU_OP is
      
      when ALU_ADD =>
        result <= std_logic_vector(signed(OP_1) + signed(OP_2));
      
      when ALU_SUB | ALU_SLT | ALU_SLTU =>
        result <= std_logic_vector(v_sub(C_REG_WIDTH-1 downto 0));

        O_EQ  <= '1' when v_sub = 0 else '0'; 
        O_LT  <= v_sub(C_REG_WIDTH);
        O_LTU <= OP_1(C_REG_WIDTH-1) xor OP_2(C_REG_WIDTH-1) xor v_sub(C_REG_WIDTH-1);
      
      when ALU_XOR =>
        result <= OP_1 xor OP_2;
      
      when ALU_OR =>
        result <= OP_1 or OP_2;
      
      when ALU_AND =>
        result <= OP_1 and OP_2;
      
      when ALU_SLL =>
        result <= std_logic_vector(shift_left(unsigned(OP_1), to_integer(unsigned(OP_2(4 downto 0)))));
      
      when ALU_SRL =>
        result <= std_logic_vector(shift_right(unsigned(OP_1), to_integer(unsigned(OP_2(4 downto 0)))));
      
      when ALU_SRA =>
        result <= std_logic_vector(shift_right(signed(OP_1), to_integer(unsigned(OP_2(4 downto 0)))));
      
      when others =>
        result <= (others => '0');
        
    end case;
    
  end process;

      O_RESULT <= result;
  

end architecture rtl;
