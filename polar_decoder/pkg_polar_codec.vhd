--***********************************************************************************************-- 
--! File name: pkg_polar_codec.vhd
--! 
--! Description: Package containing utilities and constants used by the polar decoder
--!
--! Generics: -
--!  
--! Input: -
--!
--! Output: -
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
package pkg_polar_codec is
	
	-- Constants declaration:
	constant N : natural := 128; -- Encoded message length in bits.
	constant K : natural := 64; -- Unencoded message length in bits.
	constant N_BASE : natural := 4; -- Encoded message length in bits for the base case decoder.
	constant Q_BITS : natural := 5; -- LLR quantization bits (sign + magnitude).
	constant SIGN_BIT : natural := Q_BITS - 1; -- LLR sign bit index.
	constant MAG_BITS : natural := Q_BITS - 1; -- LLR bits to represent magnitude.
	constant ENC_MAX_CNT : natural := 0; -- Max count for the FDM awaiting encoding.
	constant DECO_MAX_CNT : natural := 48; -- Max count for the FDM awaiting decoding.
	
	-- Types declaration:
	subtype llr is std_logic_vector(Q_BITS - 1 downto 0); -- LLR (sign and magnitude).
	subtype llr_mag is std_logic_vector(Q_BITS - 2 downto 0); -- LLR magnitude.
	subtype llr_int is integer range 0 to 2**Q_BITS - 1;
	type llr_base_set is array(0 to N_BASE - 1) of llr;
  type llr_set is array(0 to N - 1) of llr;
	type llr_record is record
			llr_in_rec : llr; --std_logic_vector(Q_BITS - 1 downto 0);
		end record;
	type llr_rec_set is array(natural range <>) of llr_record;	
	
	-- Base 2 log for 32-bit integers
	function pc_log2(arg : in natural) return natural;

	-- Returns a std_logic_vector in bit-reversed order. Function by Jonathan Bromley @ Google groups: comp.lang.vhdl
	function reverse_any_vector(a : in std_logic_vector)	return std_logic_vector;
	
	-- Returns the bit-reversed index
	function bitrev(index : in natural; len : in natural) return natural;
	
end package pkg_polar_codec; 

--! Description of package body (if needed)
package body pkg_polar_codec is
	
	function pc_log2(arg : in natural) return natural is
    variable i : natural;
  begin
    i := 0;  
    while (2**i < arg) and i < 31 loop
      i := i + 1;
    end loop;
    return i;
  end function pc_log2;
	
	function reverse_any_vector(a : in std_logic_vector)	return std_logic_vector is
		variable result : std_logic_vector(a'range);
		alias aa : std_logic_vector(a'reverse_range) is a;
	begin
		for i in aa'range loop
			result(i) := aa(i);
		end loop;
		return result;
	end function reverse_any_vector;
	
	function bitrev(index : in natural; len : in natural) return natural is
		variable auxi_slv : std_logic_vector(pc_log2(len) - 1 downto 0);
		variable br_index : natural;
	begin
    auxi_slv := std_logic_vector(to_unsigned(index, pc_log2(len)));
		br_index := to_integer(unsigned(reverse_any_vector(auxi_slv)));
		return br_index;
  end function bitrev;

end package body pkg_polar_codec;

