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
  use work.risc_v2_pkg.all;

entity risc_v2_core is
    port (
      
        CLK_I   : in std_logic;
        RESET_I : in std_logic;

        MEM_INSTR_INTF : view t_dp_master_side;
        MEM_RAM_INTF   : view t_dp_master_side
 
    );
end entity;

architecture rtl of risc_v2_core is
  
    signal ALU_RESULT :  std_logic_vector(C_REG_WIDTH - 1 downto 0);
    signal intf_reg,intf_reg_decode   :  t_reg_in;
    signal new_pc     :  std_logic_vector(C_MEM_WIDTH-1 downto 0);
    signal new_pc_load :  std_logic;
    signal PC       :  std_logic_vector(C_MEM_WIDTH - 1 downto 0);
    signal reg_data_mux : std_logic_vector(2 downto 0);
  
    signal s_div_intf :t_div_rec;
    signal s_alu_intf :t_alu_rec;

begin

 FETCH : entity work.risc_v2_fetch
  port map (
    CLK => CLK_I,
    RESET => RESET_I,
    new_pc => new_pc,
    new_pc_load => new_pc_load,
    PC => PC,
    INSTR_ADDR => MEM_INSTR_INTF.ADDR

  );

 DECODE : entity work.risc_v2_decode
  port map (
    CLK_I => CLK_I,
    RESET_I => RESET_I,
    MEM_INSTR_INTF =>MEM_INSTR_INTF,
    MEM_RAM_INTF   =>MEM_RAM_INTF,
    ALU_INTF => s_alu_intf,

    INTF_REG => intf_reg,
    INTF_REG_DECODE => intf_reg_decode,
    new_pc => new_pc,
    new_pc_load => new_pc_load,
    SEL_REG_FILE=>reg_data_mux,
    PC => PC
  );

  EXECUTE : entity work.risc_v2_execute
  port map (
    CLK => CLK_I,
    RESET => RESET_I,
    ALU_INTF => s_alu_intf,
    DIV_INTF => s_div_intf
  );

  WRITEBACK : entity work.risc_v2_wb
  port map (
    SEL => reg_data_mux,
    RD => intf_reg_decode.RD,
    WE => intf_reg_decode.WE,
    alu_result => ALU_RESULT,
    mem_rdata => (others => '0') ,
    pc_plus4 => PC ,
    csr_rdata => (others => '0') ,
    fpu_result => (others => '0') ,
    rf_waddr => intf_reg.rd,
    rf_wdata => intf_reg.din,
    rf_we => intf_reg.we
  );




end architecture;