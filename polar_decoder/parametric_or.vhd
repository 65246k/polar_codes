--***********************************************************************************************-- 
--! File name: parametric_or.vhd
--! 
--! Description: An N-bit wide OR gate
--!
--! Generics: N : number of inputs
--!  
--! Input: inputs : 
--!
--! Output: output : salida = 0 iff every input = 0
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
entity parametric_or is
	generic(
		N : natural := 4
	);
  port (
		inputs : in std_logic_vector(N - 1 downto 0);
		output : out std_logic
  );
end entity parametric_or;

architecture str of parametric_or is

	signal sig_or : std_logic_vector(N - 1 downto 0);

begin
	
	sig_or(0) <= inputs(0);
	
	build : for i in 1 to N - 1 generate
		sig_or(i) <= sig_or(i - 1) or inputs(i);
	end generate build;
	
	output <= sig_or(N - 1);

end architecture str;