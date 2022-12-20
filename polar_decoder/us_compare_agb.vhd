--***********************************************************************************************-- 
--! File name: us_compare_agb
--! 
--! Description: Salida es '1' si entrada A > entrada B. Sign-less representation.
--!
--! Generics: DATA_WIDTH : cantidad de bits para representación sin signo.
--!  
--! Input: 	in_a :
--!			in_b :
--!
--! Output: agb : equals '1' if input A > input B
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

entity us_compare_agb is
  generic(
		DATA_WIDTH : natural := 4
	);
	port(
		in_a : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		in_b : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		agb : out std_logic
  );
end entity us_compare_agb;

architecture rtl of us_compare_agb is

begin
	agb <= 	'1' when unsigned(in_a) > unsigned(in_b) else
					'0';
	
end architecture rtl;