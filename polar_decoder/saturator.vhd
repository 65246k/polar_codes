--***********************************************************************************************-- 
--! File name: saturator.vhd
--! 
--! Description: A MUX that outputs all 1s when sel = 1 else outputs the input data.
--!
--! Generics: DATA_WIDTH : data width in bits
--!  
--! Input: sat_sel : selector
--!		   data_in : 
--!
--! Output: sat_out :
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
entity saturator is
	generic(
		DATA_WIDTH : natural := 4
	);
  port(
		sat_sel : in std_logic;
		data_in : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		sat_out :out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end entity saturator;

architecture rtl of saturator is

begin
	with sat_sel select
		sat_out <= data_in when '0',
							(others => '1') when others;

end architecture rtl;