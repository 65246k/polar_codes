--***********************************************************************************************-- 
--! File name: bit_reverser.vhd
--! 
--! Description: Applies bit-reversed order to the input.
--!
--! Generics:
--!  
--! Input: br_in:
--!
--! Output: br_out:
--! 
--! Display: -
--!
--! Required files:  -
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;

--! Local libraries
library work;

use work.pkg_polar_codec.all;

--! Entity/Package Description
entity bit_reverser is
	generic(
		DATA_WIDTH : natural := 16
	);
  port(
		br_in : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		br_out : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end entity bit_reverser;

architecture rtl of bit_reverser is

begin

	process(br_in)
	begin
		for i in 0 to DATA_WIDTH - 1 loop
			br_out(i) <= br_in(bitrev(i, DATA_WIDTH));
		end loop;
	end process;

end architecture rtl;