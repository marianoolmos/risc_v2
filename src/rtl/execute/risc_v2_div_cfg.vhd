


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 use work.risc_v2_pkg.all;

entity ris_v2_div_cfg is
  generic (
    -- número de bits de los operandos
    N : positive := 32 ;
    ARCHITECTURE_TYPE:  integer := C_DIV_PIPELINE
  );
  port (
    clk          : in  std_logic;
    rst          : in  std_logic; 
    valid_i      : in  std_logic;  

    dividend_i   : in  STD_LOGIC_VECTOR(N-1 downto 0); 
    divisor_i    : in  STD_LOGIC_VECTOR(N-1 downto 0); 

    quotient_o   : out STD_LOGIC_VECTOR(N-1 downto 0); 
    remainder_o  : out STD_LOGIC_VECTOR(N-1 downto 0); 
    ready_o      : out std_logic;                      
    done_o       : out std_logic                       
  );
end entity ris_v2_div_cfg;

architecture div of ris_v2_div_cfg is

begin

  serial : if ARCHITECTURE_TYPE = C_DIV_SERIAL generate
    DIV : entity work.risc_v2_div(serial)
      generic map (
        N => N
      )
      port map (
        clk => clk,
        rst => rst,
        valid_i => valid_i,
        dividend_i => dividend_i,
        divisor_i => divisor_i,
        quotient_o => quotient_o,
        remainder_o => remainder_o,
        ready_o => ready_o,
        done_o => done_o
      );
  end generate serial;

  paralell : if ARCHITECTURE_TYPE = C_DIV_PARALELL generate
    DIV : entity work.risc_v2_div(paralell)
    generic map (
      N => N
    )
    port map (
      clk => clk,
      rst => rst,
      valid_i => valid_i,
      dividend_i => dividend_i,
      divisor_i => divisor_i,
      quotient_o => quotient_o,
      remainder_o => remainder_o,
      ready_o => ready_o,
      done_o => done_o
    );
  end generate paralell;

  pipeline : if ARCHITECTURE_TYPE = C_DIV_PIPELINE generate
    DIV : entity work.risc_v2_div(pipeline)
    generic map (
      N => N
    )
    port map (
      clk => clk,
      rst => rst,
      valid_i => valid_i,
      dividend_i => dividend_i,
      divisor_i => divisor_i,
      quotient_o => quotient_o,
      remainder_o => remainder_o,
      ready_o => ready_o,
      done_o => done_o
    );
  end generate pipeline;

end architecture div;