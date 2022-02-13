----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:28:23 06/30/2020 
-- Design Name: 
-- Module Name:    PC - Behavioral 
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

entity PC is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           pcWrite : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
end PC;

architecture Behavioral of PC is
signal tempDout : std_logic_vector(15 downto 0) := "0000000000000000";
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '0') then
				tempDout <= (others => '0');
			elsif (pcWrite = '1') then
				tempDout <= din;
			end if;
			dout <= tempDout;
		end if;
	end process;

end Behavioral;

