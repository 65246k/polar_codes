--***********************************************************************************************-- 
--! File name: f_one.vhd (v1)
--! 
--! Description: Applies the F^1 operation on the N input bits, pairwise.
--!
--! Generics: N: coded block length.
--!  
--! Input: f_one_in(N)
--!
--! Output: f_one_out(N)
--! 
--! Display: -
--!
--! Required files: -
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Local libraries
library work;

--! Entity/Package Description
entity f_one is
	generic(
		N : natural := 16
	);
  port(
		f_one_in : in std_logic_vector(N - 1 downto 0);
		f_one_out : out std_logic_vector(N - 1 downto 0)
  );
end entity f_one;

architecture rtl of f_one is

begin
	
	process(f_one_in)
	begin
		for i in 0 to N/2 - 1 loop -- N=16 -> 0 to 7
			f_one_out(2*i) <= f_one_in(2*i) xor f_one_in(2*i + 1); -- i=0 -> (0) xor (1); i=7 -> (14) xor (15)
			f_one_out(2*i + 1) <= f_one_in(2*i + 1); -- i=0 -> (1); i=7 ->(15)
		end loop;
	end process;
	
end architecture rtl;