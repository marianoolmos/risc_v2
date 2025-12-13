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
    ALU_INTF : view t_alu_slave
  );
end entity risc_v2_alu;

architecture rtl of risc_v2_alu is
  
  signal result : std_logic_vector(C_REG_WIDTH-1 downto 0);  
begin


  
  process(ALU_INTF.OP1, ALU_INTF.OP2, ALU_INTF.OPC)
    variable v_sub : signed(C_REG_WIDTH downto 0);
  begin
    

    if (ALU_INTF.OPC = ALU_SUB or ALU_INTF.OPC = ALU_SLT or ALU_INTF.OPC = ALU_SLTU) then
      v_sub := signed('0' & ALU_INTF.OP1) - signed('0' & ALU_INTF.OP2);
    else
      v_sub := (others => '0');  
    end if;
    
    case ALU_INTF.OPC is
      
      when ALU_ADD =>
        result <= std_logic_vector(signed(ALU_INTF.OP1) + signed(ALU_INTF.OP2));
      
      when ALU_SUB | ALU_SLT | ALU_SLTU =>
        result <= std_logic_vector(v_sub(C_REG_WIDTH-1 downto 0));

        ALU_INTF.O_EQ  <= '1' when v_sub = 0 else '0'; 
        ALU_INTF.O_LT  <= v_sub(C_REG_WIDTH);
        ALU_INTF.O_LTU <= ALU_INTF.OP1(C_REG_WIDTH-1) xor ALU_INTF.OP2(C_REG_WIDTH-1) xor v_sub(C_REG_WIDTH-1);
      
      when ALU_XOR =>
        result <= ALU_INTF.OP1 xor ALU_INTF.OP2;
      
      when ALU_OR =>
        result <= ALU_INTF.OP1 or ALU_INTF.OP2;
      
      when ALU_AND =>
        result <= ALU_INTF.OP1 and ALU_INTF.OP2;
      
      when ALU_SLL =>
        result <= std_logic_vector(shift_left(unsigned(ALU_INTF.OP1), to_integer(unsigned(ALU_INTF.OP2(4 downto 0)))));
      
      when ALU_SRL =>
        result <= std_logic_vector(shift_right(unsigned(ALU_INTF.OP1), to_integer(unsigned(ALU_INTF.OP2(4 downto 0)))));
      
      when ALU_SRA =>
        result <= std_logic_vector(shift_right(signed(ALU_INTF.OP1), to_integer(unsigned(ALU_INTF.OP2(4 downto 0)))));
      
      when others =>
        result <= (others => '0');
        
    end case;
    
  end process;

      ALU_INTF.RESULT <= result;
  

end architecture rtl;
