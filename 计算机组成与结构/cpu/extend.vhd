----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:32:40 06/30/2020 
-- Design Name: 
-- Module Name:    extend - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity extend is
    Port ( clk : in  STD_LOGIC;
           extendSe : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (10 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
end extend;

architecture Behavioral of extend is

begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if(extendSe = '0') then
				if(din(4) = '0') then
					dout <= "00000000000" & din(4 downto 0);
				else
					dout <= "11111111111" & din(4 downto 0);
				end if;
			else
				if(din(4) = '0') then
					dout <= "00000" & din(10 downto 0);
				else
					dout <= "11111" & din(10 downto 0);
				end if;
			end if;
		end if;
	end process;
		
end Behavioral;

