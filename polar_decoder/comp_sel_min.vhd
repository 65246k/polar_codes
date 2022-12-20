--***********************************************************************************************-- 
--! File name: comp_sel_min.vhd
--! 
--! Description: Compares the input magnitudes and selects the correct output. 
--!
--! Generics: DATA_WIDTH : Input and output width.
--!  
--! Input: in_a :
--!		   in_b :
--!
--! Output:  min_out : the smaller input
--!          max_out : the larger input
--!		     data_sw : equals 1 if in_a>in_b
--!			
--! Display: -
--!
--! Required files: mux_2to2.vhd, us_compare_agb
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;

--! Local libraries
library work;

--! Entity/Package Description
entity comp_sel_min is
	generic(
		DATA_WIDTH : natural := 4
	);
  port(
		in_a : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		in_b : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		min_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		max_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		data_sw : out std_logic
	);
end entity comp_sel_min;

architecture str of comp_sel_min is

	signal sig_agb : std_logic;

begin

	inst_comp : entity work.us_compare_agb generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			in_a => in_a,
			in_b => in_b,
			agb => sig_agb
		);

		inst_mux : entity work.mux_2to2 generic map(
			DATA_WIDTH => DATA_WIDTH
		)
		port map(
			in_a => in_a,
			in_b => in_b,
			sel => sig_agb,
			output_a => min_out,
			output_b => max_out
		);

	data_sw <= sig_agb;

end architecture str;