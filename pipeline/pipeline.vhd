library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity pipeline is
	generic(
		bus_width : integer := 8
	);
	port(
		clk: in std_logic;
		rst: in std_logic;
		valid_in: in std_logic;
		data_in: in unsigned(bus_width-1 downto 0);
		ready_in: in std_logic;
		valid_out: out std_logic;
		data_out: out unsigned(bus_width-1 downto 0);
		ready_out: out std_logic
	);
end entity pipeline;

architecture behavior of pipeline is

signal ready_r: std_logic;
signal valid_inter: std_logic;
signal data_inter: unsigned(bus_width-1 downto 0);
signal valid_r: std_logic;
signal data_r: unsigned(bus_width-1 downto 0);

begin
	process(clk, rst) is
	begin
		if(rst='0')then 
			valid_inter <= '0';
		elsif rising_edge(clk) then
			valid_out <= valid_r;
			data_out <= data_r;
			
			if(ready_in='1') then
				valid_inter <= '0';
			elsif(ready_r='1') then
				data_inter <= data_in;
				valid_inter <= valid_in;
			end if;
		end if;
	end process;
	
	ready_r <= '1' when valid_inter='0' else '0';
	ready_out <= ready_r;
	
	valid_r <= valid_in or valid_inter;
	data_r <= data_inter when valid_inter='1' else data_in;
end architecture behavior;
	