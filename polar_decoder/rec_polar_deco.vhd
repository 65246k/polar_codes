--***********************************************************************************************-- 
--! File name: rec_polar_deco.vhd
--!
--! Description: A recursive polar decoder. Uses Successive Cancelation.
--!
--! Generics: Constantes en pkg_codec_polar.
--!  
--! Input: llr_msg :  record for the channel LLRs
--!        fzn_bits : frozen bits vector (0 = frozen)
--!
--! Output: fzn_msg : decoded message
--! 
--! Display: -
--!
--! Required files: 
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;

--! Local libraries
library work;
use work.pkg_polar_codec.all;

--! Entity/Package Description
entity rec_polar_deco is
	generic(
		RDECO_N : natural := N -- Encoded message length, found in the package
	);
  port(
		llr_msg : in llr_rec_set(0 to RDECO_N - 1);
		fzn_bits : in std_logic_vector(RDECO_N - 1 downto 0);
		fzn_msg : out std_logic_vector(RDECO_N - 1 downto 0)
  );
end entity rec_polar_deco;

architecture rec of rec_polar_deco is
	

	-- Signals declaration:
	signal sig_lfs, sig_lgs : llr_rec_set(0 to RDECO_N/2 - 1);
	signal sig_partial_sums : std_logic_vector(RDECO_N/2 - 1 downto 0);
	signal sig_fzn_msg : std_logic_vector(RDECO_N - 1 downto 0);
	signal sig_fzn_msg_top, sig_fzn_msg_bot : std_logic_vector(RDECO_N/2 - 1 downto 0);
	
	-- Components declaration:
	component base_polar_deco is
	generic(
		BDECO_N : natural
	);
	port(
		llr_in : in llr_rec_set(0 to BDECO_N - 1); --type llr_rec_set is array(natural range <>) of llr_record;	
		fzn_bits : in std_logic_vector(BDECO_N - 1 downto 0); -- fzn_bit = 0 if the bit is frozen.
		fzn_msg : out std_logic_vector(BDECO_N - 1 downto 0)
  );
	end component base_polar_deco;

	component m_pe_muxd_gen is
	generic(
		MPEGEN_N : natural
	);
   port(
		in_llr : in llr_rec_set(0 to MPEGEN_N - 1);
		in_partial_sums : in std_logic_vector(MPEGEN_N/2 - 1 downto 0);
		out_lfs : out llr_rec_set(0 to MPEGEN_N/2 - 1);
		out_lgs : out llr_rec_set(0 to MPEGEN_N/2 - 1)
  );
	end component m_pe_muxd_gen;
	
	component gen_polar_encoder_br is
	generic(
		GENC_N : natural
	);
	port(
		fzn_msg : in std_logic_vector(GENC_N - 1 downto 0);
		e_msg : out std_logic_vector(GENC_N - 1 downto 0)
	);
	end component gen_polar_encoder_br;
	
	component rec_polar_deco is
	generic(
		RDECO_N : natural 
	);
  port(
		llr_msg : in llr_rec_set(0 to RDECO_N - 1);
		fzn_bits : in std_logic_vector(RDECO_N - 1 downto 0);
		fzn_msg : out std_logic_vector(RDECO_N - 1 downto 0)
  );
	end component rec_polar_deco;
	-----------------------------------------------------------

begin

	base_case : if RDECO_N = 8 generate
	begin
		base_mpe_gen : m_pe_muxd_gen
			generic map(
				MPEGEN_N => RDECO_N
			)
			port map(
				in_llr(0 to RDECO_N - 1) => llr_msg(0 to RDECO_N - 1),
				in_partial_sums => sig_partial_sums(RDECO_N/2 - 1 downto 0),
				out_lfs => sig_lfs(0 to RDECO_N/2 - 1),
				out_lgs => sig_lgs(0 to RDECO_N/2 - 1)
			);	
			
		base_deco_top : base_polar_deco
			generic map(
				BDECO_N => RDECO_N/2
			)
			port map(
				llr_in(0 to RDECO_N/2 - 1) => sig_lfs(0 to RDECO_N/2 - 1),
				fzn_bits => fzn_bits(RDECO_N/2 - 1 downto 0),
				fzn_msg => sig_fzn_msg(RDECO_N/2 - 1 downto 0)
			);
		
		base_encoder : gen_polar_encoder_br
			generic map(
				GENC_N => RDECO_N/2
			)
			port map(
				fzn_msg => sig_fzn_msg(RDECO_N/2 - 1 downto 0),
				e_msg => sig_partial_sums(RDECO_N/2 - 1 downto 0)
			);
		
		base_deco_bot : base_polar_deco
			generic map(
				BDECO_N => RDECO_N/2
			)
			port map(
				llr_in(0 to RDECO_N/2 - 1) => sig_lgs(0 to RDECO_N/2 - 1),
				fzn_bits => fzn_bits(RDECO_N - 1 downto RDECO_N/2),
				fzn_msg => sig_fzn_msg(RDECO_N - 1 downto RDECO_N/2)
			);
	end generate base_case;
	
	general_case : if RDECO_N > 8 generate
	begin
		sub_mpe_gen : m_pe_muxd_gen
			generic map(
				MPEGEN_N => RDECO_N
			)
			port map(
				in_llr => llr_msg(0 to RDECO_N - 1),
				in_partial_sums => sig_partial_sums(RDECO_N/2 - 1 downto 0),
				out_lfs(0 to RDECO_N/2 - 1) => sig_lfs(0 to RDECO_N/2 - 1),
				out_lgs => sig_lgs(0 to RDECO_N/2 - 1)
			);
		
		sub_decoder_top : rec_polar_deco
			generic map(
				RDECO_N => RDECO_N/2
			)
			port map(
				llr_msg => sig_lfs(0 to RDECO_N/2 - 1),
				fzn_bits => fzn_bits(RDECO_N/2 - 1 downto 0),
				fzn_msg(RDECO_N/2 - 1 downto 0) => sig_fzn_msg(RDECO_N/2 - 1 downto 0)
			);
			
		sub_encoder : gen_polar_encoder_br 
			generic map(
				GENC_N => RDECO_N/2
			)
			port map(
				fzn_msg => sig_fzn_msg(RDECO_N/2 - 1 downto 0),
				e_msg => sig_partial_sums(RDECO_N/2 - 1 downto 0)
			);	
		
		sub_decoder_bot : rec_polar_deco
			generic map(
				RDECO_N => RDECO_N/2
			)
			port map(
				llr_msg => sig_lgs(0 to RDECO_N/2 - 1),
				fzn_bits => fzn_bits(RDECO_N - 1 downto RDECO_N/2),
				fzn_msg => sig_fzn_msg(RDECO_N - 1 downto RDECO_N/2)
			);
	end generate general_case;

	fzn_msg <= sig_fzn_msg;
	
end architecture rec;
