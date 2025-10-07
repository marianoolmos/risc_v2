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
-- Module:       RISC_V2_DECODE
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

entity risc_v2_wb is
  port (
    -- Control desde Decode/Control Unit
    SEL     : in  std_logic_vector(2 downto 0); 
    RD      : in  std_logic_vector(4 downto 0);
    WE      : in  std_logic;                    
    -- Fuentes de datos hacia WB
    alu_result : in  std_logic_vector(C_REG_WIDTH-1 downto 0);
    mem_rdata  : in  std_logic_vector(C_REG_WIDTH-1 downto 0);
    pc_plus4   : in  std_logic_vector(C_REG_WIDTH-1 downto 0); -- para JAL/JALR
    csr_rdata  : in  std_logic_vector(C_REG_WIDTH-1 downto 0); -- lecturas CSR
    fpu_result : in  std_logic_vector(C_REG_WIDTH-1 downto 0); -- opcional, si hay FPU

    -- Salida hacia el banco de registros
    rf_waddr   : out std_logic_vector(4 downto 0);
    rf_wdata   : out std_logic_vector(C_REG_WIDTH-1 downto 0);
    rf_we      : out std_logic
  );
end entity;

architecture rtl of risc_v2_wb is
begin
  rf_waddr <= RD;
  rf_we    <= WE when (RD /= x"00000000") else '0'; -- no escribe x0

  with SEL select
    rf_wdata <= alu_result when "000",
                mem_rdata  when "001",
                pc_plus4   when "010",
                csr_rdata  when "011",
                fpu_result when "100",
                (others => '0') when others;
end architecture;
