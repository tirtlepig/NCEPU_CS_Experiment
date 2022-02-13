----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:02:04 06/30/2020 
-- Design Name: 
-- Module Name:    reg - Behavioral 
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

entity reg is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           regWrite : in  STD_LOGIC;
           Ra : in  STD_LOGIC_VECTOR (2 downto 0);
           Rb : in  STD_LOGIC_VECTOR (2 downto 0);
           Rw : in  STD_LOGIC_VECTOR (2 downto 0);
           din : in  STD_LOGIC_VECTOR (15 downto 0);
           doutA : out  STD_LOGIC_VECTOR (15 downto 0);
           doutB : out  STD_LOGIC_VECTOR (15 downto 0));
end reg;

architecture Behavioral of reg is
type arr is array(7 downto 0) of std_logic_vector(15 downto 0);
signal regs : arr := (others => (others => '0'));
begin
	process(clk)
	variable a : integer range 0 to 8 := 0;
	variable b : integer range 0 to 8 := 0;
	variable w : integer range 0 to 8 := 0;
	begin
		if (rising_edge(clk)) then
			if(rst = '0') then
				regs <= (others => (others => '0'));
			elsif(regWrite = '1') then
				w := conv_integer(Rw);
				regs(w) <= din;
			end if;
			a := conv_integer(Ra);
			doutA <= regs(a);
			b := conv_integer(Rb);
			doutB <= regs(b);
		end if;
	end process;
end Behavioral;

