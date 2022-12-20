--***********************************************************************************************-- 
--! File name: half_add_sub.vhd
--! 
--! Description: 1 bit half adder-subtractor.
--!
--! Generics: -
--!  
--! Input: x : 
--!		   y : 
--!				
--! Output: s : sum
--! 		d : subtraction
--!			borrow_out : 
--!			carry_out : 
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
use work.pkg_polar_codec.all;

--! Entity/Package Description
entity half_add_sub is
  port(
		x : in std_logic;
		y : in std_logic;
		s : out std_logic;
		d : out std_logic;
		borrow_out : out std_logic;
		carry_out : out std_logic
  );
end entity half_add_sub;

architecture str of half_add_sub is
	
	signal sig_sd, sig_borrow_out : std_logic;

begin
	
	sig_borrow_out <= x and not(y); -- Y - X
	sig_sd <= sig_borrow_out or (not(x) and y); -- Y - X
	
	-- sig_borrow_out <= not(x) and y; -- X - Y
	-- sig_sd <= sig_borrow_out or (x and not(y)); -- X - Y
	
	carry_out <= x and y;
	borrow_out <= sig_borrow_out;
	s <= sig_sd;
	d <= sig_sd;
	
end architecture str;