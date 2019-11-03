library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--sensor为传感器模块，它每1s给超声波传感器发送一个20us的脉冲，并记录echo引脚高电平时间。echo引脚高电平时间
--与距离成正比。

entity sensor is
	port (clk,echo: in std_logic;	
			trig: out std_logic;
			wave_time:out std_logic_vector(23 downto 0));
--clk:时钟输入	echo:传感器输出  trig:触发脉冲信号  wave_time:echo高电平持续的时间

end sensor;

architecture rtl of sensor is 

begin 

		process(clk)

		variable trig_count:integer range 0 to 51000000:=0;
		variable echo_count:std_logic_vector(23 downto 0):="000000000000000000000000";
	   variable echo_time:std_logic_vector(23 downto 0):="000000000000000000000000";	
	
		
		begin 
		if (clk'event and clk = '1') then --上升沿触发
					
					wave_time <= echo_time;
				
					if (trig_count < 1000) then --每一秒中trig脉冲时间为20us
					
						trig <= '1';
						trig_count:= trig_count + 1;
						
					elsif ( trig_count >= 1000 and trig_count<50000000) then  
					
						trig <= '0';
						trig_count:= trig_count + 1;
						
					elsif ( trig_count>=50000000) then --trig_count达到50000000后，置0，重新开始循环
					
						trig <= '1';
						trig_count:= 0;	
						echo_count:= "000000000000000000000000";
						
					end if;
				
					if (echo = '1') then 	
					
						echo_count:= echo_count+'1';	--echo_count记录高电平持续次数
						
					elsif (echo = '0') then 		
					
						echo_time:= echo_count;		
						
					end if; 		
					
				end if;		
				
		end process;
		
		
end rtl;