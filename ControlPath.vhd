-- Neste ficheiro, implementamos a maquina de estados com todos os estados necessarios para a realizacao
-- deste projeto.

library ieee;
use ieee.std_logic_1164.all;

entity ControlPath is 

	port(
		clock : in std_logic; --x
		clk_2Hz : in std_logic;
		isOn : in std_logic; --
		normal_coffe : in std_logic; --
		double_coffe : in std_logic; --
		tc_warm : in std_logic; --
		tc_normal_coffe : in std_logic; --
		tc_double_coffe : in std_logic; --
		end30 : in std_logic;
		l_on : out std_logic; --
		l_cn : out std_logic; --
		l_cd : out std_logic; --
		l_res : out std_logic; -- 
		l_bomb : out std_logic; --
		en_10 : out std_logic; --
		en_15 : out std_logic; --
		en_20 : out std_logic; --
		max_coffees_per_round : in std_logic;
		tiragem_to_display: out std_logic_vector(1 downto 0);
		add_coffee_normal : out std_logic;
		reset_counters_4_15 : out std_logic;
		add_coffee_double :out std_logic
	);

end entity;

architecture Behavioral of ControlPath is 
--Esatado S_Off -> Estado com tudo desligado
--Estado S_Start -> Estado inicial com entrada ON
--Estado S_Ready -> Estado que é iniciado quando a maquina esta pronta para tirar cafes.
--Estado S_Config -> Estado para a configuracao da maquina
--Estado S_Standby -> Estado que é iniciado quando a maquina se auto desliga
--Estado S_Cn -> Estado para tirar o cafe normal
--Estado S_Cd -> Estado para tirar o cafe duplo
--Estado S_Refresh -> Estado que conta os 4 em 4 cafes+


--Estados S_Congig:
--S_Default -- Neste estado as definições do funcionamento da máquina seram as definições predefinidas
--S_Custom	--	Neste estado as definições do funcionamento da máquina seram as definidas pelo usuário
--S_Set_Warm_Time -- Neste estado o usuário pode definir o o tempo de aquecimento, key1 para baixar o tempo e key2 para subir o tempo, key 3 para mudar de estado
--S_Set_X
--S_set_y

  
type TState is (S_Off,S_start, s_Ready, S_Cn, S_Cd , S_CnDisable, S_CdDisable);
signal pState, nState : TState;
signal s_reset : std_logic := '0';

begin 

sync_process : process(clock, isON) -- processo para sincronizar o relogio com os estados
begin 
	if(rising_edge(clock)) then
		if(s_reset = '0') then
			pstate <= s_off;
		else
			pState <= nstate;
		end if;
	end if;
end process;

