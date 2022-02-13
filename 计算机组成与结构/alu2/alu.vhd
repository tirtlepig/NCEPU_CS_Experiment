----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:17:24 06/24/2020 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0);
           flg : out  STD_LOGIC_VECTOR (3 downto 0));
end alu;

architecture Behavioral of alu is
	signal state : std_logic_vector(1 downto 0) := "00";
	signal a : std_logic_vector(15 downto 0) := "0000000000000000";
	signal b : std_logic_vector(15 downto 0) := "0000000000000000";
	signal op : std_logic_vector(3 downto 0) := "0000";  
begin
	process(rst, clk)   --moore型状态机状态转化
	begin
		if(rst = '0') then
			state <= "10";
		else
			if(clk'event and clk = '1') then
				if(state = "10") then
					state <= "00";
				else
					state <= state + '1';
				end if;
			end if;
		end if;
	end process;

	process(state)
	begin
		case state is
			when "00" => a <= din;
			when "01" => b <= din;
			when "10" => op <= din(15 downto 12);
			when others => a <= din;
		end case;
	end process;
	process(op)
		variable tmp_c : std_logic_vector(15 downto 0) := "0000000000000000";
		variable flag : std_logic_vector(3 downto 0) := "0000";
		variable count : integer range 0 to 16 := 0;
	begin
		if(op = "0001") then
			tmp_c := a + b;
			if(a(15) = '0' and b(15) = '0') then
				flag(3) := '0';
			elsif(a(15) = '1' and b(15) = '1') then
				flag(3) := '1';
			else
				if(tmp_c(15) = '1') then
					flag(3) := '0';
				else
					flag(3) := '1';
				end if;
			end if;
			if((not a(15) = '1') and (not b(15) = '1') and tmp_c(15) = '1') then
				flag(2) := '1';
			elsif(a(15) = '1' and b(15) = '1' and (not tmp_c(15) = '1')) then
				flag(2) := '1';
			else
				flag(2) := '0';
			end if;
		elsif(op = "0010") then
			tmp_c := a - b;
			if(a(15) = '1' and b(15) = '0') then
				flag(3) := '0';
			elsif(a(15) = '0' and b(15) = '1') then
				flag(3) := '1';
			else
				if(tmp_c(15) = '0') then
					flag(3) := '0';
				else
					flag(3) := '1';
				end if;
			end if;
			if((not a(15) = '1') and (b(15) = '1') and (tmp_c(15) = '1')) then
				flag(2) := '1';
			elsif(a(15) = '1' and (not b(15) = '1') and (not tmp_c(15) = '1')) then
				flag(2) := '1';
			else
				flag(2) := '0';
			end if;
		elsif(op = "0011") then
			tmp_c := a and b;
			flag(3) := '0';
			flag(2) := '0';
		elsif(op = "0100") then
			tmp_c := a or b;
			flag(3) := '0';
			flag(2) := '0';
		elsif(op = "0101") then
			tmp_c := a xor b;
			flag(3) := '0';
			flag(2) := '0';
		elsif(op = "0110") then
			tmp_c := not a;
		elsif(op = "0111") then
			tmp_c := a;
			count  := conv_integer(b);
			flag(3) := tmp_c(16 - count);
			tmp_c := to_stdlogicvector( to_bitvector(tmp_c) sll count);
			if(a(15) = tmp_c(15)) then
				flag(2) := '0';
			else
				flag(2) := '1';
			end if;
		elsif(op = "1000") then
			tmp_c := a;
			count  := conv_integer(b);
			flag(3) := tmp_c(count - 1);
			tmp_c := to_stdlogicvector( to_bitvector(tmp_c) srl count);
			if(a(15) = tmp_c(15)) then
				flag(2) := '0';
			else
				flag(2) := '1';
			end if;
		elsif(op = "1001") then
			tmp_c := a;
			count  := conv_integer(b);
			flag(3) := tmp_c(16 - count);
			tmp_c := to_stdlogicvector( to_bitvector(tmp_c) sla count);
			if(a(15) = tmp_c(15)) then
				flag(2) := '0';
			else
				flag(2) := '1';
			end if;
		elsif(op = "1010") then
			tmp_c := a;
			count  := conv_integer(b);
			flag(3) := tmp_c(count - 1);
			tmp_c := to_stdlogicvector( to_bitvector(tmp_c) sra count);
			flag(2) := '0';
		elsif(op = "1011") then
			tmp_c := a;
			count  := conv_integer(b);
			flag(3) := tmp_c(16 - count);
			tmp_c := to_stdlogicvector( to_bitvector(tmp_c) rol count);
			if(a(15) = tmp_c(15)) then
				flag(2) := '0';
			else
				flag(2) := '1';
			end if;
		elsif(op = "1100") then
			tmp_c := a;
			count  := conv_integer(b);
			flag(3) := tmp_c(count - 1);
			tmp_c := to_stdlogicvector( to_bitvector(tmp_c) ror count);
			if(a(15) = tmp_c(15)) then
				flag(2) := '0';
			else
				flag(2) := '1';
			end if;
		elsif(op = "1101") then
			tmp_c := a + b;
			if(flag(3) = '1') then
				tmp_c := tmp_c + '1';
			end if;
			if(a(15) = '0' and b(15) = '0') then
				flag(3) := '0';
			elsif(a(15) = '1' and b(15) = '1') then
				flag(3) := '1';
			else
				if(tmp_c(15) = '1') then
					flag(3) := '0';
				else
					flag(3) := '1';
				end if;
			end if;
			if((not a(15) = '1') and (not b(15) = '1') and tmp_c(15) = '1') then
				flag(2) := '1';
			elsif(a(15) = '1' and b(15) = '1' and (not tmp_c(15) = '1')) then
				flag(2) := '1';
			else
				flag(2) := '0';
			end if;
		elsif(op = "1110") then
			tmp_c := a - b;
			if(flag(3) = '1') then
				tmp_c := tmp_c - '1';
			end if;
			if(a(15) = '1' and b(15) = '0') then
				flag(3) := '0';
			elsif(a(15) = '0' and b(15) = '1') then
				flag(3) := '1';
			else
				if(tmp_c(15) = '0') then
					flag(3) := '0';
				else
					flag(3) := '1';
				end if;
			end if;
			if((not a(15) = '1') and (b(15) = '1') and (tmp_c(15) = '1')) then
				flag(2) := '1';
			elsif(a(15) = '1' and (not b(15) = '1') and (not tmp_c(15) = '1')) then
				flag(2) := '1';
			else
				flag(2) := '0';
			end if;			
		else
			flag(3) := '0';
			flag(2) := '0';
		end if;
		flag(1) := tmp_c(15);
		if(tmp_c = "0000000000000000") then
			flag(0) := '1';
		else
			flag(0) := '0';
		end if;
		dout <= tmp_c;
		flg <= flag;
	end process;		
			
end Behavioral;

