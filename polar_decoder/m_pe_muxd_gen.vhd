--***********************************************************************************************-- 
--! File name: m_pe_muxd_gen.vhd
--! 
--! Description: Generates and connects MPEGEN_N/2 m_pe blocks for N inputs
--!
--! Generics: MPEGEN_N : number of inputs
--!  
--! Input:  in_llr : LLR array
--!		    in_partial_sums : vector containing partial sums
--!
--! Output: lfs : array with F operators' outputs
--! 		lgs : array with G operators' outputs
--!
--! Display: -
--!
--! Required files: m_pe_muxd
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! Local libraries
library work;
use work.pkg_polar_codec.all;

--! Entity/Package Description
entity m_pe_muxd_gen is
	generic(
		MPEGEN_N : natural := 8
	);
  port(
		in_llr : in llr_rec_set(0 to MPEGEN_N - 1);
		in_partial_sums : in std_logic_vector(MPEGEN_N/2 - 1 downto 0);
		out_lfs : out llr_rec_set(0 to MPEGEN_N/2 - 1);
		out_lgs : out llr_rec_set(0 to MPEGEN_N/2 - 1)
  );
end entity m_pe_muxd_gen;

architecture str of m_pe_muxd_gen is
	
begin
	
	m_pes : for i in 0 to (MPEGEN_N/2 - 1) generate 
		
	begin	
		m_pe : entity work.m_pe_muxd  -- Type casting to allow defining range as generics
		port map(
			in_llr_top => std_logic_vector((to_unsigned(in_llr(i), Q_BITS))),
			in_llr_bot => std_logic_vector((to_unsigned(in_llr(2*i + 1), Q_BITS))),
			in_partial_sum => in_partial_sums(i),
			to_integer(unsigned(out_lf)) => out_lfs(i),
			to_integer(unsigned(out_lg)) => out_lgs(i)
		);
		
	end generate m_pes;


end architecture str;