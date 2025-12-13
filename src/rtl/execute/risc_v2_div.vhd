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
-- Module:       RISC_V2_DIV -> 3 ARCHITECTURES(SERIAL,PARALELL,PIPELINE)
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

entity risc_v2_div is
  port (
    clk          : in  std_logic;
    rst          : in  std_logic; 

    DIV_INTF     : view t_div_master                    
    
  );
end entity risc_v2_div;


architecture serial of risc_v2_div is
  -- R: resto parcial, N+1 bits con signo (acumulador)
  signal R : signed(N downto 0) := (others => '0');
  -- C: cociente parcial, N bits sin signo
  signal C : unsigned(N-1 downto 0) := (others => '0');
  -- P: (R,C) empaquetados: [2N..N] = resto, [N-1..0] = cociente
  signal P : unsigned(2*N downto 0) := (others => '0');
  -- B: divisor extendido a N+1 bits con signo (MSB = 0)
  signal B : signed(N downto 0) := (others => '0');
  -- Contador de iteraciones
  signal iter_cnt : unsigned(N-1 downto 0) := (others => '0');
  -- Registro para done
  signal r_done : std_logic := '0';
  -- igual que en 'serial'
  signal adjust : std_logic := '0';

begin

  -- División NO restauradora (1 bit por ciclo)
  run : process(clk)
    variable v_p      : unsigned(2*N downto 0);
    variable start    : std_logic;
  begin
    if rising_edge(clk) then
      if rst = '1' then
        R        <= (others => '0');
        C        <= (others => '0');
        P        <= (others => '0');
        B        <= (others => '0');
        iter_cnt <= (others => '0');
        start    := '0';
        r_done   <= '0';
        adjust   <= '1';

      elsif DIV_INTF.valid = '1' then
        -- Carga inicial: mismo comportamiento que en 'serial'
        R        <= (others => '0');
        C        <= unsigned(DIV_INTF.DIVIDEND);
        B        <= signed('0' & DIV_INTF.DIVISOR);
        iter_cnt <= (others => '0');
        start    := '1';
        r_done   <= '0';
        adjust   <= '0';

        --1) Inicializar P = (R=0, C=dividendo)
        v_p := (others => '0');
        v_p(2*N downto N) := (others => '0');              -- resto inicial = 0
        v_p(N-1 downto 0) := unsigned(DIV_INTF.DIVIDEND);         -- cociente inicial = dividendo
        P <= v_p;

      elsif start = '1' then
        
        v_p      := P;
        --2) Desplazar el par de registros (P,A) un bit a la izquierda.
        v_p := shift_left(v_p, 1);
        --3) Si P es negativo, sumar el registro B al P y poner poner el bit
        --de orden inferior de A a 0
        --Si P es positivo, restar el registro B al P y poner poner el bit
        --de orden inferior de A a 1
        if P(P'high) = '0' then
          v_p(2*N downto N)  := unsigned(signed(v_p(2*N downto N))  - B);
        else
          v_p(2*N downto N)  := unsigned(signed(v_p(2*N downto N))  + B);
        end if;

        if v_P(v_P'high) = '0' then
          v_p(0) := '1';  
        else
          v_p(0) := '0';  
        end if;

        --4) Si el resultado final es negativo, sumar el registro B al resto
        if iter_cnt = to_unsigned(N-1, iter_cnt'length) then
          if v_p(v_p'high) = '1' then
            v_p(2*N downto N) := unsigned(signed(v_p(2*N downto N)) + B);
          else
            v_p(2*N downto N) := unsigned(v_p(2*N downto N));
          end if;
          r_done <= '1';
          start  := '0';
          adjust <= '1';
        else
          iter_cnt   <= iter_cnt + 1;
          r_done     <= '0';
        end if;

        R <= signed(v_p(2*N downto N));
        C <= v_p(N-1 downto 0);
        P <= v_p;
      else
                r_done     <= '0';
      end if;
    end if;
  end process;

  DIV_INTF.QUOTIENT  <= std_logic_vector(C);
  DIV_INTF.REMAINDER <= std_logic_vector(R(N-1 downto 0));
  DIV_INTF.READY     <= '1' when adjust = '1' else '0'; 
  DIV_INTF.DONE      <= r_done;

end architecture serial;


architecture paralell of risc_v2_div is

  -- R: resto parcial, N+1 bits con signo (acumulador)
  signal R : signed(N downto 0) := (others => '0');
  type t_P_array is array  (0 to N) of unsigned(2*N downto 0);
  signal P_array : t_P_array;
  -- B: divisor extendido a N+1 bits con signo (MSB = 0)
  signal B : signed(N downto 0) := (others => '0');
  -- Contador de iteraciones
  signal r_done : std_logic := '0';

begin

  reg : process(all)
    variable v_p      : unsigned(2*N downto 0);
  begin
      if rst = '1' then
        B        <= (others => '0');
        r_done<='0';
      elsif DIV_INTF.VALID = '1' then
        -- Carga inicial: mismo comportamiento que en 'serial'
        B        <= signed('0' & DIV_INTF.DIVISOR);
        --1) Inicializar P = (R=0, C=dividendo)
        v_p := (others => '0');
        v_p(2*N downto N) := (others => '0');              -- resto inicial = 0
        v_p(N-1 downto 0) := unsigned(DIV_INTF.DIVIDEND);         -- cociente inicial = dividendo
        P_array(0) <= v_p;
        r_done<='1';
      else
        r_done<='0';
      end if;
    end process;

    PARALLEL_GEN: for i in 0 to N-1 generate  
     run : process(all)
       variable v_p      : unsigned(2*N downto 0);
     begin    
        v_p      := P_array(i);
        --2) Desplazar el par de registros (P,A) un bit a la izquierda.
        v_p := shift_left(v_p, 1);
        --3) Si P es negativo, sumar el registro B al P y poner poner el bit
        --de orden inferior de A a 0
        --Si P es positivo, restar el registro B al P y poner poner el bit
        --de orden inferior de A a 1
        if  P_array(i)( P_array(i)'high) = '0' then
          v_p(2*N downto N)  := unsigned(signed(v_p(2*N downto N))  - B);
        else
          v_p(2*N downto N)  := unsigned(signed(v_p(2*N downto N))  + B);
        end if;
        if v_P(v_P'high) = '0' then
          v_p(0) := '1';  
        else
          v_p(0) := '0';  
        end if;
        P_array(i+1) <= v_p;
      end process;
    end generate;

  --4) Si el resultado final es negativo, sumar el registro B al resto
  process (all)
  begin
      if P_array(N)(P_array(N)'high) = '1' then
        R <= (signed(P_array(N)(2*N downto N)) + B);
      else
        R <= signed(P_array(N)(2*N downto N));
      end if;
  end process;

  DIV_INTF.QUOTIENT  <= std_logic_vector(P_array(N)(N-1 downto 0));
  DIV_INTF.REMAINDER <= std_logic_vector(R(N-1 downto 0));
  DIV_INTF.READY     <= '1'; 
  DIV_INTF.DONE      <= r_done;

end architecture paralell;

architecture pipeline of risc_v2_div is
  -- R: resto parcial, N+1 bits con signo (acumulador)
  signal R : signed(N downto 0) := (others => '0');
  type t_P_array is array  (0 to N) of unsigned(2*N downto 0);
  signal P_array : t_P_array:= (others => (others => '0') ) ;
  -- B: divisor extendido a N+1 bits con signo (MSB = 0)
  type t_B_array is array  (0 to N) of signed(N downto 0);
  signal B_array : t_B_array := (others => (others => '0') );

  -- Registro para done
type t_Valid_array is array (0 to N) of std_logic;
signal Valid_array : t_Valid_array := (others => '0');
 -- signal P_0:unsigned(2 * N downto 0);

begin

  reg : process(clk)
    variable v_p      : unsigned(2*N downto 0);
  begin
    if rising_edge(clk) then
      if rst = '1' then
        B_array(0)        <= (others => '0') ;
        P_array(0)       <=  (others => '0') ;
        Valid_array(0)   <= '0' ;
      elsif DIV_INTF.VALID = '1' then
        -- Carga inicial: mismo comportamiento que en 'serial'
        B_array(0)        <= signed('0' & DIV_INTF.DIVISOR);
        --1) Inicializar P = (R=0, C=dividendo)
        v_p := (others => '0');
        v_p(2*N downto N) := (others => '0');              
        v_p(N-1 downto 0) := unsigned(DIV_INTF.DIVIDEND);         
        P_array(0) <= v_p;
        Valid_array(0) <= '1';
      else
        Valid_array(0) <= '0';
      end if;
    end if;
    end process;

    PIPELINE_GEN: for i in 0 to N-1 generate  
     run : process(clk)
       variable v_p      : unsigned(2*N downto 0);
       variable v_B : signed(N downto 0);
     begin
      if rising_edge(clk) then
        
        v_p      := P_array(i);
        v_B      := B_array(i);
        
        --2) Desplazar el par de registros (P,A) un bit a la izquierda.
        v_p := shift_left(v_p, 1);
        --3) Si P es negativo, sumar el registro B al P y poner poner el bit
        --de orden inferior de A a 0
        --Si P es positivo, restar el registro B al P y poner poner el bit
        --de orden inferior de A a 1
        if  P_array(i)( P_array(i)'high) = '0' then
          v_p(2*N downto N)  := unsigned(signed(v_p(2*N downto N))  - v_B);
        else
          v_p(2*N downto N)  := unsigned(signed(v_p(2*N downto N))  + v_B);
        end if;
        if v_P(v_P'high) = '0' then
          v_p(0) := '1';  
        else
          v_p(0) := '0';  
        end if;
        
        P_array(i+1) <= v_p;
        B_array(i+1) <= v_B; 
        Valid_array(i+1) <= Valid_array(i);
      end if;
      end process;
    end generate;

  --4) Si el resultado final es negativo, sumar el registro B al resto
  process (all)
  begin
      if P_array(N)(P_array(N)'high) = '1' then
        R <= (signed(P_array(N)(2*N downto N)) + B_array(N));
      else
        R <= signed(P_array(N)(2*N downto N));
      end if;
  end process;
  

  DIV_INTF.QUOTIENT  <= std_logic_vector(P_array(N)(N-1 downto 0));
  DIV_INTF.REMAINDER <= std_logic_vector(R(N-1 downto 0));
  DIV_INTF.READY     <= '1'; 
  DIV_INTF.DONE      <= Valid_array(N);

end architecture pipeline;