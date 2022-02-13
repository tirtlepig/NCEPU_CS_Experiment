----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:36:20 06/30/2020 
-- Design Name: 
-- Module Name:    MUX_2_16 - Behavioral 
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

entity MUX_2_16 is
    Port ( se : in  STD_LOGIC;
           dinA : in  STD_LOGIC_VECTOR (15 downto 0);
           dinB : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
end MUX_2_16;

architecture Behavioral of MUX_2_16 is

begin
	process(se, dinA, dinB)
	begin
		if(se = '0') then
			dout <= dinA;
		else
			dout <= dinB;
		end if;
	end process;
	
end Behavioral;

