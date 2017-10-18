library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


library work_lib;
use work_lib.memory_controller_top_comp_pkg.all;
use work_lib.memory_controller_top_const_pkg.all;


entity memory_controller is 

generic (
NDataBits	: integer := 20; 
NAddress	: integer := 13;
MaxAddress	: integer := 7168;
CntBits		: integer := 8;
MaxCnt		: integer := 256;
IterBits	: integer := 8; 
MaxIter		: integer := 256;
MaxCol		: integer := 56;
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
		i_startflag	:	in 	std_logic;
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
end memory_controller;


architecture rtl of memory_controller is

		type state is (s_idle, s_write, s_read, s_frame_modulation_read, s_frame_modulation_write, s_tdi_read, s_tdi_write, s_test_write, s_test_read);
		
		signal state_q			:	state;
		signal state_d			:	state;
		signal cnt_d			:	std_logic_vector ( CntBits - 1 downto 0);
		signal cnt_q			:	std_logic_vector ( CntBits - 1 downto 0);
		signal address_q		:	std_logic_vector ( NAddress - 1 downto 0);
		signal address_d		:	std_logic_vector ( NAddress - 1 downto 0);
		signal dataout			:	std_logic_vector ( NDataBits - 1 downto 0);
		signal address_int		:	integer range 0 to 20000;
		signal cnt_int			:	integer range 0 to 10000;
		signal address_en		:	std_logic;
		signal wen				:	std_logic;
		signal endflag			:	std_logic;
		signal address_rst		: 	std_logic;
		signal cen_c			:	std_logic;
		signal sum				:	std_logic_vector ( NDataBits - 1 downto 0);
		signal startflag_d		:	std_logic;
		signal startflag_q		:	std_logic;
		signal starttemp_d		: 	std_logic;
		signal starttemp_q		:	std_logic;
		signal start 			:	std_logic;
		signal cnt_col_q		:	std_logic_vector ( CntBits - 1 downto 0);
		signal cnt_col_d		:	std_logic_vector ( CntBits - 1 downto 0);
		signal tdi_sum			:	std_logic_vector ( NDataBits - 1 downto 0);
		signal prev_addr_en		:	std_logic;
		--signal test_cnt			:	std_logic_vector ( NDataBits - 1 downto 0);
		
begin

ff:	process (i_clk, i_rstn)
begin
	if (i_rstn = '0') then
		state_q				<=	s_idle;
		address_q			<=	(others => '0');
		cnt_q				<=	(others => '0');
		startflag_q			<=	'0';
		starttemp_q			<=	'0';
		cnt_col_q			<=	(others => '0');
	elsif (i_clk'event and i_clk = '1') then
		state_q				<=	state_d;
		address_q			<=	address_d;
		cnt_q				<=	cnt_d;
		startflag_q			<=	startflag_d;
		starttemp_q			<=	starttemp_d;
		cnt_col_q			<=	cnt_col_d;
	end if;
end process ff;

startflag_d		<= '0' when (i_syncrstn = '0')	else
					i_startflag;
					
starttemp_d		<=	'0' when (i_syncrstn = '0')	else
					startflag_q;
	
start			<=	'0' when (i_syncrstn = '0')	else 
					(startflag_q and (not starttemp_q)) ;

address_d		<=	(others => '0') when cen_c = '1'  else
					(others => '0') when (i_syncrstn = '0') else
					(others => '0') when (address_rst = '1') else
					address_q + 1 when (address_en = '1') else
					address_q;

address_int		<=	conv_integer(unsigned(address_q));

cnt_int				<= conv_integer(unsigned(cnt_q));

sum				<= i_mem_data + i_datain;

tdi_sum			<= i_mem_data +	i_datain;


fsm_state:	process (state_q, i_mode,  cnt_q, address_int, cnt_int, start, cnt_col_q)

begin

case state_q is

when s_idle						=>		if	(i_mode = "000") and (start = '1') then
											state_d		<=		s_write;
											wen			<=		'1';
											cnt_d		<=		(others => '0');
											address_en	<=		'0';
											address_rst <=		'0';
											endflag		<=		'0';
											cen_c		<= 		'1';
											cnt_col_d	<=		cnt_col_q;
											prev_addr_en<=		'0';
											--test_cnt_d  <=		(others => '0');
										elsif (i_mode = "001") and (start = '1') then
											state_d		<=		s_read;
											wen			<=		'1';
											cnt_d		<=		(others => '0');
											address_en	<=		'0';
											address_rst <=		'0';
											endflag		<=		'0';
											cen_c		<= 		'1';
											cnt_col_d	<=		cnt_col_q;
											prev_addr_en<=		'0';
											--test_cnt_d  <=		(others => '0');
										elsif (i_mode = "010") and (start = '1') then
											state_d		<=		s_frame_modulation_read;
											wen			<=		'1';
											cnt_d		<=		(others => '0');
											address_en	<=		'1';
											address_rst <=		'0';
											endflag		<=		'0';
											cen_c		<= 		'1';
											cnt_col_d	<=		cnt_col_q;
											prev_addr_en<=		'0';
											--test_cnt_d  <=		(others => '0');
										elsif (i_mode = "011") and (start = '1') then
											state_d		<=		s_tdi_read;
											wen			<=		'1';
											cnt_d		<=		(others => '0');
											address_en	<=		'1';
											address_rst <=		'0';
											endflag		<=		'0';
											cen_c		<= 		'1';
											cnt_col_d	<=		cnt_col_q;
											prev_addr_en<=		'0';
											--test_cnt_d  <=		(others => '0');
										elsif (i_mode = "100") and (start = '1') then
											state_d		<=		s_test_write;
											wen			<=		'1';
											cnt_d		<=		(others => '0');
											address_en	<=		'1';
											address_rst <=		'0';
											endflag		<=		'0';
											cen_c		<= 		'1';
											cnt_col_d	<=		cnt_col_q;
											prev_addr_en<=		'0';
											--test_cnt_d  <=		test_cnt_q;
										else
											state_d		<=		s_idle;
											wen			<=		'1';
											cnt_d		<=		(others => '0');
											address_en	<=		'0';
											address_rst <=		'0';
											endflag		<=		'0';
											cen_c		<= 		'1';
											cnt_col_d	<=		cnt_col_q;
											prev_addr_en<=		'0';
											--test_cnt_d  <=		(others => '0');
										end if;
when s_write					=>		if (address_int	< MaxAddress ) then
											if (cnt_int mod 2 = 0) then
												state_d		<=		s_write;
												wen			<=		'0';
												cnt_d		<=		cnt_q + 1;
												address_en	<=		'1';
												address_rst <=		'0';
												endflag		<=		'0';
												cen_c		<= 		'0';
												cnt_col_d	<=		cnt_col_q;
												prev_addr_en<=		'0';
												--test_cnt_d  <=		(others => '0');
											else
												state_d		<=		s_write;
												wen			<=		'0';
												cnt_d		<=		cnt_q + 1;
												address_en	<=		'0';
												address_rst <=		'0';
												endflag		<=		'0';
												cen_c		<= 		'0';
												cnt_col_d	<=		cnt_col_q;
												prev_addr_en<=		'0';
												--test_cnt_d  <=		(others => '0');
											end if;
										else
											state_d		<=		s_idle;
											wen			<=		'1';
											cnt_d		<=		(others => '0');
											address_en	<=		'0';
											address_rst <=		'1';
											endflag		<=		'1';
											cen_c		<= 		'1';
											cnt_col_d	<=		cnt_col_q;
											prev_addr_en<=		'0';
											--test_cnt_d  <=		(others => '0');
										end if;
when s_read					=>		if (address_int	< MaxAddress ) then
											if (cnt_int mod 2 = 0) then
												state_d		<=		s_read;
												wen			<=		'1';
												cnt_d		<=		cnt_q + 1;
												address_en	<=		'1';
												address_rst <=		'0';
												endflag		<=		'0';
												cen_c		<= 		'0';
												cnt_col_d	<=		cnt_col_q;
												prev_addr_en<=		'0';
												--test_cnt_d  <=		(others => '0');
											else
												state_d		<=		s_read;
												wen			<=		'1';
												cnt_d		<=		cnt_q + 1;
												address_en	<=		'1';
												address_rst <=		'0';
												endflag		<=		'0';
												cen_c		<= 		'0';
												cnt_col_d	<=		cnt_col_q;
												prev_addr_en<=		'0';
												--test_cnt_d  <=		(others => '0');
											end if;
										else
											state_d		<=		s_idle;
											wen			<=		'1';
											cnt_d		<=		(others => '0');
											address_en	<=		'0';
											address_rst <=		'1';
											endflag		<=		'1';
											cen_c		<= 		'1';
											cnt_col_d	<=		cnt_col_q;
											prev_addr_en<=		'0';
											--test_cnt_d  <=		(others => '0');
										end if;
when s_frame_modulation_read => 	if (address_int	< MaxAddress ) then
										state_d		<=		s_frame_modulation_write;
										wen			<=		'1';
										cnt_d		<=		cnt_q;
										address_en	<=		'0';
										address_rst <=		'0';
										endflag		<=		'0';
										cen_c		<= 		'0';
										cnt_col_d	<=		cnt_col_q;
										prev_addr_en<=		'0';
										--test_cnt_d  <=		(others => '0');
									else
										state_d		<=		s_idle;
										wen			<=		'1';
										cnt_d		<=		cnt_q;
										address_en	<=		'0';
										address_rst <=		'1';
										endflag		<=		'1';
										cen_c		<= 		'1';
										cnt_col_d	<=		cnt_col_q;
										prev_addr_en<=		'0';
										--test_cnt_d  <=		(others => '0');
									end if;
when s_frame_modulation_write => 	if (address_int	< MaxAddress ) then
										state_d		<=		s_frame_modulation_read;
										wen			<=		'0';
										cnt_d		<=		cnt_q;
										address_en	<=		'1';
										address_rst <=		'0';
										endflag		<=		'0';
										cen_c		<= 		'0';
										cnt_col_d	<=		cnt_col_q;
										prev_addr_en<=		'0';
										--test_cnt_d  <=		(others => '0');
									else
										state_d		<=		s_idle;
										wen			<=		'1';
										cnt_d		<=		cnt_q;
										address_en	<=		'0';
										address_rst <=		'0';
										endflag		<=		'0';
										cen_c		<= 		'1';
										cnt_col_d	<=		cnt_col_q;
										prev_addr_en<=		'0';
										--test_cnt_d  <=		(others => '0');
									end if; 
when s_tdi_read 	          => 	if (address_int	< MaxAddress ) then
										if (cnt_col_q < MaxCol - 1) then
											state_d		<=		s_tdi_write;
											wen			<=		'1';
											cnt_d		<=		cnt_q;
											address_en	<=		'0';
											address_rst <=		'0';
											endflag		<=		'0';
											cen_c		<= 		'0';
											cnt_col_d	<=		cnt_col_q;
											prev_addr_en<=		'1';
											--test_cnt_d  <=		(others => '0');
										else
											state_d		<=		s_tdi_write;
											wen			<=		'1';
											cnt_d		<=		cnt_q;
											address_en	<=		'0';
											address_rst <=		'0';
											endflag		<=		'0';
											cen_c		<= 		'0';
											cnt_col_d	<=		cnt_col_q;
											prev_addr_en<=		'0';
											--test_cnt_d  <=		(others => '0');
										end if;
									else
										state_d		<=		s_idle;
										wen			<=		'1';
										cnt_d		<=		cnt_q;
										address_en	<=		'0';
										address_rst <=		'1';
										endflag		<=		'1';
										cen_c		<= 		'1';
										cnt_col_d	<=		cnt_col_q;
										prev_addr_en<=		'0';
										--test_cnt_d  <=		(others => '0');
									end if;
when s_tdi_write			  =>	if (address_int	< MaxAddress ) then
										if (cnt_col_q < MaxCol - 1) then
											state_d		<=		s_tdi_read;
											wen			<=		'0';
											cnt_d		<=		cnt_q;
											address_en	<=		'1';
											address_rst <=		'0';
											endflag		<=		'0';
											cen_c		<= 		'0';
											cnt_col_d	<=		cnt_col_q + 1;
											prev_addr_en<=		'0';
											--test_cnt_d  <=		(others => '0');
										else
											state_d		<=		s_tdi_read;
											wen			<=		'0';
											cnt_d		<=		cnt_q;
											address_en	<=		'1';
											address_rst <=		'0';
											endflag		<=		'0';
											cen_c		<= 		'0';
											cnt_col_d	<=		(others => '0');
											prev_addr_en<=		'0';
											--test_cnt_d  <=		(others => '0');
										end if;
									else
										state_d		<=		s_idle;
										wen			<=		'1';
										cnt_d		<=		cnt_q;
										address_en	<=		'0';
										address_rst <=		'1';
										endflag		<=		'1';
										cen_c		<= 		'1';
										cnt_col_d	<=		cnt_col_q;
										prev_addr_en<=		'0';
										--test_cnt_d  <=		(others => '0');
									end if;
when s_test_write			=>		if (address_int	< MaxAddress ) then
										state_d		<=		s_test_read;
										wen			<=		'0';
										cnt_d		<=		cnt_q;
										address_en	<=		'0';
										address_rst <=		'0';
										endflag		<=		'0';
										cen_c		<= 		'0';
										cnt_col_d	<=		cnt_col_q;
										prev_addr_en<=		'0';
										--test_cnt_d  <=		test_cnt_q;
									else
										state_d		<=		s_idle;
										wen			<=		'1';
										cnt_d		<=		(others => '0');
										address_en	<=		'0';
										address_rst <=		'1';
										endflag		<=		'1';
										cen_c		<= 		'1';
										cnt_col_d	<=		cnt_col_q;
										prev_addr_en<=		'0';
										--test_cnt_d  <=		(others => '0');
									end if;
when s_test_read			=>		if (address_int	< MaxAddress ) then
										state_d		<=		s_test_write;
										wen			<=		'1';
										cnt_d		<=		cnt_q;
										address_en	<=		'1';
										address_rst <=		'0';
										endflag		<=		'0';
										cen_c		<= 		'0';
										cnt_col_d	<=		cnt_col_q;
										prev_addr_en<=		'0';
										--test_cnt_d  <=		test_cnt_q + 1;
									else
										state_d		<=		s_idle;
										wen			<=		'1';
										cnt_d		<=		(others => '0');
										address_en	<=		'0';
										address_rst <=		'1';
										endflag		<=		'1';
										cen_c		<= 		'1';
										cnt_col_d	<=		cnt_col_q;
										prev_addr_en<=		'0';
										--test_cnt_d  <=		(others => '0');
									end if;
end case;

end process fsm_state;

o_t_bypassen	<=	'1';				-- useless inputs
                                       
o_t_scannen		<=	'1';                -- useless inputs
                                       
o_t_nowren		<=	'1';                -- useless inputs
                                        
o_t_burnen		<=	'1';                -- useless inputs
                                        
o_t_stmc		<=	"000";              -- useless inputs
                                       
o_bisten		<=	'0';                -- useless inputs
                                       
o_t_wen			<=	'0';                -- useless inputs
                                        
o_t_bwen		<= (others => '0');     -- useless inputs
                                        
o_t_a			<= (others => '0');     -- useless inputs
                                       
o_t_d			<= (others => '0');     -- useless inputs
                                        
o_t_cen			<= '0';     			-- useless inputs
                                       
o_t_sin			<= (others => '0');     -- useless inputs
                                      
o_t_sout		<= (others => '0');     -- useless inputs

o_bwen			<= (others => '0');		-- useless inputs

o_data			<= i_datain when (address_int	< MaxAddress ) and (state_q = s_write) else
				   sum when (address_int	< MaxAddress ) and (state_q = s_frame_modulation_write) else
				   tdi_sum when (address_int	< MaxAddress ) and (state_q = s_tdi_write) and (cnt_col_q < MaxCol - 1) else
				   i_datain when (address_int	< MaxAddress ) and (state_q = s_tdi_write) and (cnt_col_q = MaxCol - 1) else
				   "00000110111101101011" when (address_int	< MaxAddress ) and (state_q = s_test_write) else
				   (others => '0');
				   
o_endflag		<= endflag		;
o_wen			<= wen			;
o_address		<= address_q + 1 when prev_addr_en = '1' else
					address_q;
o_cen_c			<= cen_c		;

end rtl;








































