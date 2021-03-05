library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity fourbitsCounter_up_down is
	generic(
    Max, Min : unsigned := "0101"
   );
	
	port(
		clkin, enable, enable_generic_max, enable_generic_min, reset, count_up, count_down 	:	in std_logic;
		nextDigit_up, nextDigit_down, max_Reached, min_Reached										:	out std_logic;
		dataIn																										:	in std_logic_vector(3 downto 0);
		dataOut																										:	out std_logic_vector(3 downto 0)
	);

end entity;

architecture Behavioral of fourbitsCounter is
signal s_count : unsigned(3 downto 0) := dataIn;
begin

	process(clkin, reset, enable, count_down, count_up, enable_generic_max, enable_generic_min)
	begin
		if(rising_edge(clkin)) then
			if(reset = '1') then 
				s_count <= "0000";
			elsif(enable = '1') then
			
				if(count_up = '1') then
				
					if(enable_generic_max = '1' and s_count >= Max) then
						s_count <= Max;
					elsif(s_count >= "1001") then
						s_count <= "0000";
					else
						s_count <= s_count + 1;
				elsif(count_down = '1') then
				
					if(enable_generic_min = '1' and s_count <= Min) then
						s_count <= Min;
					elsif(s_count >= "0000") then
						s_count <= "1001";
					else
						s_count <= s_count - 1;
				end if
				
			end if;
		end if;
	end process;
	
	nextDigit_up 	<= '1' when s_count >= "1001" and enable = '1' else '0';
	nextDigit_down <= '1' when s_count >= "0000" and enable = '1' else '0';
	max_Reached 	<= '1' when s_count = Max and enable_generic_max = '1' else '0';
	min_Reached 	<= '1' when s_count = Min and enable_generic_min = '1' else '0';
	dataOut 			<= std_logic_vector(s_count);

end architecture;