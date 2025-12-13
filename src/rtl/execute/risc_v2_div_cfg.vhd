


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 use work.risc_v2_pkg.all;

entity ris_v2_div_cfg is
  generic (
    ARCHITECTURE_TYPE:  integer := C_DIV_PIPELINE
  );
  port (
    clk          : in  std_logic;
    rst          : in  std_logic; 

    DIV_INTF     : view t_div_master   
  );
end entity ris_v2_div_cfg;

architecture div of ris_v2_div_cfg is

begin

  serial : if ARCHITECTURE_TYPE = C_DIV_SERIAL generate
    DIV : entity work.risc_v2_div(serial)
      port map (
        clk => clk,
        rst => rst,
        DIV_INTF=> DIV_INTF
      );
  end generate serial;

  paralell : if ARCHITECTURE_TYPE = C_DIV_PARALELL generate
    DIV : entity work.risc_v2_div(paralell)
    port map (
      clk => clk,
      rst => rst,
      DIV_INTF=> DIV_INTF
    );
  end generate paralell;

  pipeline : if ARCHITECTURE_TYPE = C_DIV_PIPELINE generate
    DIV : entity work.risc_v2_div(pipeline)
    port map (
      clk => clk,
      rst => rst,
      DIV_INTF=> DIV_INTF
    );
  end generate pipeline;

end architecture div;