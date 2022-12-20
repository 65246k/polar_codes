--***********************************************************************************************-- 
--! File name: base_polar_deco.vhd 
--! 
--! Description: Combinational polar decoder for N = 4. Base case for the recursive decoder.
--!
--! Generics: Constants declared in pkg_polar_codec.
--!  
--! Input:  llr_in : LLR record array.
--!			fzn_bits : frozen bits vector (0 = frozen)
--!
--! Output: fzn_msg : Decoded message.
--! 
--! Display: -
--!
--! Required files: us_compare_agb.vhd, m_pe_muxd.vhd, mux_2to2.vhd, mux_2to1.vhd, type_i_pe,  
--!					parametric_and.vhd, full_add_sub.vhd, half_add_sub.vhd, pkg_codec_polar.vhd 
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;

--! Local libraries
library work;
use work.pkg_polar_codec.all;--! Entity/Package Description

entity base_polar_deco is
	generic(
		BDECO_N : natural := 4
	);
	port(
		--llr_in : in llr_base_set(0 to N_BASE - 1)(Q_BITS - 1 downto 0);
		llr_in : in llr_rec_set(0 to BDECO_N - 1); --type llr_base_set is array(0 to N_BASE - 1) of llr;
															--subtype llr is std_logic_vector(Q_BITS - 1 downto 0); -- LLR with sign and magnitude.
		fzn_bits : in std_logic_vector(BDECO_N - 1 downto 0); -- fzn_bit = 0 if the bit is frozen.
		fzn_msg : out std_logic_vector(BDECO_N - 1 downto 0)
  );
end entity base_polar_deco;

architecture rtl of base_polar_deco is

	-- Signals:
		signal sig_mux_2to1_TOP_in_a, sig_mux_2to1_TOP_in_b, sig_mux_2to1_TOP_output : 
			std_logic_vector(0 downto 0);
		signal sig_mux_2to1_TOP_sel : std_logic;
		signal sig_mux_2to1_BOT_in_a, sig_mux_2to1_BOT_in_b, sig_mux_2to1_BOT_output : 
			std_logic_vector(0 downto 0);
		signal sig_mux_2to1_BOT_sel : std_logic;
		
		signal sig_us_compare_agb_TOP_in_a, sig_us_compare_agb_TOP_in_b : 
			std_logic_vector(Q_BITS - 2 downto 0);
		signal sig_us_compare_agb_TOP_agb : std_logic; 
		signal sig_us_compare_agb_BOT_in_a, sig_us_compare_agb_BOT_in_b : 
			std_logic_vector(Q_BITS - 2 downto 0);
		signal sig_us_compare_agb_BOT_agb : std_logic;
		
		signal sig_out_lf01, sig_out_lf23 : std_logic_vector(Q_BITS - 1 downto 0);
		signal sig_out_lg01, sig_out_lg23 : std_logic_vector(Q_BITS - 1 downto 0);
		
		
		signal sig_xor_sl0_sl1, sig_xor_sl2_sl3 : std_logic;
		signal sig_fzn_msg : std_logic_vector(BDECO_N - 1 downto 0);
		signal sig_slg01, sig_slg23 : std_logic;
		signal sig_xor_slg01_slg23 : std_logic;
		signal sig_partial_sum01, sig_partial_sum23 : std_logic;
		
	-- Component declaration:
	
	component m_pe_muxd is
		port (
			in_llr_top : in std_logic_vector(Q_BITS - 1 downto 0);
			in_llr_bot : in std_logic_vector(Q_BITS - 1 downto 0);
			in_partial_sum : in std_logic;
			out_lf : out std_logic_vector(Q_BITS - 1 downto 0);
			out_lg : out std_logic_vector(Q_BITS - 1 downto 0)
  );
	end component m_pe_muxd;

	component mux_2to1 is
		generic(
			DATA_WIDTH : natural
		);
		port(
			in_a : in std_logic_vector(DATA_WIDTH - 1 downto 0);
			in_b : in std_logic_vector(DATA_WIDTH - 1 downto 0);
			sel : in std_logic;
			output : out std_logic_vector(DATA_WIDTH - 1 downto 0)
		);
	end component mux_2to1;
	
	component us_compare_agb is
  generic(
		DATA_WIDTH : natural
	);
	port(
		in_a : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		in_b : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		agb : out std_logic
  );
	end component us_compare_agb;
	
