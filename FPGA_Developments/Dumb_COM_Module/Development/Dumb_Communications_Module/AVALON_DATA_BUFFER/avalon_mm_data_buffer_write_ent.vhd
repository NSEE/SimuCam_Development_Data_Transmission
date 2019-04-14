library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_data_buffer_pkg.all;
use work.avalon_mm_dcom_registers_pkg.all;

entity avalon_mm_data_buffer_write_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_data_buffer_i : in  t_avalon_mm_data_buffer_write_in;
		avs_dbuffer_full_i      : in  std_logic;
		avs_bebuffer_full_i     : in  std_logic;
		avalon_mm_data_buffer_o : out t_avalon_mm_data_buffer_write_out;
		avs_dbuffer_wrreq_o     : out std_logic;
		avs_dbuffer_wrdata_o    : out std_logic_vector((c_AVALON_MM_DATA_BUFFER_DATA_SIZE - 1) downto 0);
		avs_bebuffer_wrreq_o    : out std_logic;
		avs_bebuffer_wrdata_o   : out std_logic_vector(((c_AVALON_MM_DATA_BUFFER_DATA_SIZE / c_AVALON_MM_DATA_BUFFER_SYMBOL_SIZE) - 1) downto 0);
		avalon_mm_dcom_dump_o   : out t_dcom_avs_dump_arr
	);
end entity avalon_mm_data_buffer_write_ent;

architecture RTL of avalon_mm_data_buffer_write_ent is

	signal s_data_written : std_logic;

