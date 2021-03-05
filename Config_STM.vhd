library ieee;
use ieee.std_logic_1164.all;

entity Config_STM is 

	port(
		clock : in std_logic;
		Key_inputs : in std_logic_vector(3 downto 1);
	);

end entity;

architecture Behavioral of ControlPath is 

type TState is (s_config_temperature, s_config_standby, s_config_ph , s_config_sink, s_config_restore );
signal pState, nState : TState;

begin 

sync_process : process(clock) -- processo para sincronizar o relogio com os estados
begin 
	if(rising_edge(clock)) then 
		if(isOn = '0') then
			pState <= S_Off;
		else 
			pState <= nState;
		end if;
	end if;
end process;

comb_process : process(pState, isOn) 
begin
	case pState is
	
		when s_config_temperature =>
			
			if(key_inputs(3) = '1') then
				nState <= s_config_standby;
			elsif(key_inputs(2) = '1') then
			elsif(key_inputs(1) = '1') then
			end if;
		
		when s_config_standby => 
		
			if(key_inputs(3) = '1') then
				nState <= s_config_ph;
			elsif(key_inputs(2) = '1') then
			elsif(key_inputs(1) = '1') then
			end if;
	
		when s_config_ph =>
		
			if(key_inputs(3) = '1') then
				nState <= s_config_sink;
			elsif(key_inputs(2) = '1') then
			elsif(key_inputs(1) = '1') then
			end if;
		
		when s_config_sink =>
		
			if(key_inputs(3) = '1') then
				nState <= s_config_restore;
			elsif(key_inputs(2) = '1') then
			elsif(key_inputs(1) = '1') then
			end if;
			
		when s_config_restore =>
		
			if(key_inputs(3) = '1') then
				nState <= ;
			elsif(key_inputs(2) = '1') then
			elsif(key_inputs(1) = '1') then
			end if;
			
		end case;
end process;
end architecture;