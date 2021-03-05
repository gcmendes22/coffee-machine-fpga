library ieee;
use ieee.std_logic_1164.all;


entity PhAndDeslcalc is

port(
		clk_50, clk_2Hz	: in std_logic;
		dataIn : in std_logic_vector(7 downto 0):
		displayout: out std_logic_vector(3 downto 0);

	);

end entity;

architecture Behavioral of PhAndDeslcalc is

signal s_out : std_logic_vector(3 downto 0);


begin

process(clk_50, clk_2Hz, dataIn)

	if(rising_edge(clk_50)) then
		
		if(dataIn >= "00100101") then
			
			--Pisca se o numero de cafes for maior que 25 ph a 3 a indicar que precisa de descalcificação
			if(clk_2Hz = '1') then
			
				s_out <= "0011";
				
			else
				
				s_out <= "1111";
			
			end if:
		
		elsif(dataIn >= "00010101") then
			
			--Se o numero de cafes estiver entre 15 e 24 mostra o ph constante a 2
			s_out <= "0010";
			
		else
			
			--Para numero de cafes inferior a 15 mostra ph constante a 1
			s_out <= "0001";
			
		end if;
		
	end if;

end process;

displayout <=

end architecture;