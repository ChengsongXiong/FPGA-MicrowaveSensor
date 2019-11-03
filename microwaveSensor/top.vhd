library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--top模块用于将sensor模块和seg模块连接

entity top is

 	port (clk,echo: in std_logic;	
			trig: out std_logic;
			led: out std_logic_vector(3 downto 0);
			seg_sel: out std_logic_vector(5 downto 0);
			seg_data: out std_logic_vector( 7 downto 0));
end top;


architecture behave of top is 

signal temp:std_logic_vector(23 downto 0);--temp做为中间信号，将两模块的wave_time连接


component seg 	

	port ( clk: in std_logic;
	       wave_time: in std_logic_vector(23 downto 0);
			 seg_sel: out std_logic_vector(5 downto 0);
			 seg_data: out std_logic_vector( 7 downto 0));
end component;		

component sensor 	

	port (clk,echo: in std_logic;	
			trig: out std_logic;
			wave_time:out std_logic_vector(23 downto 0));
			
end component;		

begin 
    u0: sensor port map (clk => clk, echo=>echo, trig=>trig, wave_time=>temp);--实例化sensor
	 u1: seg port map (clk => clk, wave_time=>temp, seg_sel=>seg_sel,seg_data=>seg_data);--实例化seg

		
end behave;