library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Generic_Counter is
	generic(		U : 	unsigned := "0101";
					D :	unsigned := "0010"
		);
	port(
			enable, reset, clkin, Count1, Count2	:	in 	std_logic;
			countend								:	out 	std_logic;
			display0, display1				:	out 	std_logic_vector(3 downto 0)
		);

end entity;

architecture Behavioral of Generic_Counter is

signal decimal_counter_up, decimal_top, continuous_decimal_top, max_Reached_Units : std_logic;

begin


countend <= '1' When (continuous_decimal_top = '1' and max_Reached_Units = '1') else '0';

counter0:	entity work.fourbitsCounter(Behavioral)
					generic map(
						N => U
					)
					port map(
						enable 					=> enable,
						enable_generic_max 	=> continuous_decimal_top,
						clkin						=>	clkin,
						count1					=> Count1,
						count2					=> Count2,
						reset  					=> reset,
						nextDigit				=>	decimal_counter_up,
						max_Reached				=>	max_Reached_Units,
						dataOut 					=>	display0			
					);
					
counter1:	entity work.fourbitsCounter(Behavioral)
					generic map(
						N => D
					)
					port map(
						enable 					=> enable,
						enable_generic_max 	=> '1',
						clkin						=>	clkin,
						count1					=> decimal_counter_up,
						count2					=> '0',	
						reset  					=> reset,
						nextDigit				=>	decimal_top,
						max_Reached				=>	continuous_decimal_top,
						dataOut 					=>	display1			
					);

end architecture;