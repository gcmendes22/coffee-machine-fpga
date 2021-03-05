library ieee;
use ieee.std_logic_1164.all;

entity flip_flop_d is 

	port(
		clk : in std_logic;
		inputs : in std_logic;
		outputs : out std_logic
	);

end entity;

architecture Behavioral of flip_flop_d is

begin 

	process(clk) 
	begin
		if(rising_edge(Clk)) then 
			outputs <= inputs;
		end if;
	end process;

end architecture;