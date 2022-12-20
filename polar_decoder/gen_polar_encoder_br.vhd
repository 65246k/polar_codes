--***********************************************************************************************-- 
--! File name: gen_polar_encoder_br.vhd
--! 
--! Description: Combinational polar encoder. Applies bit-reversal on the input.
--!
--! Generics: GENC_N : block length
--!  
--! Input: fzn_msg(GENC_N) : in std_logic_vector(K-1 downto 0);
--!					
--! Output:	e_msg(GENC_N) : encoded message
--! 
--! Display: -
--!
--! Required files: bit_reverser.vhd, f_one.vhd, gen_polar_encoder.vhd, reverse_shuffler.vhd, pkg_codec_polar.vhd 
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;

--! Local libraries
library work;

use work.pkg_polar_codec.all;
--! Entity/Package Description
entity gen_polar_encoder_br is
	generic(
		GENC_N : natural := 16
	);
	port(
		fzn_msg : in std_logic_vector(GENC_N - 1 downto 0);
		e_msg : out std_logic_vector(GENC_N - 1 downto 0)
	);
end entity gen_polar_encoder_br;

architecture str of gen_polar_encoder_br is

	signal sig_fzn_msg : std_logic_vector(GENC_N - 1 downto 0);

	-- Component declaration: ----------------------------------------------------------------
	component bit_reverser is
	generic(
		DATA_WIDTH : natural := 16
	);
  port(
		br_in : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		br_out : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
	end component bit_reverser;

	component gen_polar_encoder is
	generic(
		GENC_N : natural := 16
	);
	port(
		fzn_msg : in std_logic_vector(GENC_N - 1 downto 0);
		e_msg : out std_logic_vector(GENC_N - 1 downto 0)
	);
	end component gen_polar_encoder;

begin

	inst_bit_reverser : bit_reverser
	generic map(
		DATA_WIDTH => GENC_N
	)
	port map(
		br_in => fzn_msg,
		br_out => sig_fzn_msg
	);

	inst_gen_polar_encoder : gen_polar_encoder
	generic map(
		GENC_N => GENC_N
	)
	port map(
		fzn_msg => sig_fzn_msg,
		e_msg => e_msg
	);
	
end architecture str;