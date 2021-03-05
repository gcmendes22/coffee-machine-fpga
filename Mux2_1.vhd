library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux2_1 is
	port(
			sel					:	in 	std_logic;
			dataIn1, dataIn2, dataIn3, dataIn4, dataIn5, dataIn6, dataIn7, dataIn8	:	in 	std_logic_vector(3 downto 0);
			dataOut1, dataOut2, dataOut3, dataOut4, dataOut5, dataOut6, dataOut7, dataOut8	:	out 	std_logic_vector(3 downto 0)
		);

end entity;

architecture Behavioral of Mux2_1 is

begin

	process(sel, dataIn1, dataIn2)
		begin
			case sel is
				when  '1'=> 
						dataOut1 <= "1111";
						dataOut2 <= "1111";
						dataOut3 <= "1111";
						dataOut4 <= "1111";
						dataOut5 <= "1111";
						dataOut6 <= "1111";
						dataOut7 <= "1111";
						dataOut8 <= "1111";			
				when  '0' => 
						dataOut1 <= dataIn1;
						dataOut2 <= dataIn2;
						dataOut3 <= dataIn3;
						dataOut4 <= dataIn4;
						dataOut5 <= dataIn5;
						dataOut6 <= dataIn6;
						dataOut7 <= dataIn7;
						dataOut8 <= dataIn8;		
						
				when others => 
						dataOut1 <= "1110";
						dataOut2 <= "1110";
						dataOut3 <= "1110";
						dataOut4 <= "1110";
						dataOut5 <= "1110";
						dataOut6 <= "1110";
						dataOut7 <= "1110";
						dataOut8 <= "1110";	
			
			end case;
	end process;


end architecture;