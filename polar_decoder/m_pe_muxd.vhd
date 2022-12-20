--***********************************************************************************************-- 
--! File name: m_pe_muxd.vhd 
--! 
--! Description: Merged Processing Element implementing both F and G operations. 
--!						 out_lg0 = llr_bot + llr_top, out_lg1 = llr_bot - llr_top
--!
--! Generics: Q_BITS : number of bits for sign-magnitude representation.
--!  		  SIGN_BIT : index of the sign bit
--!
--! Input: in_llr_top : top LLR
--!		   in_llr_bot : llr inferior
--!		   in_partial_sum : suma parcial para decisión
--!
--! Output: out_lg : top G LLR (adds if partial sum = 0, subtracts if partial sum = 1)
--!         out_lf : F LLR
--!
--! Display: -
--!
--! Required files: 	comp_sel_min.vhd, full_add_sub.vhd, half_add_sub.vhd, mux_2to2.vhd,
--!						parametric_and.vhd, parametric_or.vhd, pkg_polar_codec.vhd, saturator.vhd, type_i_pe.vhd, 
--!					    us_compare_agb.vhd
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;

--! Local libraries
library work;

use work.pkg_polar_codec.all;--! Entity/Package Description
entity m_pe_muxd is
  port(
		in_llr_top : in std_logic_vector(Q_BITS - 1 downto 0);
		in_llr_bot : in std_logic_vector(Q_BITS - 1 downto 0);
		in_partial_sum : in std_logic;
		out_lf : out std_logic_vector(Q_BITS - 1 downto 0);
		out_lg :	out std_logic_vector(Q_BITS - 1 downto 0)
  );
end entity m_pe_muxd;

architecture rtl of m_pe_muxd is

	-- Signal declaration:
	signal sig_minsub_sw, sig_dif_sig: std_logic;
	signal sig_x, sig_y : std_logic_vector(Q_BITS - 2 downto 0); -- Type I PE input
	signal sig_s, sig_d : std_logic_vector(Q_BITS - 2 downto 0); -- Type I PE result
	signal sig_cout : std_logic; -- Type I PE carry_out
	signal sig_saturator_out : std_logic_vector(Q_BITS - 2 downto 0); -- Saturator output
	signal sig_slg0, sig_slg1 : std_logic; -- G LLR signs
	signal sig_maglg0, sig_maglg1 : std_logic_vector(Q_BITS - 2 downto 0); --G LLR magnitude
	signal sig_lg0, sig_lg1 : std_logic_vector(Q_BITS - 1 downto 0); -- G LLR

	signal sig_out_slf : std_logic;
	signal sig_out_maglf : std_logic_vector(Q_BITS - 2 downto 0);
	
	signal sig_out_slg0, sig_out_slg1 : std_logic; -- Signos de Lg listo a la salida
	signal sig_out_maglg0, sig_out_maglg1 : std_logic_vector(Q_BITS - 2 downto 0); -- Mags de Lg listas a la salida	
	---------------------------------------------------------------------------
	
begin
	
	sig_dif_sig <= in_llr_top(SIGN_BIT) xor in_llr_bot(SIGN_BIT); -- F operator's sign (also sign difference signal)
	
	-- Component instantiation:
	inst_mux_2to2 : entity work.mux_2to2 
		generic map(
			DATA_WIDTH => MAG_BITS
		)
		port map(
			in_a => sig_saturator_out,
			in_b => sig_d,
			sel => sig_dif_sig, 
			output_a => sig_maglg0,
			output_b => sig_maglg1
		);
		
	inst_saturator : entity work.saturator 
		generic map(
			DATA_WIDTH => MAG_BITS
		)
		port map(						
			sat_sel => sig_cout,
			data_in => sig_s,
			sat_out => sig_saturator_out
		);
		
	inst_type_i_pe : entity work.type_i_pe 
		generic map(
			DATA_WIDTH => MAG_BITS
		)
		port map(	
			x => sig_x,
			y => sig_y,
			s => sig_s,
			d => sig_d,
			borrow_out => OPEN,
			carry_out => sig_cout
		);
		
	inst_comp_sel_min : entity work.comp_sel_min 
		generic map(
			DATA_WIDTH => MAG_BITS
		)
		port map(	
			in_a => in_llr_top(Q_BITS - 2 downto 0),
			in_b => in_llr_bot(Q_BITS - 2 downto 0),
			min_out => sig_x,
			max_out => sig_y,
			data_sw => sig_minsub_sw
		);
		
	inst_g_pe_sign_calc : entity work.g_pe_sign_calc 
		port map(
			minsub_sw => sig_minsub_sw,
			sign_top_in => in_llr_top(SIGN_BIT),
			sign_bot_in => in_llr_bot(SIGN_BIT),
			sign_lg0 => sig_slg0,
			sign_lg1 => sig_slg1
		);
		
	------------------------------------------------------------
	sig_lg0(SIGN_BIT) <= sig_slg0;
	sig_lg0(Q_BITS - 2 downto 0) <= sig_maglg0; 
    sig_lg1(SIGN_BIT) <= sig_slg1;
	sig_lg1(Q_BITS - 2 downto 0) <= sig_maglg1;
	
	out_lf(SIGN_BIT) <= sig_dif_sig; -- Output assignment
	out_lf(Q_BITS - 2 downto 0) <= sig_x;	
	
	with in_partial_sum select -- MUX to select proper G output
		out_lg <= sig_lg0 when '0',
							sig_lg1 when others;
		


		
	end architecture rtl;