begin
	
	-- Component instantiation:
	inst_us_compare_agb_TOP : us_compare_agb
		generic map(
			DATA_WIDTH => MAG_BITS
		)
		port map(
			in_a => sig_us_compare_agb_TOP_in_a,
			in_b => sig_us_compare_agb_TOP_in_b,
			agb => sig_us_compare_agb_TOP_agb
  );
	
	inst_mux_2to1_TOP : mux_2to1
		generic map(
			DATA_WIDTH => 1
		)
		port map(
			in_a => sig_mux_2to1_TOP_in_a,
			in_b => sig_mux_2to1_TOP_in_b,
			sel => sig_mux_2to1_TOP_sel,
			output => sig_mux_2to1_TOP_output
	);
	
	inst_m_pe_muxd_01 : m_pe_muxd 
		port map(
			in_llr_top => llr_in(0).llr_in_rec,
			in_llr_bot => llr_in(1).llr_in_rec,
			in_partial_sum => sig_partial_sum01,
			out_lf => sig_out_lf01,
			out_lg => sig_out_lg01
  );
	
	inst_m_pe_muxd_23 : m_pe_muxd 
		port map(
			in_llr_top => llr_in(2).llr_in_rec,
			in_llr_bot => llr_in(3).llr_in_rec,
			in_partial_sum => sig_partial_sum23,
			out_lf => sig_out_lf23,
			out_lg => sig_out_lg23
  );

	inst_us_compare_agb_BOT : us_compare_agb
		generic map(
			DATA_WIDTH => MAG_BITS
		)
		port map(
			in_a => sig_us_compare_agb_BOT_in_a,
			in_b => sig_us_compare_agb_BOT_in_b,
			agb => sig_us_compare_agb_BOT_agb
  );
	
	inst_mux_2to1_BOT : mux_2to1
		generic map(
			DATA_WIDTH => 1
		)
		port map(
			in_a => sig_mux_2to1_BOT_in_a,
			in_b => sig_mux_2to1_BOT_in_b,
			sel => sig_mux_2to1_BOT_sel,
			output => sig_mux_2to1_BOT_output
	);
	--------------------------------------------------------------------------------------
	
	-- Signal assignment:
	------- Top half:
	sig_us_compare_agb_TOP_in_a <= sig_out_lf01(Q_BITS - 2 downto 0);
	sig_us_compare_agb_TOP_in_b <= sig_out_lf23(Q_BITS - 2 downto 0);
	sig_mux_2to1_TOP_sel <= sig_us_compare_agb_TOP_agb; 
	
	sig_xor_sl0_sl1 <= sig_out_lf01(SIGN_BIT);
	sig_xor_sl2_sl3 <= sig_out_lf23(SIGN_BIT); 
	
	sig_fzn_msg(0) <= (sig_xor_sl0_sl1 xor sig_xor_sl2_sl3) and fzn_bits(0);
	
	sig_mux_2to1_TOP_in_a(0) <= sig_xor_sl2_sl3; -- Input inversion for negative SEL MUX.
	sig_mux_2to1_TOP_in_b(0) <= sig_xor_sl0_sl1 xor sig_fzn_msg(0);
	
	sig_fzn_msg(1) <= sig_mux_2to1_TOP_output(0) and fzn_bits(1);
	
	------- Bottom half:
	sig_partial_sum01 <= sig_fzn_msg(0) xor sig_fzn_msg(1);
	sig_partial_sum23 <= sig_fzn_msg(1);
	
	sig_us_compare_agb_BOT_in_a <= sig_out_lg01(Q_BITS - 2 downto 0);
	sig_us_compare_agb_BOT_in_b <= sig_out_lg23(Q_BITS - 2 downto 0);
	sig_mux_2to1_BOT_sel <= sig_us_compare_agb_BOT_agb; 
	
	sig_slg01 <= sig_out_lg01(SIGN_BIT); 
	sig_slg23 <= sig_out_lg23(SIGN_BIT);
	
	sig_xor_slg01_slg23 <= sig_slg01 xor sig_slg23;
	sig_fzn_msg(2) <= sig_xor_slg01_slg23 and fzn_bits(2);
	
	sig_mux_2to1_BOT_in_a(0) <= sig_slg23; -- Input inversion for negative SEL MUX.
	sig_mux_2to1_BOT_in_b(0) <= sig_slg01 xor sig_fzn_msg(2);
	
	sig_fzn_msg(3) <= sig_mux_2to1_BOT_output(0) and fzn_bits(3); 
	
	
	------- Output assignment:
	fzn_msg(0) <= sig_fzn_msg(0);
	fzn_msg(1) <= sig_fzn_msg(1);
	fzn_msg(2) <= sig_fzn_msg(2);
	fzn_msg(3) <= sig_fzn_msg(3);
	
end architecture rtl;