begin

	p_avalon_mm_data_buffer_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			avs_dbuffer_wrreq_o                      <= '0';
			avs_dbuffer_wrdata_o                     <= (others => '0');
			avs_bebuffer_wrreq_o                     <= '0';
			avs_bebuffer_wrdata_o                    <= (others => '0');
			s_data_written                           <= '0';
			--
			avalon_mm_dcom_dump_o(0).avs_writedata   <= (others => '0');
			avalon_mm_dcom_dump_o(0).avs_byteenable  <= (others => '0');
			avalon_mm_dcom_dump_o(1).avs_writedata   <= (others => '0');
			avalon_mm_dcom_dump_o(1).avs_byteenable  <= (others => '0');
			avalon_mm_dcom_dump_o(2).avs_writedata   <= (others => '0');
			avalon_mm_dcom_dump_o(2).avs_byteenable  <= (others => '0');
			avalon_mm_dcom_dump_o(3).avs_writedata   <= (others => '0');
			avalon_mm_dcom_dump_o(3).avs_byteenable  <= (others => '0');
			avalon_mm_dcom_dump_o(4).avs_writedata   <= (others => '0');
			avalon_mm_dcom_dump_o(4).avs_byteenable  <= (others => '0');
			avalon_mm_dcom_dump_o(5).avs_writedata   <= (others => '0');
			avalon_mm_dcom_dump_o(5).avs_byteenable  <= (others => '0');
			avalon_mm_dcom_dump_o(6).avs_writedata   <= (others => '0');
			avalon_mm_dcom_dump_o(6).avs_byteenable  <= (others => '0');
			avalon_mm_dcom_dump_o(7).avs_writedata   <= (others => '0');
			avalon_mm_dcom_dump_o(7).avs_byteenable  <= (others => '0');
			avalon_mm_dcom_dump_o(8).avs_writedata   <= (others => '0');
			avalon_mm_dcom_dump_o(8).avs_byteenable  <= (others => '0');
			avalon_mm_dcom_dump_o(9).avs_writedata   <= (others => '0');
			avalon_mm_dcom_dump_o(9).avs_byteenable  <= (others => '0');
			avalon_mm_dcom_dump_o(10).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(10).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(11).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(11).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(12).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(12).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(13).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(13).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(14).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(14).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(15).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(15).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(16).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(16).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(17).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(17).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(18).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(18).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(19).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(19).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(20).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(20).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(21).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(21).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(22).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(22).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(23).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(23).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(24).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(24).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(25).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(25).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(26).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(26).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(27).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(27).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(28).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(28).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(29).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(29).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(30).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(30).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(31).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(31).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(32).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(32).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(33).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(33).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(34).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(34).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(35).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(35).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(36).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(36).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(37).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(37).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(38).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(38).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(39).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(39).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(40).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(40).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(41).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(41).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(42).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(42).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(43).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(43).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(44).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(44).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(45).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(45).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(46).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(46).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(47).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(47).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(48).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(48).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(49).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(49).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(50).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(50).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(51).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(51).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(52).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(52).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(53).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(53).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(54).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(54).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(55).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(55).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(56).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(56).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(57).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(57).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(58).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(58).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(59).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(59).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(60).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(60).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(61).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(61).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(62).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(62).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(63).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(63).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(64).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(64).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(65).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(65).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(66).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(66).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(67).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(67).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(68).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(68).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(69).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(69).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(70).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(70).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(71).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(71).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(72).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(72).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(73).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(73).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(74).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(74).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(75).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(75).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(76).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(76).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(77).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(77).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(78).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(78).avs_byteenable <= (others => '0');
			avalon_mm_dcom_dump_o(79).avs_writedata  <= (others => '0');
			avalon_mm_dcom_dump_o(79).avs_byteenable <= (others => '0');
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			avs_dbuffer_wrreq_o   <= '0';
			avs_dbuffer_wrdata_o  <= (others => '0');
			avs_bebuffer_wrreq_o  <= '0';
			avs_bebuffer_wrdata_o <= (others => '0');
			s_data_written        <= '0';
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_data_buffer_address) is
		begin
			if (s_data_written = '0') then
				-- Registers Write Data
				case (write_address_i) is
					-- Case for access to all registers address

					when 0 to 2047 =>

						if ((avs_dbuffer_full_i = '0') and (avs_bebuffer_full_i = '0')) then
							avs_dbuffer_wrreq_o   <= '1';
							avs_dbuffer_wrdata_o  <= avalon_mm_data_buffer_i.writedata;
							avs_bebuffer_wrreq_o  <= '1';
							avs_bebuffer_wrdata_o <= avalon_mm_data_buffer_i.byteenable;
						end if;
					when others =>
						null;
				end case;
				case (write_address_i) is

					when (0) =>
						avalon_mm_dcom_dump_o(0).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(0).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (1) =>
						avalon_mm_dcom_dump_o(1).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(1).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (2) =>
						avalon_mm_dcom_dump_o(2).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(2).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (3) =>
						avalon_mm_dcom_dump_o(3).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(3).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (4) =>
						avalon_mm_dcom_dump_o(4).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(4).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (5) =>
						avalon_mm_dcom_dump_o(5).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(5).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (6) =>
						avalon_mm_dcom_dump_o(6).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(6).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (7) =>
						avalon_mm_dcom_dump_o(7).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(7).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (8) =>
						avalon_mm_dcom_dump_o(8).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(8).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (9) =>
						avalon_mm_dcom_dump_o(9).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(9).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (10) =>
						avalon_mm_dcom_dump_o(10).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(10).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (11) =>
						avalon_mm_dcom_dump_o(11).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(11).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (12) =>
						avalon_mm_dcom_dump_o(12).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(12).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (13) =>
						avalon_mm_dcom_dump_o(13).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(13).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (14) =>
						avalon_mm_dcom_dump_o(14).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(14).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (15) =>
						avalon_mm_dcom_dump_o(15).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(15).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (16) =>
						avalon_mm_dcom_dump_o(16).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(16).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (17) =>
						avalon_mm_dcom_dump_o(17).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(17).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (18) =>
						avalon_mm_dcom_dump_o(18).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(18).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (19) =>
						avalon_mm_dcom_dump_o(19).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(19).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (20) =>
						avalon_mm_dcom_dump_o(20).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(20).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (21) =>
						avalon_mm_dcom_dump_o(21).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(21).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (22) =>
						avalon_mm_dcom_dump_o(22).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(22).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (23) =>
						avalon_mm_dcom_dump_o(23).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(23).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (24) =>
						avalon_mm_dcom_dump_o(24).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(24).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (25) =>
						avalon_mm_dcom_dump_o(25).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(25).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (26) =>
						avalon_mm_dcom_dump_o(26).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(26).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (27) =>
						avalon_mm_dcom_dump_o(27).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(27).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (28) =>
						avalon_mm_dcom_dump_o(28).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(28).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (29) =>
						avalon_mm_dcom_dump_o(29).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(29).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (30) =>
						avalon_mm_dcom_dump_o(30).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(30).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (31) =>
						avalon_mm_dcom_dump_o(31).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(31).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (32) =>
						avalon_mm_dcom_dump_o(32).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(32).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (33) =>
						avalon_mm_dcom_dump_o(33).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(33).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (34) =>
						avalon_mm_dcom_dump_o(34).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(34).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (35) =>
						avalon_mm_dcom_dump_o(35).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(35).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (36) =>
						avalon_mm_dcom_dump_o(36).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(36).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (37) =>
						avalon_mm_dcom_dump_o(37).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(37).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (38) =>
						avalon_mm_dcom_dump_o(38).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(38).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (39) =>
						avalon_mm_dcom_dump_o(39).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(39).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (40) =>
						avalon_mm_dcom_dump_o(40).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(40).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (41) =>
						avalon_mm_dcom_dump_o(41).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(41).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (42) =>
						avalon_mm_dcom_dump_o(42).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(42).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (43) =>
						avalon_mm_dcom_dump_o(43).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(43).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (44) =>
						avalon_mm_dcom_dump_o(44).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(44).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (45) =>
						avalon_mm_dcom_dump_o(45).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(45).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (46) =>
						avalon_mm_dcom_dump_o(46).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(46).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (47) =>
						avalon_mm_dcom_dump_o(47).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(47).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (48) =>
						avalon_mm_dcom_dump_o(48).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(48).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (49) =>
						avalon_mm_dcom_dump_o(49).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(49).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (50) =>
						avalon_mm_dcom_dump_o(50).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(50).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (51) =>
						avalon_mm_dcom_dump_o(51).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(51).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (52) =>
						avalon_mm_dcom_dump_o(52).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(52).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (53) =>
						avalon_mm_dcom_dump_o(53).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(53).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (54) =>
						avalon_mm_dcom_dump_o(54).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(54).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (55) =>
						avalon_mm_dcom_dump_o(55).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(55).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (56) =>
						avalon_mm_dcom_dump_o(56).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(56).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (57) =>
						avalon_mm_dcom_dump_o(57).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(57).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (58) =>
						avalon_mm_dcom_dump_o(58).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(58).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (59) =>
						avalon_mm_dcom_dump_o(59).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(59).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (60) =>
						avalon_mm_dcom_dump_o(60).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(60).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (61) =>
						avalon_mm_dcom_dump_o(61).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(61).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (62) =>
						avalon_mm_dcom_dump_o(62).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(62).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (63) =>
						avalon_mm_dcom_dump_o(63).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(63).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (64) =>
						avalon_mm_dcom_dump_o(64).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(64).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (65) =>
						avalon_mm_dcom_dump_o(65).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(65).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (66) =>
						avalon_mm_dcom_dump_o(66).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(66).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (67) =>
						avalon_mm_dcom_dump_o(67).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(67).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (68) =>
						avalon_mm_dcom_dump_o(68).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(68).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (69) =>
						avalon_mm_dcom_dump_o(69).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(69).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (70) =>
						avalon_mm_dcom_dump_o(70).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(70).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (71) =>
						avalon_mm_dcom_dump_o(71).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(71).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (72) =>
						avalon_mm_dcom_dump_o(72).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(72).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (73) =>
						avalon_mm_dcom_dump_o(73).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(73).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (74) =>
						avalon_mm_dcom_dump_o(74).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(74).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (75) =>
						avalon_mm_dcom_dump_o(75).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(75).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (76) =>
						avalon_mm_dcom_dump_o(76).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(76).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (77) =>
						avalon_mm_dcom_dump_o(77).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(77).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (78) =>
						avalon_mm_dcom_dump_o(78).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(78).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;
					when (79) =>
						avalon_mm_dcom_dump_o(79).avs_writedata  <= avalon_mm_data_buffer_i.writedata;
						avalon_mm_dcom_dump_o(79).avs_byteenable <= avalon_mm_data_buffer_i.byteenable;

					when others =>
						null;
				end case;
				s_data_written <= '1';
			end if;
		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_data_buffer_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_data_buffer_o.waitrequest <= '1';
			v_write_address                     := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_data_buffer_o.waitrequest <= '1';
			p_control_triggers;
			if (avalon_mm_data_buffer_i.write = '1') then
				avalon_mm_data_buffer_o.waitrequest <= '0';
				v_write_address                     := to_integer(unsigned(avalon_mm_data_buffer_i.address));
				p_writedata(v_write_address);
			end if;
		end if;
	end process p_avalon_mm_data_buffer_write;

end architecture RTL;
