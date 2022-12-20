--***********************************************************************************************-- 
--! File name: full_add_sub.vhd
--! Description: 1-bit full adder-subtractor.
--!
--! Generics: -
--!  
--! Input: 	x :
--!		    y :
--!			borrow_in :
--!		    carry_in :
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
entity full_add_sub is
  port(
		x : in std_logic;
		y : in std_logic;
		borrow_in : in std_logic;
		carry_in : in std_logic;
		s : out std_logic;
		d : out std_logic;
		borrow_out : out std_logic;
		carry_out : out std_logic
  );
end entity full_add_sub;

architecture str of full_add_sub is
	
	signal sig_sd, sig_nx_y : std_logic;

begin
	
	sig_nx_y <= x and not (y); -- Y - X
	sig_sd <=  (not(x) and y) or sig_nx_y;	-- Y - X
	
	-- sig_nx_y <= (not x) and y; -- X - Y
	-- sig_sd <=  (x and (not y)) or sig_nx_y;	-- X - Y
	
	s <= ((not sig_sd) and carry_in) or (sig_sd and (not carry_in));
	d <= ((not borrow_in) and sig_sd) or (borrow_in and (not sig_sd));
	borrow_out <= (borrow_in and (not sig_sd)) or sig_nx_y;
	carry_out <= (x and y) or (sig_sd and carry_in);
end architecture str;