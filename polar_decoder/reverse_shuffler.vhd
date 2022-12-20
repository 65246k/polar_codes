--***********************************************************************************************-- 
--! File name: reverse_shuffler.vhd (v1)
--! 
--! Description: Shuffles the input message bits, needed for polar encoding. 
--!              Shuffling means grouping 0 and even indices in the lower end of the message, and odd indices in the upper end.
--!
--! Generics: N : encoded message length.
--!  
--! Input: r_shuffler_in(N)
--!
--! Output: r_shuffler_out(N)
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
entity reverse_shuffler is
	generic(
		N : natural := 16
	);
  port(
		r_shuffler_in : in std_logic_vector(N - 1 downto 0);
		r_shuffler_out : out std_logic_vector(N - 1 downto 0)
  );
end entity reverse_shuffler;

architecture rtl of reverse_shuffler is

begin
	
	process(r_shuffler_in)
	begin
		-- E.g.: N=16 -> (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15) <= (0,2,4,6,8,10,12,14,1,3,5,7,9,11,13,15)
		for i in 0 to N/2 - 1 loop -- N=16 -> 0 to 7 
			r_shuffler_out(i) <= r_shuffler_in(2*i);           -- i=0-> (0)<=(0); i=1-> (1)<=(2); i=7-> (7)<=(14)
			r_shuffler_out(i + N/2) <= r_shuffler_in(2*i + 1); -- i=0-> (8)<=(1); i=1-> (9)<=(3); i=7-> (15)<=(15)
		end loop;
	end process;

end architecture rtl;