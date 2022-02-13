----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:31:44 06/30/2020 
-- Design Name: 
-- Module Name:    cpu - Behavioral 
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

entity cpu is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC);
end cpu;

architecture Behavioral of cpu is

	component control
	Port (  clk : in  STD_LOGIC;
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
	end component control;

	component memory
	Port (  clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           memRW : in  STD_LOGIC_VECTOR (1 downto 0);
           addr : in  STD_LOGIC_VECTOR (15 downto 0);
           din : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
	end component memory;
	
	component reg
	Port (  clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           regWrite : in  STD_LOGIC;
           Ra : in  STD_LOGIC_VECTOR (2 downto 0);
           Rb : in  STD_LOGIC_VECTOR (2 downto 0);
           Rw : in  STD_LOGIC_VECTOR (2 downto 0);
           din : in  STD_LOGIC_VECTOR (15 downto 0);
           doutA : out  STD_LOGIC_VECTOR (15 downto 0);
           doutB : out  STD_LOGIC_VECTOR (15 downto 0));
	end component reg;
	
	component PC
	Port (  clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           pcWrite : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
	end component PC;
	
	component alu
	Port (  clk : in  STD_LOGIC;
           aluOp : in  STD_LOGIC_VECTOR (2 downto 0);
           dinA : in  STD_LOGIC_VECTOR (15 downto 0);
           dinB : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
	end component alu;
	
	component extend
	Port ( clk : in  STD_LOGIC;
           extendSe : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (10 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
	end component extend;
	
	component MUX_2_16
	Port ( se : in  STD_LOGIC;
           dinA : in  STD_LOGIC_VECTOR (15 downto 0);
           dinB : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
	end component MUX_2_16;
	
	component MUX_2_3
	Port ( se : in  STD_LOGIC;
           dinA : in  STD_LOGIC_VECTOR (2 downto 0);
           dinB : in  STD_LOGIC_VECTOR (2 downto 0);
           dout : out  STD_LOGIC_VECTOR (2 downto 0));
	end component MUX_2_3;
	
	component MUX_3_16
	Port ( se : in  STD_LOGIC_VECTOR (1 downto 0);
           dinA : in  STD_LOGIC_VECTOR (15 downto 0);
           dinB : in  STD_LOGIC_VECTOR (15 downto 0);
           dinC : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
	end component MUX_3_16;

	signal regDst, memToReg, extendSe, regWrite, aluSrcA, pcWrite, IorD : std_logic := '0';
	signal dataSet : std_logic_vector(15 downto 0) := "0000000000000000";
	signal aluSrcB, memRW : std_logic_vector(1 downto 0) := "00";
	signal aluop : std_logic_vector(2 downto 0) := "000";
	signal pcOut : std_logic_vector(15 downto 0) := "0000000000000000";
	signal aluOut : std_logic_vector(15 downto 0) := "0000000000000000";
	signal addr : std_logic_vector(15 downto 0) := "0000000000000000";
	signal dOutA, dOutB : std_logic_vector(15 downto 0) := "0000000000000000";
	signal ins : std_logic_vector(15 downto 0) := "0000000000000000";
	signal rw : std_logic_vector(2 downto 0) := "000";
	signal regW : std_logic_vector(15 downto 0) := "0000000000000000";
	signal extendOut : std_logic_vector(15 downto 0) := "0000000000000000";
	signal aluA, aluB : std_logic_vector(15 downto 0) := "0000000000000000";
	
	begin
	
	pc_1 : PC
	port map(clk => clk, rst => rst, pcWrite => pcWrite, din => aluOut, dout => pcOut);
	
	mux_1 : MUX_2_16
	port map(se => IorD, dinA => pcOut, dinB => aluOut, dout => addr);
	
	memory_1 : memory
	port map(clk => clk, rst => rst, memRW => memRW, addr => addr, din => dOutB, dout => ins);
	
	mux_2 : MUX_2_3
	port map(se => regDst, dinA => ins(10 downto 8), dinB => ins(4 downto 2), dout => rw);
	
	mux_3 : MUX_2_16
	port map(se => memToReg, dinA => ins, dinB => aluOut, dout => regW);
	
	reg_1 : reg
	port map(clk => clk, rst => rst, regWrite => regWrite, Ra => ins(7 downto 5), Rb => ins(10 downto 8), Rw => rw, din => regW, doutA => dOutA, doutB => dOutB);
	
	extend_1 : extend
	port map(clk => clk, extendSe => extendSe, din => ins(10 downto 0), dout => extendOut);
	
	mux_4 : MUX_3_16
	port map(se => aluSrcB, dinA => dOutB, dinB => extendOut, dinC => dataSet, dout => aluB);
	
	mux_5 : MUX_2_16
	port map(se => aluSrcA, dinA => pcOut, dinB => dOutA, dout => aluA);
	
	alu_1 : alu
	port map(clk => clk, aluop => aluop, dinA => aluA, dinB => aluB, dout => aluOut);
	
	control_1 : control
	port map(clk => clk, rst => rst, ins => ins, regDst => regDst, memToReg => memToReg, extendSe => extendSe, regWrite => regWrite, dataSet => dataSet, aluSrcB => aluSrcB, aluSrcA => aluSrcA, aluop => aluop, pcWrite => pcWrite, memRW => memRW, IorD => IorD);
	
end Behavioral;

