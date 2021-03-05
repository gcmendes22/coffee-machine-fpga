library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Bin7Decoder is
	port(binInput : in std_logic_vector(3 downto 0);
			decOut_n : out std_logic_vector(6 downto 0));
end Bin7Decoder;

architecture Behavioral of Bin7Decoder is
begin

	decOut_n <= 
		"1111001" when (binInput="0001")else --1
		"0100100" when (binInput="0010")else --2
		"0110000" when (binInput="0011")else --3
		"0011001" when (binInput="0100")else --4
		"0010010" when (binInput="0101")else --5
		"0000010" when (binInput="0110")else --6
		"1111000" when (binInput="0111")else --7
		"0000000" when (binInput="1000")else --8
		"0010000" when (binInput="1001")else --9
		"0001000" when (binInput="1010")else --A
		"0000011" when (binInput="1011")else --B
		"1000110" when (binInput="1100")else --C 
		"0100001" when (binInput="1101")else --D
		"0111111" when (binInput="1110")else --_
		"1111111" when (binInput="1111")else --OFF
		"1000000";									 --0
		
		

end Behavioral;
