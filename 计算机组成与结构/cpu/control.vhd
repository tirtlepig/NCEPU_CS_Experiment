----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:53:58 06/30/2020 
-- Design Name: 
-- Module Name:    control - Behavioral 
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

entity control is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ins : in  STD_LOGIC_VECTOR (15 downto 0);
           regDst : out  STD_LOGIC;
           memToReg : out  STD_LOGIC;
           extendSe : out  STD_LOGIC;
           regWrite : out  STD_LOGIC;
           dataSet : out  STD_LOGIC_VECTOR (15 downto 0);
           aluSrcB : out  STD_LOGIC_VECTOR (1 downto 0);
           aluSrcA : out  STD_LOGIC;
           aluop : out  STD_LOGIC_VECTOR (2 downto 0);
           pcWrite : out  STD_LOGIC;
           memRW : out  STD_LOGIC_VECTOR (1 downto 0);
           IorD : out  STD_LOGIC);
end control;

architecture Behavioral of control is
	signal state : std_logic_vector(3 downto 0) := "0000";
begin
	process(rst, clk)   --moore型状态机状态转化
	begin
		if(rst = '0') then
			state <= "1110";
		else
			if(clk'event and clk = '0') then
				if(state = "1110") then
					state <= "0000";
				else
					state <= state + '1';
				end if;
			end if;
		end if;
	end process;
	
	
	process(state)
	begin
		case state is
			when "0000" => 
				regDst <= '0';
				memToReg <= '0';
				extendse <= '0';
				regWrite <= '0';
				dataSet <= "0000000000000000";
				aluSrcB <= "00";
				aluSrcA <= '0';
				aluop <= "000";
				pcWrite <= '0';
				memRW <= "00";
				IorD <= '0';
			when "0001" => 
				regDst <= '0';
				memToReg <= '0';
				extendse <= '0';
				regWrite <= '0';
				dataSet <= "0000000000000010";
				aluSrcB <= "10";
				aluSrcA <= '0';
				aluop <= "001";
				pcWrite <= '0';
				memRW <= "01";
				IorD <= '0';
			when "0010" => 
				regDst <= '0';
				memToReg <= '0';
				extendse <= '0';
				regWrite <= '0';
				dataSet <= "0000000000000000";
				aluSrcB <= "00";
				aluSrcA <= '0';
				aluop <= "000";
				pcWrite <= '1';
				memRW <= "00";
				IorD <= '0';
			when "0011" =>
				regDst <= '0';
				memToReg <= '0';
				extendse <= '0';
				regWrite <= '0';
				dataSet <= "0000000000000000";
				aluSrcB <= "00";
				aluSrcA <= '0';
				aluop <= "000";
				pcWrite <= '0';
				memRW <= "00";
				IorD <= '0';
			when "0100" => null;
			when "0101" => null;
			when "0110" =>
				regDst <= '0';
				memToReg <= '0';
				extendse <= '0';
				regWrite <= '0';
				dataSet <= "0000000000000000";
				aluSrcB <= "00";
				aluSrcA <= '1';
				aluop <= "100";
				pcWrite <= '0';
				memRW <= "00";
				IorD <= '0';
			when "0111" => null;
			when "1000" => null;
			when "1001" => null;
			when "1010" => null;
			when "1011" => null;
			when "1100" =>
				regDst <= '0';
				memToReg <= '1';
				extendse <= '0';
				regWrite <= '1';
				dataSet <= "0000000000000000";
				aluSrcB <= "00";
				aluSrcA <= '0';
				aluop <= "000";
				pcWrite <= '0';
				memRW <= "00";
				IorD <= '0';
			when "1101" => null;
			when "1110" => null;
			when others => null;
		end case;
	end process;

end Behavioral;