comb_process : process(isOn, pstate, normal_coffe, double_coffe, clk_2Hz, tc_normal_coffe, tc_double_coffe) 
begin

	case pState is 
		when S_Off =>
		
			en_10 <= '0';
			en_15 <= '0';
			en_20 <= '0';
			l_on <= '0';
			l_cn <= '0';
			l_cd <= '0';
			l_res <= '0';
			l_bomb <= '0';
			add_coffee_double <= '0';
			add_coffee_normal <= '0';
			reset_counters_4_15 <= '1';
			
			if(isOn = '1') then
				s_reset <= '1';
				nstate <= s_start;
			else 
				nState <= S_off;
			end if;
		
		when S_Start => 
			
			en_10 <= '0';
			en_15 <= '1';
			en_20 <= '0';
			l_on <= '1';
			l_cn <= '1' and clk_2Hz;
			l_cd <= '1' and clk_2Hz;
			l_res <= '1';
			l_bomb <= '0';
			add_coffee_double <= '0';
			add_coffee_normal <= '0';
			reset_counters_4_15 <= '0';
			
			if(end30 = '1') then 
				nState <= s_Off;
			elsif(tc_warm = '1') then --quando acabar de aquecer
				nState <= S_Ready;			
			else
				nState <= S_Start;
			end if;
	
		when S_Ready =>
			
			en_10 <= '0';
			en_15 <= '0';
			en_20 <= '0';
			l_on <= '1';
			l_cn <= '1';
			l_cd <= '1';
			l_res <= '0';
			l_bomb <= '0';
			add_coffee_double <= '0';
			add_coffee_normal <= '0';
			reset_counters_4_15 <= '0';
			
			if(end30 = '1') then 
				nState <= s_Off;
			elsif(max_coffees_per_round = '1') then 
					nState <= S_Off;
			elsif(normal_coffe = '1') then 
					nState <= S_Cn;
			elsif(double_coffe = '1') then 
					nState <= S_Cd;
			else
					nState <= S_Ready;	
			end if;
		
		when S_Cn =>
					
			en_10 <= '1';
			en_15 <= '0';
			en_20 <= '0';
			l_on <= '1';
			l_cn <= '1' and clk_2Hz;
			l_cd <= '0';
			l_res <= '0';
			l_bomb <= '1';
			add_coffee_double <= '0';
			add_coffee_normal <= '0';
			tiragem_to_display(0) <= '1';
			tiragem_to_display(1) <= '0';
			reset_counters_4_15 <= '0';
		
			if(end30 = '1') then 
				nState <= s_Off;
			elsif(normal_coffe = '1') then 
				nState <= S_CnDisable;
			elsif(tc_normal_coffe = '1') then 
				add_coffee_normal <= '1';
				nState <= S_Ready;
			else
				nState <= S_Cn;
			end if;
			
		when S_Cd =>
					
			en_10 <= '0';
			en_15 <= '0';
			en_20 <= '1';
			l_on <= '1';
			l_cn <= '0';
			l_cd <= '1' and clk_2Hz;
			l_res <= '0';
			l_bomb <= '1';
			add_coffee_double <= '0';
			add_coffee_normal <= '0';
			tiragem_to_display(0) <= '0';
			tiragem_to_display(1) <= '1';
			reset_counters_4_15 <= '0';
			
			if(end30 = '1') then 
				nState <= s_Off;
			elsif(double_coffe = '1') then 
				nState <= S_CdDisable;
			elsif(tc_double_coffe = '1') then 
				add_coffee_double <= '1';
				nState <= S_Ready;
			else
				nState <= S_Cd;
			end if;
		
			--- Disabling Counting
			
		when S_CnDisable =>
					
			en_10 <= '0';
			en_15 <= '0';
			en_20 <= '0';
			l_on <= '1';
			l_cn <= '1' and clk_2Hz;
			l_cd <= '0';
			l_res <= '0';
			l_bomb <= '1';
			add_coffee_double <= '0';
			add_coffee_normal <= '0';
			tiragem_to_display(0) <= '1';
			tiragem_to_display(1) <= '0';
			reset_counters_4_15 <= '0';
		
			if(end30 = '1') then 
				nState <= s_Off;
			elsif(normal_coffe = '1') then 
				nState <= S_Cn;
			else
				nState <= S_CnDisable;
			end if;
			
		when S_CdDisable =>
					
			en_10 <= '0';
			en_15 <= '0';
			en_20 <= '0';
			l_on <= '1';
			l_cn <= '0';
			l_cd <= '1' and clk_2Hz;
			l_res <= '0';
			l_bomb <= '1';
			add_coffee_double <= '0';
			add_coffee_normal <= '0';
			tiragem_to_display(0) <= '0';
			tiragem_to_display(1) <= '1';
			reset_counters_4_15 <= '0';
			
			if(end30 = '1') then 
				nState <= s_Off;
			elsif(double_coffe = '1') then 
				nState <= S_Cd;
			else
				nState <= S_CdDisable;
			end if;
			
		when others =>
			nstate <= s_off;
		end case;
end process;
end architecture;
