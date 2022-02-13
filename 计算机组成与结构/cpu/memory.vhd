----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:19:35 06/30/2020 
-- Design Name: 
-- Module Name:    memory - Behavioral 
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

entity memory is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           memRW : in  STD_LOGIC_VECTOR (1 downto 0);
           addr : in  STD_LOGIC_VECTOR (15 downto 0);
           din : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
end memory;

architecture Behavioral of memory is
type arr is array(0 to 64) of std_logic_vector(7 downto 0);
signal mem : arr := (others => (others => '0'));
begin
	process(clk)
	variable addrNum : integer range 0 to 64 := 0;
	begin
		if (rising_edge(clk)) then
			addrNum := conv_integer(addr);
			if(rst = '0') then
				mem <= (others => (others => '0'));
			elsif(memRW = "10") then
				mem(addrNum) <= din(7 downto 0);
				mem(addrNum + 1) <= din(15 downto 8);
			elsif(memRW = "01") then
				dout <= mem(addrNum + 1) & mem(addrNum);
			end if;
		end if;
	end process;

end Behavioral;

