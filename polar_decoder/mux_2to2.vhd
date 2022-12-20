--***********************************************************************************************-- 
--! File name: mux_2to2
--!
--! Description: A 2-to-2 multiplexer or switch
--!
--! Generics: DATA_WIDTH : input and output width in bits
--!  
--! Input: in_a : selected when sel = 0
--!		   in_b : selected when sel = 1
--!		   sel : selector
--!
--! Output: output_a : = in_a if sel = 0 else in_b
--!			output_b : = in_a si sel = 1 else in_a
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
entity mux_2to2 is
  generic(
		DATA_WIDTH : natural := 4
	);
	port(
		in_a : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		in_b : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		sel : in std_logic;
		output_a : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		output_b : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end entity mux_2to2;

architecture rtl of mux_2to2 is

begin
	with sel select
		output_a <= in_a when '0',
								in_b when '1',
								(others => '0') when others;
	with sel select
		output_b <= in_a when '1',
								in_b when '0',
								(others => '0') when others;	
end architecture rtl;