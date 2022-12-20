--***********************************************************************************************-- 
--! File name: mux_2to1
--! 
--! Description: A 2-to-1 multiplexer
--!
--! Generics: DATA_WIDTH : input and output width in bits
--!  
--! Input: in_a : selected when sel = 0
--!		   in_b : selected when sel = 1
--!		   sel : selector
--!
--! Output: output
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

use work.pkg_polar_codec.all;--! Entity/Package Description

entity mux_2to1 is
  generic(
		DATA_WIDTH : natural := 5
	);
	port(
		in_a : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		in_b : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		sel : in std_logic;
		output : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end entity mux_2to1;

architecture rtl of mux_2to1 is

begin
	with sel select
		output <= in_a when '0',
							in_b when '1',
							(others => '0') when others;
							
end architecture rtl;