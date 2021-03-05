library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity FreqDivider is
	generic(
    K : positive := 50000000
  );
  port (
    clkIn : in std_logic;
    clkOut : out std_logic
  );
end entity;

architecture Behavioral of FreqDivider is

  signal s_counter : natural;
  signal s_halfway : natural;

begin
  s_halfway <= (k/2);

  po1 : process(clkIn)
  begin
    if (rising_edge(clkIn)) then
      s_counter <= s_counter + 1;
      if (s_counter = s_halfway - 1) then
        clkOut <= '1';
      elsif (s_counter= k - 1) then
        clkOut <= '0';
		  s_counter <= 0;
      end if;
    end if;
  end process;

end architecture;
