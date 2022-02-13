----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:04:33 12/18/2018 
-- Design Name: 
-- Module Name:    alu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;





entity alu is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (15 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (15 downto 0);
			  stateCnt: out STD_LOGIC_VECTOR (6 downto 0);
           Cin : in  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Zout : out  STD_LOGIC);
end alu;

architecture Behavioral of alu is

signal state: integer range 0 to 4;
signal a,b,y: std_logic_vector(15 downto 0);	-- oprand a and b, function output to y.
signal opCode: std_logic_vector(3 downto 0);
signal zFlag, cFlag, sFlag, oFlag: std_logic;

begin

process(RST, CLK)
	begin
		if RST = '0' then 
			state <= 0; 
			a<="0000000000000000"; 
			b<="0000000000000000"; 
			opCode<="0000"; 
			output <= (others=>'0'); 
			stateCnt <= not "0000000";
		elsif CLK'event and CLK = '1' then
			case state is			
				when 0 => 
					state <= 1; 
					a <= INPUT; 
					stateCnt <= not "1000000";
					OUTPUT<=a;
				when 1 => 
					state <= 2; 
					b <= INPUT; 
					stateCnt <= not "1111001";
					OUTPUT<=b;
				when 2 => 
					state <= 3; 
					opCode <= input(3 downto 0); 
					stateCnt <= not "0100100"; 
					OUTPUT <= input;
				when 3 => 
					state <= 4; 
					OUTPUT<= y; 
					stateCnt <= not "0110000";
				when 4 => 
					state <= 0; 
					OUTPUT<= "000000000000"& zFlag & cFlag & sFlag & oFlag;stateCnt <= not "0011001";

			end case;
		end if;
	end process;
	
process(RST, opCode)

	begin
			case opCode is
			
			when "0000"	=>	y<= a + b;--加法
			if ("1111111111111111"-a)<b then cFlag<='1';else cFlag<='0';end if;
			if (a(15)='0' and b(15)='0' and y(15)='1') or (a(15)='1' and b(15)='1' and y(15)='0') then oFlag<='1';else oFlag<='0' ;end if;
			if y= "0000000000000000" then zFlag <= '1' ;else zFlag <= '0';end if;
			if y(15)= '1' then sFlag <= '1' ;else sFlag <= '0';end if;
			
			when "0001"	=>	y<= a + (not b) + 1;--减法
			if a>=b then cFlag<='0';else cFlag<='1';end if;
			if (a(15)='0' and b(15)='1' and y(15)='1') or (a(15)='1' and b(15)='0' and y(15)='0') then oFlag<='1';else oFlag<='0' ;end if;
			if y= "0000000000000000" then zFlag <= '1' ;else zFlag <= '0';end if;
			if y(15)= '1' then sFlag <= '1' ;else sFlag <= '0';end if;		
	
			
			when "0010" => y<= a and b;--与
			cFlag<='0';
			oFlag<='0';
			if y= "0000000000000000" then zFlag <= '1' ;else zFlag <= '0';end if;
			if y(15)= '1' then sFlag <= '1' ;else sFlag <= '0';end if;	
			
			when "0011" => y<= a or b;--或			
			cFlag<='0';
			oFlag<='0';
			if y= "0000000000000000" then zFlag <= '1' ;else zFlag <= '0';end if;
			if y(15)= '1' then sFlag <= '1' ;else sFlag <= '0';end if;
			
			when "0100" => y<= a xor b;--异或
			cFlag<='0';
			oFlag<='0';
			if y= "0000000000000000" then zFlag <= '1' ;else zFlag <= '0';end if;
			if y(15)= '1' then sFlag <= '1' ;else sFlag <= '0';end if;
			
			when "0101"	=>	y<= not a;--非 不影响
			
			--when "0110"	=>	y<= a + b + Cin; 
			--when "0111"	=>	y<= a - b - Cin;
			
			when "1000"	=>	y<= to_stdlogicvector(to_bitvector(a) sll conv_integer(b) );--逻辑左移B位
			cFlag<=a(16-conv_integer(b));
			if y= "0000000000000000" then zFlag <= '1' ;else zFlag <= '0';end if;
			if y(15)= '1' then sFlag <= '1' ;else sFlag <= '0';end if;
			
			when "1001"	=>	y<= to_stdlogicvector(to_bitvector(a) srl conv_integer(b) );--逻辑右移B位
			cFlag<=a(conv_integer(b)-1);
			if y= "0000000000000000" then zFlag <= '1' ;else zFlag <= '0';end if;
			if y(15)= '1' then sFlag <= '1' ;else sFlag <= '0';end if;
			
			when "1010"	=>	y<= to_stdlogicvector(to_bitvector(a) sra conv_integer(b) );--算数右移B位
			cFlag<=a(conv_integer(b)-1);
			if y= "0000000000000000" then zFlag <= '1' ;else zFlag <= '0';end if;
			if y(15)= '1' then sFlag <= '1' ;else sFlag <= '0';end if;
			
			when "1011"	=>	y<= to_stdlogicvector(to_bitvector(a) sla conv_integer(b) );--算数左移B位
			cFlag<=a(16-conv_integer(b));
			if y= "0000000000000000" then zFlag <= '1' ;else zFlag <= '0';end if;
			if y(15)= '1' then sFlag <= '1' ;else sFlag <= '0';end if;
			
			when "1100"	=>	y<= to_stdlogicvector(to_bitvector(a) rol conv_integer(b) );--循环左移B位 
			if b="0000000000000001" & (a(0)xor y(0)) then oFlag<='1';else oFlag<='0';end if;
			
			when "1101"=>y<=a+b+cFlag;--adc 拓展
			if ("1111111111111111"-a)<b then cFlag<='1';else cFlag<='0';end if;
			if (a(15)='0' and b(15)='0' and y(15)='1') or (a(15)='1' and b(15)='1' and y(15)='0') then oFlag<='1';else oFlag<='0';end if;
			if y= "0000000000000000" then zFlag<='1';else zFlag<='0';end if;
			if y(15)='1' then sFlag<='1';else sFlag<='0';end if;
			
			when "1110"=>y<=a+(not b)+1-cFlag;--sbb
			if a>=b then cFlag<='0';else cFlag<='1';end if;
			if (a(15)='0' and b(15)='1' and y(15)='1') or (a(15)='1' and b(15)='0' and y(15)='0') then oFlag<='1';else oFlag<='0';end if;
			if y="0000000000000000" then zFlag<='1';else zFlag<='0';end if;
			if y(15)='1' then sFlag<='1';else sFlag<='0';end if;
			
			
			when others=> y<="0000000000000000";
			if y= "0000000000000000" then zFlag <= '1' ;else zFlag <= '0';end if;
			if y(15)= '1' then sFlag <= '1' ;else sFlag <= '0';end if;
			
		end case;
	end process;

end Behavioral;

