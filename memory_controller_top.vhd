library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work_lib;
use work_lib.memory_controller_top_comp_pkg.all;
use work_lib.memory_controller_top_const_pkg.all;


entity memory_controller_top is 

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
		i_clk		:	in 	std_logic;
		i_rstn		:	in 	std_logic;	
		i_syncrstn	:	in 	std_logic;
		i_datain	:	in 	std_logic_vector (NDataBits - 1 downto 0);
		i_mode		:	in 	std_logic_vector (ModeBits - 1 downto 0);
		i_fm_iter	:	in	std_logic_vector (IterBits - 1 downto 0);
		i_startflag	:	in	std_logic;
		o_endflag	:	out	std_logic;
		Q			:	out std_logic_vector (NDataBits - 1 downto 0)
		);
end memory_controller_top;


architecture rtl of memory_controller_top is

		signal  data		: std_logic_vector ( NDataBits - 1 downto 0);
		signal  endflag	    : std_logic;
		signal  wen		    : std_logic;
		signal  address	    : std_logic_vector ( NAddress - 1 downto 0); 
		signal 	mode		: std_logic_vector (ModeBits - 1 downto 0);
		signal	dataout		: std_logic_vector ( NDataBits - 1 downto 0);
		signal 	fm_iter		: std_logic_vector (IterBits - 1 downto 0);	
		signal 	bwen		: std_logic_vector (NDataBits - 1 downto 0);
		signal  t_bypassen	: std_logic;
		signal  bisten		: std_logic;
		signal  t_wen		: std_logic;
		signal  t_bwen		: std_logic_vector (NDataBits - 1 downto 0);
		signal  t_a			: std_logic_vector (NAddress - 1 downto 0);
		signal  t_d			: std_logic_vector (NDataBits - 1 downto 0);
		signal  t_cen		: std_logic;
		signal  t_scannen	: std_logic;
		signal  t_sin		: std_logic_vector (4 downto 0);
		signal  t_sout		: std_logic_vector (4 downto 0);
		signal  t_nowren	: std_logic;
		signal  t_burnen	: std_logic;
		signal  t_stmc		: std_logic_vector (2 downto 0);
		signal  cen_c		: std_logic;



begin

I_SRAM: lf_15All_sr_111_hd_a_h_7168x20x16_v2_h3_test

generic map ( 
DEPTH		=> DEPTH	,									
WIDTH 	    => WIDTH 	,                           		
NUM_ADDR    => NUM_ADDR		                        		
)                                                   		
                                                    		
                                                    		
port map	(			                            		
		CLK			=> i_clk		,               		
		WEN	        => wen			,               		
		BWEN	    => bwen			,                       
		A	        => address		,                       
		D	        => data			,                       
		CEN	        => cen_c		,                       
		T_BYPASSEN	=> t_bypassen 	,                       
		BISTEN      => bisten     	,                       
		T_WEN	    => t_wen      	,                     	
		T_BWEN	    => t_bwen     	,                       
		T_A	        => t_a			,                       
		T_D	        => t_d			,                       
		T_CEN	    => t_cen		,                       
		T_SCANEN	=> t_scannen	,                       
		T_SIN	    => t_sin		,                       
		T_SOUT	    => t_sout	    ,                       
		T_NOWREN	=> t_nowren		,                       
		T_BURNEN	=> t_burnen		,                       
		T_STMC      => t_stmc		,                       
		Q	        => dataout                         
	);    


I_MEMORY_CONTROLLER: memory_controller	

generic map (
		NDataBits	=> NDataBits	,
		NAddress	=> NAddress	    ,
		MaxAddress	=> MaxAddress	,
		CntBits		=> CntBits		,
		MaxCnt		=> MaxCnt		,
		IterBits	=> IterBits	    ,
		MaxIter		=> MaxIter		,
		MaxCol		=> MaxCol		,
		ModeBits	=> ModeBits
)


port map(
		i_clk		 =>		i_clk		,
		i_rstn		 =>		i_rstn      ,
		i_syncrstn	 =>		i_syncrstn  ,
		i_datain	 =>		i_datain    ,
		i_mode		 =>		i_mode      ,
		i_fm_iter	 =>		i_fm_iter   ,
		i_mem_data	 =>		dataout  	,
		i_startflag  =>		i_startflag ,
		o_cen_c		 =>		cen_c       ,
		o_data		 =>		data	    ,
		o_endflag	 =>		o_endflag     ,
		o_wen		 =>		wen         ,
		o_address	 =>		address     ,
		o_bwen		 =>		bwen	    ,
		o_t_bypassen =>		t_bypassen  ,
		o_bisten	 =>	    bisten	    ,
		o_t_wen		 =>	    t_wen		,
		o_t_bwen	 =>	    t_bwen	    ,
		o_t_a		 =>	    t_a		    ,
		o_t_d		 =>	    t_d		    ,
		o_t_cen		 =>	    t_cen		,
		o_t_scannen	 =>	    t_scannen	,
		o_t_sin		 =>	    t_sin		,
		o_t_sout	 =>	    t_sout	    ,
		o_t_nowren	 =>	    t_nowren	,
		o_t_burnen	 =>	    t_burnen	,
		o_t_stmc	 =>	    t_stmc	
	);
	
end rtl;
