library ieee;
use ieee.std_logic_1164.all;

entity Maq_Cafe is 

	port(
		CLOCK_50 : in std_logic;
		KEY : in std_logic_vector(3 downto 0);
		LEDR : out std_logic_vector(17 downto 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : out std_logic_vector(6 downto 0)
	);

end entity;

architecture Behavioral of Maq_Cafe is

--sinais de controlo
signal s_clk_1Hz, s_clk_2Hz, s_key0, s_key1, s_key2, s_key3 : std_logic;
signal s_blink2, s_blink3, s_led2, s_led3, s_warmed, s_cn_terminated, s_cd_terminated, s_cn_enable, s_cd_enable, s_warm_enable, s_isOn, s_max_coffees_per_round, s_reset_counters_4_15: std_logic;
signal s_dispWARM_0, s_dispWARM_1	: std_logic_vector(3 downto 0);
signal s_tiragem_to_display: std_logic_vector(1 downto 0);
signal s_counter_Coffees99,  s_counter_Coffees4,  s_dispCD, s_dispCN, s_dispTiragens: std_logic_vector(7 downto 0);
signal s_30SEC : std_logic_vector(7 downto 0);
signal s_end30 : std_logic;
signal s_disp0, s_disp1, s_disp2, s_disp3 : std_logic_vector(7 downto 0); 


signal s_add_coffee_normal, s_add_coffee_double : std_logic;

begin 

----Debouncers para as Keys
debouncer0 : entity work.debounceUnit(Behavioral)
					port map(
						refClk => CLOCK_50,
						dirtyIn => KEY(0),
						pulsedOut => s_key0
					);

debouncer1 : entity work.debounceUnit(Behavioral)
					port map(
						refClk => CLOCK_50,
						dirtyIn => KEY(1),
						pulsedOut => s_key1
					);

debouncer2 : entity work.debounceUnit(Behavioral)
					port map(
						refClk => CLOCK_50,
						dirtyIn => KEY(2),
						pulsedOut => s_key2
					);
				
debouncer3 : entity work.debounceUnit(Behavioral)
					port map(
						refClk => CLOCK_50,
						dirtyIn => KEY(3),
						pulsedOut => s_key3
					);
------------------------------------------------------------------------------------------------------------------------------------------------
--Multiplexer usado pela máquina de estados afim de alternar o sinal de dados nos displays entre a informação desejada e tudo desligado.
Mux2_1_0 : entity work.Mux2_1(Behavioral)
	port map(
		sel => s_end30,
		dataIn1 => s_dispWARM_0,
		dataIn2 => s_dispWARM_1,
		dataIn3 => s_30SEC(3 downto 0),
		dataIn4 => s_30SEC(7 downto 4), 
		dataIn5 => "0001", 
		dataIn6 => "0000",
		dataIn7 => s_counter_Coffees99(3 downto 0),
		dataIn8 => s_counter_Coffees99(7 downto 4),
		
		dataOut1 => s_disp0(3 downto 0),
		dataOut2 => s_disp0(7 downto 4),
		dataOut3 => s_disp1(3 downto 0),
		dataOut4 => s_disp1(7 downto 4),
		dataOut5 => s_disp2(3 downto 0),
		dataOut6 => s_disp2(7 downto 4),
		dataOut7 => s_disp3(3 downto 0),
		dataOut8 => s_disp3(7 downto 4)
		
		);
------------------------------------------------------------------------------------------------------------------------------------------------
pulse_generator_1Hz : entity work.TensPulseGen(Behavioral) -- gerador de 1 segundo 
	generic map(
		N => 50000000
	)
	
	port map(
		clkIn => CLOCK_50,
		enable => '1',
		clkOut => s_clk_1Hz
	);
------------------------------------------------------------------------------------------------------------------------------------------------	
Frequancy_div_2Hz: entity work.FreqDivider(Behavioral) -- gerador de 2 Hz para pôr os leds a piscar
	generic map(
		K => 25000000
	)
	
	port map(
		clkIn => CLOCK_50,
		clkOut => s_clk_2Hz
	);

------------------------------------------------------------------------------------------------------------------------------------------------
control_path : entity work.ControlPath(Behavioral)
	port map(
		clock => CLOCK_50,-- Master Clock, é fornecido pela FPGA
		clk_2Hz => s_clk_2Hz,-- relogio para acionar o piscar dos leds nos respetivos estados
		isOn => s_key0,-- ligar a maquina de cafe, passa do estado s_off para o estado s_start
		normal_coffe => s_key1,-- tirar um cafe normal  
		double_coffe => s_key2,-- tirar um cafe duplo
		tc_warm => s_warmed,-- enable para o aquecimento da maquina (15s) 
		tc_normal_coffe => s_cn_terminated,-- enable para tirar o cafe normal
		tc_double_coffe => s_cd_terminated,
		tiragem_to_display => s_tiragem_to_display,
		max_coffees_per_round => s_max_coffees_per_round,--maximo de cafes tirados para voltar a aquecer (4 em 4)
		l_on => LEDR(1), 
		l_cn => s_led2, 
		l_cd => s_led3,  
		l_res => LEDR(5), 
		l_bomb => LEDR(6), 
		en_15 => s_warm_enable, -- enable para comecar a aquecer a maquina
		en_10 => s_cn_enable, -- enable para comecar a tirar o cafe normal
		en_20 => s_cd_enable,-- enable para comecar a tirar o cafe duplo
		add_coffee_normal => s_add_coffee_normal,
		add_coffee_double => s_add_coffee_double,
		reset_counters_4_15 => s_reset_counters_4_15, 
		end30 => s_end30
	);
	
	LEDR(2) <= s_led2;
	LEDR(3) <= s_led3;

------------------------------------------------------------------------------------------------------------------------------------------------
--Contador para o aquecimento da maquina -> 15s (default)		
warm_counter_15s : entity work.Generic_Counter(Behavioral)
	generic map( 
		U => "0101",
		D => "0001"
	)
	
	port map(
		enable => s_warm_enable, -- enable que permite gerar 1 em 1 segundo
		reset => s_reset_counters_4_15, 
		clkin => CLOCK_50,
		Count1 => s_clk_1Hz,
		Count2 => '0',
		countend => s_warmed, -- indicador de que a maquina esta pronta para tirar cafes
		display0 => s_dispWARM_0, -- display para as unidades
		display1 => s_dispWARM_1 -- display para as dezenas
	);
------------------------------------------------------------------------------------------------------------------------------------------------
--Contador para o desligamento automático (30s por default) 
auto_off : entity work.Generic_Counter(Behavioral)
	generic map( 
		U => "0000",
		D => "0011"
	)
	
	port map(
		enable => '1', -- enable que permite gerar 1 em 1 segundo
		reset => s_key0 or s_key1 or s_key2 or s_key3, 
		clkin => CLOCK_50,
		Count1 => s_clk_1Hz,
		Count2 => '0',
		countend => s_end30, -- indicador de que a maquina esta pronta para tirar cafes
		display0 => s_30SEC(3 downto 0), -- display para as unidades
		display1 => s_30SEC(7 downto 4) -- display para as dezenas
	);

------------------------------------------------------------------------------------------------------------------------------------------------
normal_coffe_counter_10s : entity work.Generic_Counter(Behavioral)
	generic map(
		U => "0000",
		D => "0001"
	)
	
	port map(
		enable =>  s_cn_enable, -- enable que permite gerar 1 em 1 segundo
		reset => s_add_coffee_normal, -- ver
		clkin => CLOCK_50,
		Count1 => s_clk_1Hz,
		Count2 => '0',
		countend => s_cn_terminated, -- indicador de que acabou o tempo da tiragem do cafe normal
		display0 => s_dispCN(3 downto 0), -- display para as unidades
		display1 => s_dispCN(7 downto 4) -- display para as dezenas
	);
------------------------------------------------------------------------------------------------------------------------------------------------
double_coffe_counter_20s : entity work.Generic_Counter(Behavioral)
	generic map(
		U => "0000",
		D => "0010"
	)
	
	port map(
		enable => s_cd_enable , -- enable que permite gerar 1 em 1 segundo
		reset => s_add_coffee_Double, -- ver
		clkin => CLOCK_50,
		Count1 => s_clk_1Hz,
		Count2 => '0',
		countend => s_cd_terminated, -- indicador de que acabou o tempo da tiragem do cafe duplo
		display0 => s_dispCD(3 downto 0), -- display para as unidades
		display1 => s_dispCD(7 downto 4) -- display para as dezenas
	);
------------------------------------------------------------------------------------------------------------------------------------------------	
coffee_counter_max_99 : entity work.Generic_Counter(Behavioral)
	generic map( 
		U => "0101",
		D => "0010"
	)
	
	port map(
		enable => '1', 
		reset => '0', 
		clkin => CLOCK_50,
		Count1 => s_add_coffee_normal,
		Count2 => s_add_coffee_double,
		display0 => s_counter_Coffees99(3 downto 0), -- display para as unidades
		display1 => s_counter_Coffees99(7 downto 4) 	-- display para as dezenas
	);
------------------------------------------------------------------------------------------------------------------------------------------------	
coffee_counter_max_4 : entity work.Generic_Counter(Behavioral)
	generic map( 
		U => "0100",
		D => "0000"
	)
	
	port map(
		enable => '1', -- enable que permite gerar 1 em 1 segundo
		reset => s_reset_counters_4_15, 
		clkin => CLOCK_50,
		Count1 => s_add_coffee_normal,
		Count2 => s_add_coffee_double,
		countend => s_max_coffees_per_round, -- indicador de que a maquina esta pronta para tirar cafes
		display0 => s_counter_Coffees4(3 downto 0), -- display para as unidades
		display1 => s_counter_Coffees4(7 downto 4) -- display para as dezenas
	);
------------------------------------------------------------------------------------------------------------------------------------------------

WARM_disp0 : entity work.Bin7Decoder(Behavioral) 
	port map(
		binInput => s_disp0(3 downto 0),
		decOut_n => HEX0
	);

WARM_disp1 : entity work.Bin7Decoder(Behavioral) 
	port map(
		binInput =>  s_disp0(7 downto 4),
		decOut_n => HEX1
	);
------------------------------------------------------------------------------------------------------------------------------------------------
--Display para contagem da tiragem dos cafes -- a maquina de estados define se a contagem se refere a Cafe N ou D
CT_disp0 : entity work.Bin7Decoder(Behavioral) 
	port map(
		binInput =>  s_disp1(3 downto 0),
		decOut_n => HEX2
	);

CT_disp1 : entity work.Bin7Decoder(Behavioral) 
	port map(
		binInput =>  s_disp1(7 downto 4),
		decOut_n => HEX3
	);
------------------------------------------------------------------------------------------------------------------------------------------------
	
CC4_disp0 : entity work.Bin7Decoder(Behavioral) 
	port map(
		binInput =>  s_disp2(3 downto 0),----s_counter_Coffees4(3 downto 0),
		decOut_n => HEX4
	);

CC4_disp1 : entity work.Bin7Decoder(Behavioral) 
	port map(
		binInput =>  s_disp2(7 downto 4),-----s_counter_Coffees4(7 downto 4),
		decOut_n => HEX5
	);
	
CC99_disp0 : entity work.Bin7Decoder(Behavioral) 
	port map(
		binInput =>  s_disp3(3 downto 0),
		decOut_n => HEX6
	);

CC99_disp1 : entity work.Bin7Decoder(Behavioral) 
	port map(
		binInput =>  s_disp3(7 downto 4),
		decOut_n => HEX7
	);
------------------------------------------------------------------------------------------------------------------------------------------------
end architecture;



















































































