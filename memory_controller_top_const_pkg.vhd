library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

Package memory_controller_top_const_pkg is

constant clk_period	: time := 12.5 ns;
constant NDataBits	: integer := 20; 
constant NAddress	: integer := 13;
constant MaxAddress	: integer := 7168;
constant CntBits	: integer := 8;
constant MaxCnt		: integer := 256;
constant IterBits	: integer := 8; 
constant MaxIter	: integer := 256;
constant MaxCol		: integer := 56;
constant ModeBits	: integer := 3;

constant DEPTH  	: integer := 7168; 
constant WIDTH  	: integer := 20; 
constant NUM_ADDR 	: integer := 13; 

end memory_controller_top_const_pkg;
