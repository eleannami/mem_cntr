library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

Package memory_controller_top_comp_pkg is

component memory_controller

generic (
NDataBits	: integer := 20; 
NAddress	: integer := 13;
MaxAddress	: integer := 7168;
CntBits		: integer := 8;
MaxCnt		: integer := 256;
IterBits	: integer := 8; 
MaxIter		: integer := 256;
MaxCol		: integer := 56 ;
ModeBits	: integer := 3
);


port(
		i_clk		:	in 	std_logic;
		i_rstn		:	in 	std_logic;	
		i_syncrstn	:	in 	std_logic;
		i_datain	:	in 	std_logic_vector (NDataBits - 1 downto 0);
		i_mode		:	in 	std_logic_vector (ModeBits - 1 downto 0);
		i_fm_iter	:	in	std_logic_vector (IterBits - 1 downto 0);
		i_mem_data	:	in	std_logic_vector (NDataBits - 1 downto 0);
		i_startflag	:	in  std_logic;
		o_cen_c		:	out	std_logic;
		o_data		:	out std_logic_vector (NDataBits - 1 downto 0);
		o_endflag	:	out std_logic;
		o_wen		:	out std_logic;
		o_address	:	out	std_logic_vector (NAddress - 1 downto 0);
		o_bwen		:	out std_logic_vector (NDataBits - 1 downto 0);
		o_t_bypassen:	out std_logic;
		o_bisten	:	out std_logic;
		o_t_wen		:	out std_logic;
		o_t_bwen	:	out std_logic_vector (NDataBits - 1 downto 0);
		o_t_a		:	out std_logic_vector (NAddress - 1 downto 0);
		o_t_d		:	out std_logic_vector (NDataBits - 1 downto 0);
		o_t_cen		:	out std_logic;
		o_t_scannen	:	out std_logic;
		o_t_sin		:	out std_logic_vector (4 downto 0);
		o_t_sout	:	out	std_logic_vector (4 downto 0);
		o_t_nowren	:	out std_logic;
		o_t_burnen	:	out	std_logic;
		o_t_stmc	:	out	std_logic_vector (2 downto 0)
		
	);
end component;

component lf_15All_sr_111_hd_a_h_7168x20x16_v2_h3_test

generic (
DEPTH  	 : integer :=	7168; 
WIDTH  	 : integer :=	20; 
NUM_ADDR : integer :=	13
);

port (
		CLK			: in std_logic;
		WEN         : in std_logic;
		BWEN       	: in std_logic_vector  (WIDTH-1 downto 0); 
		A			: in std_logic_vector	(NUM_ADDR-1 downto 0);
		D			: in std_logic_vector  (WIDTH-1 downto 0); 		
		CEN         : in std_logic;
		T_BYPASSEN  : in std_logic;
		BISTEN      : in std_logic;
		T_WEN       : in std_logic;
		T_BWEN		: in std_logic_vector  (WIDTH-1 downto 0);  
		T_A			: in std_logic_vector	(NUM_ADDR-1 downto 0);
		T_D			: in std_logic_vector  (WIDTH-1 downto 0);  							
		T_CEN       : in std_logic;
		T_SCANEN    : in std_logic;
		T_SIN		: in std_logic_vector  (4 downto 0);  				
		T_BURNEN    : in std_logic;
		T_NOWREN    : in std_logic;
		T_STMC		: in std_logic_vector  (2 downto 0);  	
		T_SOUT		: out std_logic_vector  (4 downto 0);  				 
		Q			: out std_logic_vector  (WIDTH-1 downto 0) 					
);
end component;

component memory_controller_top is 

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
end component;

component memory_controller_top_stim is 

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
		o_startflag :	out	std_logic;
		i_endflag	:	in	std_logic;
		Q			:	in	std_logic_vector (NDataBits - 1 downto 0)
		);
end component;


end memory_controller_top_comp_pkg;
