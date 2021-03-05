library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Generic_Counter_Up_Down is
	generic(		UMin : 	unsigned := "0101";
					UMax : 	unsigned := "0101";
					DMin :	unsigned := "0010";
					DMax :	unsigned := "0010"
		);
	port(
			enable, reset, clkin, Count_up, Count_down	:	in 	std_logic;
			DataIn													:	in 	std_logic_vector(7 downto 0)
			countend													:	out 	std_logic;
			display0, display1									:	out 	std_logic_vector(3 downto 0)
		);

end entity;

architecture Behavioral of Generic_Counter is

--signal decimal_counter_up, decimal_top, continuous_decimal_top, max_Reached_Units : std_logic;

begin


--countend <= '1' When (continuous_decimal_top = '1' and max_Reached_Units = '1') else '0';

counter_Units:			entity work.fourbitsCounter_up_down(Behavioral)
									generic map(
										Max						=> UMax, 
										Min						=> UMin
									)
									port map(
										clkin						=> clkin,
										enable					=> enable,
										enable_generic_max	=> ,
										enable_generic_min	=> ,
										reset						=> reset,
										count_up					=> Count_up,
										count_down				=> Count_down,
										dataIn					=> dataIn(3 downto 0),
										nextDigit_up			=> ,
										nextDigit_down			=> , 
										max_Reached				=> ,
										min_Reached				=> ,
										dataOut					=> 
									);
					
counter_decimals:		entity work.fourbitsCounter_up_down(Behavioral)
									generic map(
										Max						=> DMax, 
										Min						=> DMin
									)
									port map(
										clkin						=> clkin,
										enable					=> enable,
										enable_generic_max	=> ,
										enable_generic_min	=> ,
										reset						=> reset,
										count_up					=> ,
										count_down				=> ,
										dataIn					=> dataIn(7 downto 4),
										nextDigit_up			=> ,
										nextDigit_down			=> , 
										max_Reached				=> ,
										min_Reached				=> ,
										dataOut					=> 
									);
									

end architecture;