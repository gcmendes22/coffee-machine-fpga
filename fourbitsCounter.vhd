library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity fourbitsCounter is
	generic(
    N : unsigned := "0101"
   );
	
	port(
		clkin, enable, enable_generic_max, reset, count1, count2 : in std_logic;
		nextDigit, max_Reached: 					out std_logic;
		dataOut: 							out std_logic_vector(3 downto 0)
	);

end entity;

architecture Behavioral of fourbitsCounter is
signal s_count : unsigned(3 downto 0) := "0000";
begin

	process(clkin)
	begin
		if(rising_edge(clkin)) then
			if(reset = '1') then 
				s_count <= "0000";
			elsif(enable = '1') then
			
				if(count1 = '1') then
					if(enable_generic_max = '1' and s_count >= N) then 
						s_count <= N;
					else
						if(s_count >= "1001") then
							s_count <= "0000";
							else
							s_count <= s_count + 1;
						end if;
					end if;
					
				elsif(count2 = '1') then
					if(enable_generic_max = '1' and s_count >= N) then 
						s_count <= N;
					else
						if (s_count >= "1001") then
							s_count <= "0000";
						else
							s_count <= s_count + 2;
						end if;
					end if;
				end if;
			else
				s_count <= s_count;
			end if;
		end if;
	end process;
	nextDigit <= '1' when s_count >= "1001" and enable = '1' else '0';
	max_Reached <= '1' when s_count = N and enable_generic_max = '1' else '0';
	dataOut <= std_logic_vector(s_count);

end architecture;