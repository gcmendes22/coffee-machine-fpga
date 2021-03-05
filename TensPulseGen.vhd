library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity TensPulseGen is
  generic(
    N : positive := 50000000
  );
  port (
    clkIn: in std_logic;
	 enable : in std_logic;
    clkOut : out std_logic
  );
end entity;

architecture Behavioral of TensPulseGen is

  signal s_count : natural := 0;

begin

	process(clkIn, enable)
		begin
			if(enable = '1') then
				if(rising_edge(clkIn)) then
					if(s_count < N-1)then
						s_count<= s_count + 1;
						clkOut <= '0';
					else
						s_count <= 0;
						clkOut <= '1';
					end if;
				end if;
			end if;
	end process;	

end architecture;
