--***********************************************************************************************-- 
--! File name: g_pe_sign_calc.vhd
--! 
--! Description: Sign calculation for G Processing Element or Merged Processing Element
--!
--! Generics: -
--!  
--! Input: minsub_sw : 1 if minuend and subtrahend switched, else 0.
--!		   sign_top_in : top LLR's sign
--!		   sign_bot_in : bottom LLR's sign
--!
--! Output: sign_lg0 : LLR's sign for G when G is adding
--!			sign_lg1 : LLR's sign for G when G is subtracting
--! 
--! Display: -
--!
--! Required files: -
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;

--! Local libraries
library work;

--! Entity/Package Description
entity g_pe_sign_calc is
  port(
		minsub_sw : in std_logic;
		sign_top_in : in std_logic;
		sign_bot_in : in std_logic;
		sign_lg0 : out std_logic;
		sign_lg1 : out std_logic
  );
end entity g_pe_sign_calc;

architecture rtl of g_pe_sign_calc is

	signal mux_out : std_logic;
	
begin

	with minsub_sw select
		mux_out <= sign_bot_in when '0',
							 sign_top_in when '1',
						   '0' when others;

	sign_lg0 <= mux_out;
	sign_lg1 <= mux_out xor minsub_sw;
							 
end architecture rtl;