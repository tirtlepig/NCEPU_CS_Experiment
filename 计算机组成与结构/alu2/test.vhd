--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:47:33 06/25/2020
-- Design Name:   
-- Module Name:   D:/XilinxExperiment/alu/test.vhd
-- Project Name:  alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         din : IN  std_logic_vector(15 downto 0);
         dout : OUT  std_logic_vector(15 downto 0);
         flg : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal din : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal dout : std_logic_vector(15 downto 0);
   signal flg : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          clk => clk,
          rst => rst,
          din => din,
          dout => dout,
          flg => flg
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '0';
      wait for clk_period*10;
		-- insert stimulus here 
		rst <= '1';
		din <= "0000000000000001";
      wait for clk_period;
		din <= "0000000000000010";
		wait for clk_period;
		din <= "0001000000000000";
		wait for clk_period;
		
		--0000000000000001 + 0000000000000010 = 0000000000000011      flag:0000
		
		din <= "0000000000000001";
		wait for clk_period;
		din <= "0000000000000010";
		wait for clk_period;
		din <= "0010000000000000";
		wait for clk_period;
		
		--0000000000000001 - 0000000000000010 = 1111111111111111      flag:1010
		
		din <= "0000111100001111";
		wait for clk_period;
		din <= "0000000011111111";
		wait for clk_period;
		din <= "0011000000000000";
		wait for clk_period;
		--0000111100001111 and 0000000011111111 = 0000000000001111    flag:0000
		
		din <= "0000111100001111";
		wait for clk_period;
		din <= "0000000011111111";
		wait for clk_period;
		din <= "0100000000000000";
		wait for clk_period;
		--0000111100001111 or 0000000011111111 = 0000111111111111    flag:0000
		
		din <= "0000111100001111";
		wait for clk_period;
		din <= "0000000011111111";
		wait for clk_period;
		din <= "0101000000000000";
		wait for clk_period;
		--0000111100001111 xor 0000000011111111 = 0000111111110000    flag:0000

		din <= "0000111100001111";
		wait for clk_period;
		din <= "0000000011111111";
		wait for clk_period;
		din <= "0110000000000000";
		wait for clk_period;
		-- not 0000111100001111 = 1111000011110000    flag:不变不变10
		
		din <= "0000111100001111";
		wait for clk_period;
		din <= "0000000000000010";
		wait for clk_period;
		din <= "0111000000000000";
		wait for clk_period;
		--0000111100001111 sll 2 = 0011110000111100    flag:0000
		
		din <= "0000111100001111";
		wait for clk_period;
		din <= "0000000000000010";
		wait for clk_period;
		din <= "1000000000000000";
		wait for clk_period;
		--0000111100001111 slr 2 = 0000001111000011    flag:1000
		
		din <= "1111000011110000";
		wait for clk_period;
		din <= "0000000000000010";
		wait for clk_period;
		din <= "1001000000000000";
		wait for clk_period;
		--1111000011110000 sal 2 = 1100001111000000    flag:1010

		din <= "1111000011110000";
		wait for clk_period;
		din <= "0000000000000010";
		wait for clk_period;
		din <= "1010000000000000";
		wait for clk_period;
		--1111000011110000 sar 2 = 1111110000111100    flag:0010
		
		din <= "1111000011110000";
		wait for clk_period;
		din <= "0000000000000010";
		wait for clk_period;
		din <= "1011000000000000";
		wait for clk_period;
		--1111000011110000 rol 2 = 1100001111000011    flag:1010
		
		din <= "1111000011110000";
		wait for clk_period;
		din <= "0000000000000010";
		wait for clk_period;
		din <= "1100000000000000";
		wait for clk_period;
		--1111000011110000 ror 2 = 0011110000111100    flag:0100
		
		din <= "1111111111111111";
		wait for clk_period;
		din <= "0000000000000001";
		wait for clk_period;
		din <= "0001000000000000";
		wait for clk_period;         --置cf 为1   flag:1001
		
		din <= "0000000000000011";
		wait for clk_period;
		din <= "0000000000000001";
		wait for clk_period;
		din <= "1101000000000000";
		wait for clk_period;
		-- 0000000000000011 ADC 0000000000000001 = 0000000000000101 flag:0000
		
		din <= "1111111111111111";
		wait for clk_period;
		din <= "0000000000000001";
		wait for clk_period;
		din <= "0001000000000000";
		wait for clk_period;         --置cf 为1   flag:1001
		
		din <= "0000000000000011";
		wait for clk_period;
		din <= "0000000000000010";
		wait for clk_period;
		din <= "1110000000000000";
		wait for clk_period;
		-- 0000000000000011 SBB 0000000000000010 = 0000000000000000 flag:0001
		
      wait;
   end process;

END;
