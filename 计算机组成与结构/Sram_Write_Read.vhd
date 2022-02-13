----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:00:08 01/04/2021 
-- Design Name: 
-- Module Name:    Sram_Write_Read - Behavioral 
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

use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sram_Write_Read is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ctrl_r : in  STD_LOGIC;
           ADDR : out  STD_LOGIC_VECTOR (15 downto 0);--地址
           DATA : inout  STD_LOGIC_VECTOR (15 downto 0);--inout 代表双向 数据
           Input_data : in  STD_LOGIC_VECTOR (15 downto 0);
           RAM1_EN : out  STD_LOGIC;--片选信号 RAM1使能
           RAM1_OE : out  STD_LOGIC;--读信号 输出使能
           RAM1_WE : out  STD_LOGIC;--写信号 写使能
           LIGHT : out  STD_LOGIC_VECTOR (15 downto 0);--输出结果 alu里的out 绑定led灯
			  stateCnt: out STD_LOGIC_VECTOR (6 downto 0);--对应七段数码管
           dbc : out  STD_LOGIC);
end Sram_Write_Read;

architecture Behavioral of Sram_Write_Read is
signal tmp_addr:STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal tmp_read_addr:STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal tmp_data:STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal tmp_read_data:STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal to_light:STD_LOGIC_VECTOR (15 downto 0):=x"0000";
type sram_state is(prepare,start,achieve,waiting,over);--枚举类型 定义SRAM状态 写状态
--type read_sram_state is (waiting,start,reading,over);--读取状态
type prj_state is(r,w,n);--枚举类型
signal ctrl_state:prj_state;--枚举类型赋给ctrl_state
signal write_state,read_state:sram_state;
--signal read_state:read_sram_state;
signal state_controler:std_logic_vector(1 downto 0):="00";

begin

process(RST,ctrl_r)
begin
  if RST='0' then
     ctrl_state <=N;   --仅当重置时状态才为N
  elsif  rising_edge(ctrl_r) then
    case ctrl_state is
	  when N =>
        ctrl_state<=W; --重置后开始先写入
	  when W =>
        ctrl_state<=R;  --写后开始读
	  when R => 
        ctrl_state<=W;    --读完再写
	 end case;
	end if;
end process;


process(RST,CLK,ctrl_state)
begin
	if RST='0' then          --重置
   tmp_data <=x"0000";
	tmp_read_addr <=x"0000";
	tmp_addr <=x"0000";		--x表示八进制（应该是十六进制）
	to_light <=x"0000";
	RAM1_EN <= '1';        --RAM1的片选信号1未选中
	RAM1_OE <= '0';        --读信号
	RAM1_WE <= '0';        --写信号
	write_state <= waiting;
	read_state <= waiting;
	stateCnt <= not "0000000";
	elsif rising_edge(CLK) then --clk上升沿
   case ctrl_state is
	  when N =>          --仅当重置时状态才为N，当重置时不需有任何其他操作
	  when W => 
	     to_light<=tmp_data;
		  case write_state is
		     when waiting => --0
			     write_state <= prepare;
				  read_state <=waiting;
				  tmp_addr <= Input_data;
				  stateCnt <= not"1000000";
			  when prepare => --1
			     tmp_data<=Input_data;
				  RAM1_EN <= '0';
	           RAM1_OE <= '1';
	           RAM1_WE <= '1';
				  ADDR <= tmp_addr;
				  DATA <= tmp_data;
				  write_state <= start;
				  stateCnt <= not"1111001";
			  when start => --2
			     ADDR <= tmp_addr;
				  DATA <= tmp_data;
				  RAM1_WE<='0';
				  RAM1_OE<='1';
				  write_state <= achieve;
				  stateCnt <= not"0100100";
				when achieve=> --3
					RAM1_OE<='1';
					RAM1_WE<='0';
					to_light<=DATA;
					write_state<=over;
					stateCnt <= not"0110000";
				when over=> --4
					write_state<=waiting;
					tmp_addr<=tmp_addr + 1;
					stateCnt <= not"0011001";
		end case;
				  				  			  				 			 				  
	 when R=>
		case read_state is
			when waiting => --0
					read_state<=prepare;
					write_state<=waiting;
					stateCnt <= not"1000000";
			when prepare=> --1
					tmp_read_addr<=Input_data;--输入读取的地址位置
					RAM1_EN<='0';
					RAM1_OE<='1';
					RAM1_WE<='1';
					ADDR<=tmp_read_addr;
					DATA<=(others=>'Z');
					read_state<=start;
					stateCnt <= not"1111001";
			when start=> --2
					RAM1_OE<='0';
					RAM1_WE<='1';
					ADDR<=tmp_read_addr;
					read_state<=achieve;
					stateCnt <= not"0100100";
			when achieve=> --3
					RAM1_OE<='0';
					RAM1_WE<='1';
					to_light<=DATA;
					read_state<=over;
					stateCnt <= not"0110000";
			when over=> --4
					read_state<=waiting;
					tmp_read_addr<=tmp_read_addr + 1;
					stateCnt <= not"0011001";
		end case;
	end case;
end if;
dbc<='1';
end process;
 light<=to_light;
end Behavioral;
