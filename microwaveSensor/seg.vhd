library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
--seg为数码管显示模块。它将sensor模块处理得到的wave_time信号处理得到距离的真实值，并在数码管上显示出来。

entity seg is
	port ( clk: in std_logic;
	       wave_time: in std_logic_vector(23 downto 0);
			 seg_sel: out std_logic_vector(5 downto 0);
			 seg_data: out std_logic_vector( 7 downto 0));
end seg;

--seg_sel：数码管选择信号   seg_data：数码管显示数据（共阳极码）

architecture s1 of seg is 


begin 
		process(clk)
		
		variable seg_sel_count:integer range 0 to 10000:=0; 
		variable display_tmp:std_logic_vector(3 downto 0);
		variable echo_time_dec:integer;
		variable echo_distance:integer;
		variable q5,q4,q3,q2,q1,q0:integer;


		begin 
		
		echo_time_dec:= conv_integer(wave_time);--转换为整数型
		echo_distance:=echo_time_dec*34/10000;--计算真实距离
		
		q0 := (echo_distance rem 10);
		q1 := (echo_distance rem 100)/10;
		q2 := (echo_distance rem 1000)/100;
		q3 := (echo_distance rem 10000)/1000;
		q4 := (echo_distance rem 100000)/10000;
		q5 := (echo_distance rem 1000000)/100000;
		--q0-q5:echo_distance各位上的数字
		
		
		if(clk'event and clk = '1') then 
		
		 seg_sel_count :=  seg_sel_count+1;
					
					--六个数码管轮扫显示，利用人眼的视觉暂留实现同时显示的效果
					if ( seg_sel_count = 1000) then
					
						seg_sel <= "111110";
						display_tmp := conv_std_logic_vector(q0,4);
						
					elsif ( seg_sel_count = 2000) then
					
						seg_sel <= "111101";
						display_tmp := conv_std_logic_vector(q1,4);				
						
					elsif ( seg_sel_count = 3000) then
					
						seg_sel <= "111011";
						display_tmp:= conv_std_logic_vector(q2,4);	
					
					elsif ( seg_sel_count = 4000) then
					
						seg_sel <= "110111";
						display_tmp := conv_std_logic_vector(q3,4);	
					
					elsif ( seg_sel_count = 5000) then
					
						seg_sel <= "101111";
						display_tmp:= conv_std_logic_vector(q4,4);		
								
					elsif ( seg_sel_count = 6000) then
					
						seg_sel <= "011111";
						display_tmp := conv_std_logic_vector(q5,4);	
						seg_sel_count:=0;
						
					end if;	
		
					case (display_tmp) is
						
							--0-F的共阳极码
						   
							when "0000" => seg_data <= "11000000";--0
							when "0001" => seg_data <= "11111001";--1
							when "0010" => seg_data <= "10100100";--2
							when "0011" => seg_data <= "10110000";--3
							when "0100" => seg_data <= "10011001";--4
							when "0101" => seg_data <= "10010010";--5
							when "0110" => seg_data <= "10000010";--6
							when "0111" => seg_data <= "11111000";--7
							when "1000" => seg_data <= "10000000";--8
							when "1001" => seg_data <= "10010000";--9
							
							when "1010" => seg_data <= "10001000"; --A
							when "1011" => seg_data <= "10000011"; --B
							when "1100" => seg_data <= "11000110"; --C
							when "1101" => seg_data <= "10100001"; --D
							when "1110" => seg_data <= "10000110"; --E
							when "1111" => seg_data <= "10001110"; --F
							
					end case;
			
		end if;
		
		end process;
		
end s1;