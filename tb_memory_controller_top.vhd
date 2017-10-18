library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work_lib;
use work_lib.memory_controller_top_comp_pkg.all;
use work_lib.memory_controller_top_const_pkg.all;


entity tb_memory_controller_top is 
end tb_memory_controller_top;

architecture tb of tb_memory_controller_top is

	signal	  clk		:	std_logic;
    signal    rstn		:	std_logic;	
    signal    syncrstn	:	std_logic;
    signal    datain	:	std_logic_vector (NDataBits - 1 downto 0);
    signal    mode		:	std_logic_vector (ModeBits - 1 downto 0);
	signal	  Q			:	std_logic_vector (NDataBits - 1 downto 0);
	signal 	  fm_iter	:	std_logic_vector (IterBits - 1 downto 0);	
	signal 	  startflag :	std_logic;
	signal	  endflag	:	std_logic;

begin
		
I_MEMORY_CONTROLLER_TOP: memory_controller_top

generic map ( 

NDataBits	=> NDataBits	,
NAddress	=> NAddress	,
MaxAddress	=> MaxAddress	,
CntBits		=> CntBits	,			
MaxCnt		=> MaxCnt , 
IterBits	=> IterBits ,
MaxIter		=> MaxIter	,
MaxCol		=> MaxCol	,
ModeBits	=> ModeBits ,
DEPTH  		=> DEPTH  ,			
WIDTH  		=> WIDTH  	,	
NUM_ADDR 	=> NUM_ADDR 	
	
)

port map  	(
	i_clk		=> clk		,
	i_rstn		=> rstn		,
	i_syncrstn	=> syncrstn	,
	i_datain	=> datain	,
	i_mode		=> mode		,
	i_fm_iter	=> fm_iter	,
	i_startflag	=> startflag,
	o_endflag	=> endflag	,
	Q			=> Q		
);


I_MEMORY_CONTROLLER_TOP_STIM: memory_controller_top_stim

generic map (  
NDataBits	=> NDataBits	,
NAddress	=> NAddress	,
MaxAddress	=> MaxAddress	,
CntBits		=> CntBits	,			
MaxCnt		=> MaxCnt	,
IterBits	=> IterBits ,
MaxIter		=> MaxIter	,
MaxCol		=> MaxCol	,
ModeBits	=> ModeBits 
)

port map  	(
	o_clk		=> clk		,
	o_rstn		=> rstn		,
	o_syncrstn	=> syncrstn	,
	o_datain	=> datain	,
	o_mode		=> mode		,
	o_fm_iter	=> fm_iter	,
	o_startflag	=> startflag,
	i_endflag	=> endflag	,
	Q			=> Q		
);
			
end tb;
