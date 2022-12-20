--***********************************************************************************************-- 
--! File name: generic_polar_encoder.vhd (v1)
--! 
--! Description: Combinational polar encoder.
--!
--! Generics: GENC_N : block length
--!  
--! Input: fzn_msg(GENC_N) : in std_logic_vector(K-1 downto 0);
--!					
--! Output:	e_msg(GENC_N) : encoded message
--! 
--! Display: -
--!
--! Required files: f_one.vhd, reverse_shuffler.vhd, pkg_codec_polar.vhd 
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;

--! Local libraries
library work;
use work.pkg_polar_codec.all;

--! Entity/Package Description
entity gen_polar_encoder is
	generic(
		GENC_N : natural := 16
	);
	port(
		fzn_msg : in std_logic_vector(GENC_N - 1 downto 0);
		e_msg : out std_logic_vector(GENC_N - 1 downto 0)
	);
	end entity gen_polar_encoder;

architecture rtl of gen_polar_encoder is

	constant TOTAL_STAGES : natural := pc_log2(GENC_N);
	type conn_record is record-- To connect generated blocks. 
			rs_to_fone : std_logic_vector(GENC_N - 1 downto 0);
			fone_to_rs : std_logic_vector(GENC_N - 1 downto 0);
		end record;
	type conn_total_stages is array(0 to TOTAL_STAGES - 1) of conn_record;
	signal conn_array : conn_total_stages;
	
	signal sig_fzn_msg : std_logic_vector(GENC_N - 1 downto 0);
	
	-- Component declaration: ----------------------------------------------------------------
	component f_one is
	generic(
		N : natural := 16
	);
  port(
		f_one_in : in std_logic_vector(N - 1 downto 0);
		f_one_out : out std_logic_vector(N - 1 downto 0)
  );
	end component f_one;
	
	component reverse_shuffler is
	generic(
		N : natural := 16
	);
  port(
		r_shuffler_in : in std_logic_vector(N - 1 downto 0);
		r_shuffler_out : out std_logic_vector(N - 1 downto 0)
  );
	end component reverse_shuffler;
	-------------------------------------------------------------------------------------------------
	
begin
	
	sig_fzn_msg <= fzn_msg;
	
	encoder : for i in 0 to (TOTAL_STAGES - 1) generate
	
	begin
		first_blocks : if i = 0 generate -- Fist stage generation.
	
			first_shuffler : reverse_shuffler 
			generic map(
				N => GENC_N
			)
			port map(
				r_shuffler_in => sig_fzn_msg, 
				r_shuffler_out => conn_array(i).rs_to_fone
			);
			
			first_xors : f_one 
			generic map(
				N => GENC_N
			)
			port map(
				f_one_in => conn_array(i).rs_to_fone, 
				f_one_out => conn_array(i).fone_to_rs
			);
		end generate first_blocks;
		
		other_blocks : if i > 0 generate -- Generation of the other blocks.
			
			r_shufflers : reverse_shuffler 
			generic map(
				N => GENC_N
			)
			port map(
				r_shuffler_in => conn_array(i-1).fone_to_rs, 
				r_shuffler_out => conn_array(i).rs_to_fone
			);
			
			xors : f_one 
			generic map(
				N => GENC_N
			)
			port map(
				f_one_in => conn_array(i).rs_to_fone, 
				f_one_out => conn_array(i).fone_to_rs
			);
		end generate other_blocks;
		
	end generate encoder;
	
	e_msg <= conn_array(TOTAL_STAGES - 1).fone_to_rs; -- Output assignment.
	
end architecture rtl;