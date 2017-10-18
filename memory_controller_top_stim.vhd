library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work_lib;
use work_lib.memory_controller_top_comp_pkg.all;
use work_lib.memory_controller_top_const_pkg.all;

entity memory_controller_top_stim is

generic (
NDataBits	: integer := 20; 
NAddress	: integer := 13;
MaxAddress	: integer := 7168;
CntBits		: integer := 8;
MaxCnt		: integer := 256;
IterBits	: integer := 8; 
MaxIter		: integer := 256;
MaxCol		: integer := 56;
ModeBits	: integer := 3;
DEPTH  		: integer := 7168; 
WIDTH  		: integer := 20; 
NUM_ADDR 	: integer := 13

);

port (
		o_clk		:	out 	std_logic;
		o_rstn		:	out 	std_logic;	
		o_syncrstn	:	out 	std_logic;
		o_datain	:	out 	std_logic_vector (NDataBits - 1 downto 0);
		o_mode		:	out 	std_logic_vector (ModeBits - 1 downto 0);
		o_fm_iter	:	out	std_logic_vector (IterBits - 1 downto 0);
		o_startflag	:	out	std_logic;
		i_endflag	:	in std_logic;
		Q			:	in	std_logic_vector (NDataBits - 1 downto 0)
		);
end memory_controller_top_stim;		
		
architecture stim_arch of memory_controller_top_stim is

signal clk		    : std_logic := '0';
signal rstn		    : std_logic;	
signal syncrstn	    : std_logic;
signal datain	    : std_logic_vector (NDataBits - 1 downto 0);
signal mode		    : std_logic_vector (ModeBits - 1 downto 0);
signal fm_iter		: std_logic_vector (IterBits - 1 downto 0);
signal startflag	: std_logic := '0';

begin

clock: process
begin
	wait for clk_period;
		clk <= not clk;
end process clock;

stim: process
begin
datain 	<= "00000000000000000000";
syncrstn<= '0';
mode	<= "100";
rstn	<= '0';
startflag <= '1';
fm_iter	<= "00001010";
wait for 10 ns;
syncrstn <= '1';
rstn	<= '1';
wait for 100 ns;
startflag <= '0';
--wait for 300 ns;
--datain 	<= "00000000010000000000";
--wait for 300 ns;
--datain 	<= "00000000010000000010";
wait for 400000 ns;
mode	<= "001";
wait for 100 ns;
startflag <= '1';
wait for 305 ns;
datain 	<= "00000000010000000000";
startflag <= '0';
wait for 400000 ns;
mode	<= "011";
wait for 100 ns;
startflag <= '1';
wait for 305 ns;
datain 	<= "00000000000000000001";
wait for 400000 ns;
report"Simulation Completed Succesfully!!" severity failure; 
end process stim;

	o_clk		 <=   clk		;
	o_rstn		 <=   rstn		;
	o_syncrstn	 <=   syncrstn	;
	o_datain	 <=   datain	;
	o_mode		 <=   mode		;
	o_fm_iter	 <=	  fm_iter	;
	o_startflag	 <=	  startflag;

end stim_arch;		
