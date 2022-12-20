--***********************************************************************************************-- 
--! File name: type_i_pe.vhd
--! 
--! Description: Adder-subtractor (simultaneous) to implement the G operation in the polar decoder. 
--!				 Outputs Y+X and Y-X.
--!
--! Generics: DATA_WIDTH : data length in bits
--!  
--! Input: 	x : 
--!			y : 
--!				
--! Output:	s : sum
--! 		d : difference
--!		    borrow_out : 
--!			carry_out : 
--! 
--! Display: -
--!
--! Required files: full_add_sub.vhd, half_add_sub.vhd, pkg_polar_codec.vhd
--!
--! Copyright&copy - Federico Krasser, Universidad Nacional de Mar del Plata, Argentina
--***********************************************************************************************--
library ieee;
use ieee.std_logic_1164.all;

--! Local libraries
library work;

use work.pkg_polar_codec.all;--! Entity/Package Description
entity type_i_pe is
  generic(
		DATA_WIDTH : natural := 4
	);
	port(
		x : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		y : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		s	: out std_logic_vector(DATA_WIDTH - 1 downto 0);
		d : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		borrow_out : out std_logic;
		carry_out : out std_logic
  );
end entity type_i_pe;

architecture str of type_i_pe is

	-- Signals declaration:
	signal sig_s, sig_d : std_logic_vector(DATA_WIDTH - 1 downto 0);
	signal sig_borrow_out, sig_carry_out : std_logic_vector(DATA_WIDTH - 1 downto 0);
	
	-- Components declaration:
	component full_add_sub is
		port(
			x : in std_logic;
			y : in std_logic;
			borrow_in : in std_logic;
			carry_in : in std_logic;
			s : out std_logic;
			d : out std_logic;
			borrow_out : out std_logic;
			carry_out : out std_logic
		);
	end component full_add_sub;

	component half_add_sub is
		port(
			x : in std_logic;
			y : in std_logic;
			s : out std_logic;
			d : out std_logic;
			borrow_out : out std_logic;
			carry_out : out std_logic
		);
	end component half_add_sub;
	
	
begin

	build : for i in 0 to DATA_WIDTH - 1 generate
		
		Q_0 : if i = 0 generate 
			as_0 : half_add_sub port map(
				x => x(i),
				y => y(i),
				s => sig_s(i),
				d => sig_d(i),
				borrow_out => sig_borrow_out(i),
				carry_out => sig_carry_out(i)	
			);
		end generate Q_0;
		
		Q_x : if i > 0 generate 
			as_x : full_add_sub port map(
				x => x(i),
				y => y(i),
				borrow_in => sig_borrow_out(i - 1),
				carry_in => sig_carry_out(i - 1),
				s => sig_s(i),
				d => sig_d(i),
				borrow_out => sig_borrow_out(i),
				carry_out => sig_carry_out(i)
			);
		end generate Q_x;
		
	end generate build;

	s <= sig_s;
	d <= sig_d;
	borrow_out <= sig_borrow_out(DATA_WIDTH - 1);
	carry_out <= sig_carry_out(DATA_WIDTH - 1);
	
end architecture str;