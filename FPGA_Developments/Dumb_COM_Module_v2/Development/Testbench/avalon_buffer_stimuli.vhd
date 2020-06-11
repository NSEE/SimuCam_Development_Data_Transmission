library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_buffer_stimuli is
	generic(
		g_ADDRESS_WIDTH    : natural range 1 to 64;
		g_DATA_WIDTH       : natural range 1 to 64;
		g_BYTEENABLE_WIDTH : natural range 1 to 8
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_waitrequest_i : in  std_logic; --                                     -- avalon_mm.waitrequest
		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
		avalon_mm_write_o       : out std_logic; --                                     --          .write
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0); --  --          .writedata
		avalon_mm_byteenable_o  : out std_logic_vector((g_BYTEENABLE_WIDTH - 1) downto 0) --  --          .writedata
	);
end entity avalon_buffer_stimuli;

architecture RTL of avalon_buffer_stimuli is

	function f_next_data(
		curr_data_i   : natural range 0 to 255;
		start_value_i : natural range 0 to 255;
		final_value_i : natural range 0 to 255;
		step_i        : natural range 0 to 255;
		inc_i         : std_logic
	) return natural is
		variable v_next_data : natural range 0 to 255;
	begin

		if (inc_i = '1') then
			if (curr_data_i >= final_value_i) then
				v_next_data := start_value_i;
			else
				v_next_data := curr_data_i + step_i;
			end if;
		else
			if (curr_data_i <= final_value_i) then
				v_next_data := start_value_i;
			else
				v_next_data := curr_data_i - step_i;
			end if;
		end if;

		return v_next_data;
	end function f_next_data;

	--	constant c_RESET_DATA : natural := 255;
	--	constant c_FINAL_DATA : natural := 1;

	constant c_RESET_DATA : natural := 0;
	constant c_FINAL_DATA : natural := 255;

	signal s_counter     : natural                                     := 0;
	signal s_address_cnt : natural range 0 to (2**g_ADDRESS_WIDTH - 1) := 0;
	signal s_mask_cnt    : natural range 0 to 16                       := 0;
	signal s_times_cnt   : natural                                     := 0;

begin

	p_avalon_buffer_stimuli : process(clk_i, rst_i) is
		variable v_data_cnt        : natural range 0 to 255 := c_RESET_DATA;
		variable v_registered_data : std_logic_vector(63 downto 0);
		variable v_packet_number   : natural                := 0;
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			s_counter             <= 0;
			--			s_counter             <= 5000;
			--			s_counter             <= 900;
			s_address_cnt         <= 0;
			s_mask_cnt            <= 0;
			s_times_cnt           <= 0;
			v_data_cnt            := c_RESET_DATA;
			v_registered_data     := (others => '0');
			v_packet_number       := 0;

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			s_counter             <= s_counter + 1;

			case s_counter is

--				when 2500 to 2501 =>
--					v_packet_number                     := v_packet_number + 10;
--					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(0, g_ADDRESS_WIDTH));
--					avalon_mm_write_o                   <= '1';
--					avalon_mm_writedata_o               <= (others => '0');
--					avalon_mm_writedata_o(31 downto 0)  <= std_logic_vector(to_unsigned(v_packet_number, 32)); -- data time
--					avalon_mm_writedata_o(47 downto 32) <= std_logic_vector(to_unsigned(15, 16)); -- data length
--					avalon_mm_writedata_o(55 downto 48) <= std_logic_vector(to_unsigned(16#15#, 8)); -- data
--					avalon_mm_writedata_o(63 downto 56) <= std_logic_vector(to_unsigned(16#40#, 8)); -- data
--					avalon_mm_byteenable_o              <= "11111111";
--
--				when 2503 to 2504 =>
--					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(1, g_ADDRESS_WIDTH));
--					avalon_mm_write_o                   <= '1';
--					avalon_mm_writedata_o               <= (others => '0');
--					avalon_mm_writedata_o(7 downto 0)   <= std_logic_vector(to_unsigned(16#C7#, 8)); -- data
--					avalon_mm_writedata_o(15 downto 8)  <= std_logic_vector(to_unsigned(16#39#, 8)); -- data
--					avalon_mm_writedata_o(23 downto 16) <= std_logic_vector(to_unsigned(16#FD#, 8)); -- data
--					avalon_mm_writedata_o(31 downto 24) <= std_logic_vector(to_unsigned(16#36#, 8)); -- data
--					avalon_mm_writedata_o(39 downto 32) <= std_logic_vector(to_unsigned(16#DD#, 8)); -- data
--					avalon_mm_writedata_o(47 downto 40) <= std_logic_vector(to_unsigned(16#0B#, 8)); -- data
--					avalon_mm_writedata_o(55 downto 48) <= std_logic_vector(to_unsigned(16#E7#, 8)); -- data
--					avalon_mm_writedata_o(63 downto 56) <= std_logic_vector(to_unsigned(16#52#, 8)); -- data
--					avalon_mm_byteenable_o              <= "11111111";
--
--				when 2506 to 2507 =>
--					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(2, g_ADDRESS_WIDTH));
--					avalon_mm_write_o                   <= '1';
--					avalon_mm_writedata_o               <= (others => '0');
--					avalon_mm_writedata_o(7 downto 0)   <= std_logic_vector(to_unsigned(16#02#, 8)); -- data
--					avalon_mm_writedata_o(15 downto 8)  <= std_logic_vector(to_unsigned(16#BE#, 8)); -- data
--					avalon_mm_writedata_o(23 downto 16) <= std_logic_vector(to_unsigned(16#0B#, 8)); -- data
--					avalon_mm_writedata_o(31 downto 24) <= std_logic_vector(to_unsigned(16#D6#, 8)); -- data
--					avalon_mm_writedata_o(39 downto 32) <= std_logic_vector(to_unsigned(16#D3#, 8)); -- data
--					avalon_mm_writedata_o(47 downto 40) <= std_logic_vector(to_unsigned(16#43#, 8)); -- data
--					avalon_mm_writedata_o(55 downto 48) <= std_logic_vector(to_unsigned(16#FF#, 8)); -- data
--					avalon_mm_writedata_o(63 downto 56) <= std_logic_vector(to_unsigned(16#FF#, 8)); -- data
--					avalon_mm_byteenable_o              <= "11111111";
--
--				when 2549 =>
--					s_counter <= 2500;

				when 2500 to 2501 =>
					v_packet_number                     := v_packet_number + 10;
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(0, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(31 downto 0)  <= std_logic_vector(to_unsigned(1000, 32)); -- data time
					avalon_mm_writedata_o(47 downto 32) <= std_logic_vector(to_unsigned(3000, 16)); -- data length
					avalon_mm_writedata_o(55 downto 48) <= std_logic_vector(to_unsigned(16#D3#, 8)); -- data
					avalon_mm_writedata_o(63 downto 56) <= std_logic_vector(to_unsigned(16#70#, 8)); -- data
					avalon_mm_byteenable_o              <= "11111111";

  when 2503 to 2504 => avalon_mm_address_o <= std_logic_vector(to_unsigned(1, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8D8D25D8E4121F2D"; avalon_mm_byteenable_o <= "11111111";
  when 2506 to 2507 => avalon_mm_address_o <= std_logic_vector(to_unsigned(2, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0536A9177F48D1CB"; avalon_mm_byteenable_o <= "11111111";
  when 2509 to 2510 => avalon_mm_address_o <= std_logic_vector(to_unsigned(3, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"1649F084DACB532F"; avalon_mm_byteenable_o <= "11111111";
  when 2512 to 2513 => avalon_mm_address_o <= std_logic_vector(to_unsigned(4, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B265576E7B8E0534"; avalon_mm_byteenable_o <= "11111111";
  when 2515 to 2516 => avalon_mm_address_o <= std_logic_vector(to_unsigned(5, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"ECBFD28DACD8E95A"; avalon_mm_byteenable_o <= "11111111";
  when 2518 to 2519 => avalon_mm_address_o <= std_logic_vector(to_unsigned(6, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7737890864101BFE"; avalon_mm_byteenable_o <= "11111111";
  when 2521 to 2522 => avalon_mm_address_o <= std_logic_vector(to_unsigned(7, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"255BD0199ACB31B2"; avalon_mm_byteenable_o <= "11111111";
  when 2524 to 2525 => avalon_mm_address_o <= std_logic_vector(to_unsigned(8, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3EEC708F2F8B1FF9"; avalon_mm_byteenable_o <= "11111111";
  when 2527 to 2528 => avalon_mm_address_o <= std_logic_vector(to_unsigned(9, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2F312627EC9E1509"; avalon_mm_byteenable_o <= "11111111";
 when 2530 to 2531 => avalon_mm_address_o <= std_logic_vector(to_unsigned(10, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"48BDAED82DC669BC"; avalon_mm_byteenable_o <= "11111111";
 when 2533 to 2534 => avalon_mm_address_o <= std_logic_vector(to_unsigned(11, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"66C2930708CAEF7C"; avalon_mm_byteenable_o <= "11111111";
 when 2536 to 2537 => avalon_mm_address_o <= std_logic_vector(to_unsigned(12, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B139C4FA12C8E751"; avalon_mm_byteenable_o <= "11111111";
 when 2539 to 2540 => avalon_mm_address_o <= std_logic_vector(to_unsigned(13, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"79C21F56B61A6583"; avalon_mm_byteenable_o <= "11111111";
 when 2542 to 2543 => avalon_mm_address_o <= std_logic_vector(to_unsigned(14, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7DD22A276FEA1324"; avalon_mm_byteenable_o <= "11111111";
 when 2545 to 2546 => avalon_mm_address_o <= std_logic_vector(to_unsigned(15, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A523C2BA5CF5B8E8"; avalon_mm_byteenable_o <= "11111111";
 when 2548 to 2549 => avalon_mm_address_o <= std_logic_vector(to_unsigned(16, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"E7EDCA898A8D7CBA"; avalon_mm_byteenable_o <= "11111111";
 when 2551 to 2552 => avalon_mm_address_o <= std_logic_vector(to_unsigned(17, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0CFD0FDAC3D276A2"; avalon_mm_byteenable_o <= "11111111";
 when 2554 to 2555 => avalon_mm_address_o <= std_logic_vector(to_unsigned(18, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FF0D4A6427E96B40"; avalon_mm_byteenable_o <= "11111111";
 when 2557 to 2558 => avalon_mm_address_o <= std_logic_vector(to_unsigned(19, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3116B005F165DFDB"; avalon_mm_byteenable_o <= "11111111";
 when 2560 to 2561 => avalon_mm_address_o <= std_logic_vector(to_unsigned(20, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"37846C9028BE3CEA"; avalon_mm_byteenable_o <= "11111111";
 when 2563 to 2564 => avalon_mm_address_o <= std_logic_vector(to_unsigned(21, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"DA8D0EC9F6BC80CE"; avalon_mm_byteenable_o <= "11111111";
 when 2566 to 2567 => avalon_mm_address_o <= std_logic_vector(to_unsigned(22, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D2864ED709206EBE"; avalon_mm_byteenable_o <= "11111111";
 when 2569 to 2570 => avalon_mm_address_o <= std_logic_vector(to_unsigned(23, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6CFE285D95FF067E"; avalon_mm_byteenable_o <= "11111111";
 when 2572 to 2573 => avalon_mm_address_o <= std_logic_vector(to_unsigned(24, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"4A7BED9DA568DD8E"; avalon_mm_byteenable_o <= "11111111";
 when 2575 to 2576 => avalon_mm_address_o <= std_logic_vector(to_unsigned(25, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9321C9AA2EFF733D"; avalon_mm_byteenable_o <= "11111111";
 when 2578 to 2579 => avalon_mm_address_o <= std_logic_vector(to_unsigned(26, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"77D335B938FF9B1D"; avalon_mm_byteenable_o <= "11111111";
 when 2581 to 2582 => avalon_mm_address_o <= std_logic_vector(to_unsigned(27, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0FF58BEED7A352D6"; avalon_mm_byteenable_o <= "11111111";
 when 2584 to 2585 => avalon_mm_address_o <= std_logic_vector(to_unsigned(28, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"224B094B18B060CB"; avalon_mm_byteenable_o <= "11111111";
 when 2587 to 2588 => avalon_mm_address_o <= std_logic_vector(to_unsigned(29, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B138CC4671AB61CA"; avalon_mm_byteenable_o <= "11111111";
 when 2590 to 2591 => avalon_mm_address_o <= std_logic_vector(to_unsigned(30, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"156B31F1D8174B55"; avalon_mm_byteenable_o <= "11111111";
 when 2593 to 2594 => avalon_mm_address_o <= std_logic_vector(to_unsigned(31, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9871C256B6D4C762"; avalon_mm_byteenable_o <= "11111111";
 when 2596 to 2597 => avalon_mm_address_o <= std_logic_vector(to_unsigned(32, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FE1E70A0BB2A708A"; avalon_mm_byteenable_o <= "11111111";
 when 2599 to 2600 => avalon_mm_address_o <= std_logic_vector(to_unsigned(33, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"84428D7956743CAE"; avalon_mm_byteenable_o <= "11111111";
 when 2602 to 2603 => avalon_mm_address_o <= std_logic_vector(to_unsigned(34, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7565A63C0611A87E"; avalon_mm_byteenable_o <= "11111111";
 when 2605 to 2606 => avalon_mm_address_o <= std_logic_vector(to_unsigned(35, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"49EC0EB5A0820828"; avalon_mm_byteenable_o <= "11111111";
 when 2608 to 2609 => avalon_mm_address_o <= std_logic_vector(to_unsigned(36, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9F39018F2BD643C3"; avalon_mm_byteenable_o <= "11111111";
 when 2611 to 2612 => avalon_mm_address_o <= std_logic_vector(to_unsigned(37, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FD738AC3C227178D"; avalon_mm_byteenable_o <= "11111111";
 when 2614 to 2615 => avalon_mm_address_o <= std_logic_vector(to_unsigned(38, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"167FF90DF0ECFD76"; avalon_mm_byteenable_o <= "11111111";
 when 2617 to 2618 => avalon_mm_address_o <= std_logic_vector(to_unsigned(39, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"498EFDDA112819EC"; avalon_mm_byteenable_o <= "11111111";
 when 2620 to 2621 => avalon_mm_address_o <= std_logic_vector(to_unsigned(40, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9B112904F9885DBD"; avalon_mm_byteenable_o <= "11111111";
 when 2623 to 2624 => avalon_mm_address_o <= std_logic_vector(to_unsigned(41, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"80B28BCB57F80DA1"; avalon_mm_byteenable_o <= "11111111";
 when 2626 to 2627 => avalon_mm_address_o <= std_logic_vector(to_unsigned(42, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B78A414BB4DC37C3"; avalon_mm_byteenable_o <= "11111111";
 when 2629 to 2630 => avalon_mm_address_o <= std_logic_vector(to_unsigned(43, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A878095A12D2C363"; avalon_mm_byteenable_o <= "11111111";
 when 2632 to 2633 => avalon_mm_address_o <= std_logic_vector(to_unsigned(44, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7D62733B9A672A0B"; avalon_mm_byteenable_o <= "11111111";
 when 2635 to 2636 => avalon_mm_address_o <= std_logic_vector(to_unsigned(45, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F14E360498FF3C1E"; avalon_mm_byteenable_o <= "11111111";
 when 2638 to 2639 => avalon_mm_address_o <= std_logic_vector(to_unsigned(46, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6F4E5626074FFCAF"; avalon_mm_byteenable_o <= "11111111";
 when 2641 to 2642 => avalon_mm_address_o <= std_logic_vector(to_unsigned(47, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CD97AAE750CF18FA"; avalon_mm_byteenable_o <= "11111111";
 when 2644 to 2645 => avalon_mm_address_o <= std_logic_vector(to_unsigned(48, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D9ED9FA73065F5BD"; avalon_mm_byteenable_o <= "11111111";
 when 2647 to 2648 => avalon_mm_address_o <= std_logic_vector(to_unsigned(49, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"74C8945FE1816037"; avalon_mm_byteenable_o <= "11111111";
 when 2650 to 2651 => avalon_mm_address_o <= std_logic_vector(to_unsigned(50, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8D4D42BC491C5FC1"; avalon_mm_byteenable_o <= "11111111";
 when 2653 to 2654 => avalon_mm_address_o <= std_logic_vector(to_unsigned(51, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"15E69A97EDB16DE7"; avalon_mm_byteenable_o <= "11111111";
 when 2656 to 2657 => avalon_mm_address_o <= std_logic_vector(to_unsigned(52, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0326BF6342B13D7D"; avalon_mm_byteenable_o <= "11111111";
 when 2659 to 2660 => avalon_mm_address_o <= std_logic_vector(to_unsigned(53, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0F07C460F4B83229"; avalon_mm_byteenable_o <= "11111111";
 when 2662 to 2663 => avalon_mm_address_o <= std_logic_vector(to_unsigned(54, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"1162AE4AC349F3B6"; avalon_mm_byteenable_o <= "11111111";
 when 2665 to 2666 => avalon_mm_address_o <= std_logic_vector(to_unsigned(55, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CE0E7FAC81A2EEDE"; avalon_mm_byteenable_o <= "11111111";
 when 2668 to 2669 => avalon_mm_address_o <= std_logic_vector(to_unsigned(56, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2116BF0CE691ADC3"; avalon_mm_byteenable_o <= "11111111";
 when 2671 to 2672 => avalon_mm_address_o <= std_logic_vector(to_unsigned(57, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0C7DC956CB8DFEDD"; avalon_mm_byteenable_o <= "11111111";
 when 2674 to 2675 => avalon_mm_address_o <= std_logic_vector(to_unsigned(58, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A0E41101FCC84CC5"; avalon_mm_byteenable_o <= "11111111";
 when 2677 to 2678 => avalon_mm_address_o <= std_logic_vector(to_unsigned(59, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"29B43904E48738AE"; avalon_mm_byteenable_o <= "11111111";
 when 2680 to 2681 => avalon_mm_address_o <= std_logic_vector(to_unsigned(60, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7EB0A239E6F453CD"; avalon_mm_byteenable_o <= "11111111";
 when 2683 to 2684 => avalon_mm_address_o <= std_logic_vector(to_unsigned(61, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"45498D9456F4D85D"; avalon_mm_byteenable_o <= "11111111";
 when 2686 to 2687 => avalon_mm_address_o <= std_logic_vector(to_unsigned(62, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2B89CAF34110FE5D"; avalon_mm_byteenable_o <= "11111111";
 when 2689 to 2690 => avalon_mm_address_o <= std_logic_vector(to_unsigned(63, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"AF8C6C82D3F32877"; avalon_mm_byteenable_o <= "11111111";
 when 2692 to 2693 => avalon_mm_address_o <= std_logic_vector(to_unsigned(64, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F903CB1C4645CEC2"; avalon_mm_byteenable_o <= "11111111";
 when 2695 to 2696 => avalon_mm_address_o <= std_logic_vector(to_unsigned(65, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3D3B17692F39FA8D"; avalon_mm_byteenable_o <= "11111111";
 when 2698 to 2699 => avalon_mm_address_o <= std_logic_vector(to_unsigned(66, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F99BBEEF20EEDFFB"; avalon_mm_byteenable_o <= "11111111";
 when 2701 to 2702 => avalon_mm_address_o <= std_logic_vector(to_unsigned(67, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D9AA4155C45A519F"; avalon_mm_byteenable_o <= "11111111";
 when 2704 to 2705 => avalon_mm_address_o <= std_logic_vector(to_unsigned(68, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7192DF434874A3F0"; avalon_mm_byteenable_o <= "11111111";
 when 2707 to 2708 => avalon_mm_address_o <= std_logic_vector(to_unsigned(69, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"5F4A3271DFF716BC"; avalon_mm_byteenable_o <= "11111111";
 when 2710 to 2711 => avalon_mm_address_o <= std_logic_vector(to_unsigned(70, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F247789CDB55E4D8"; avalon_mm_byteenable_o <= "11111111";
 when 2713 to 2714 => avalon_mm_address_o <= std_logic_vector(to_unsigned(71, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CEA38A5F54E66B3B"; avalon_mm_byteenable_o <= "11111111";
 when 2716 to 2717 => avalon_mm_address_o <= std_logic_vector(to_unsigned(72, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"DB8026FD5502EB7A"; avalon_mm_byteenable_o <= "11111111";
 when 2719 to 2720 => avalon_mm_address_o <= std_logic_vector(to_unsigned(73, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FB98E893D9A7B5BA"; avalon_mm_byteenable_o <= "11111111";
 when 2722 to 2723 => avalon_mm_address_o <= std_logic_vector(to_unsigned(74, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F79D6E8A86108654"; avalon_mm_byteenable_o <= "11111111";
 when 2725 to 2726 => avalon_mm_address_o <= std_logic_vector(to_unsigned(75, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A71AD888EEB67897"; avalon_mm_byteenable_o <= "11111111";
 when 2728 to 2729 => avalon_mm_address_o <= std_logic_vector(to_unsigned(76, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8B2D293F5D7E5935"; avalon_mm_byteenable_o <= "11111111";
 when 2731 to 2732 => avalon_mm_address_o <= std_logic_vector(to_unsigned(77, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"544AD1300D0A9AF5"; avalon_mm_byteenable_o <= "11111111";
 when 2734 to 2735 => avalon_mm_address_o <= std_logic_vector(to_unsigned(78, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0BDD6EA9F49EFE71"; avalon_mm_byteenable_o <= "11111111";
 when 2737 to 2738 => avalon_mm_address_o <= std_logic_vector(to_unsigned(79, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3DD88E55AD748E55"; avalon_mm_byteenable_o <= "11111111";
 when 2740 to 2741 => avalon_mm_address_o <= std_logic_vector(to_unsigned(80, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0E472B74DEFD02A5"; avalon_mm_byteenable_o <= "11111111";
 when 2743 to 2744 => avalon_mm_address_o <= std_logic_vector(to_unsigned(81, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C15B20B54A62A4D2"; avalon_mm_byteenable_o <= "11111111";
 when 2746 to 2747 => avalon_mm_address_o <= std_logic_vector(to_unsigned(82, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7062A664E89847E9"; avalon_mm_byteenable_o <= "11111111";
 when 2749 to 2750 => avalon_mm_address_o <= std_logic_vector(to_unsigned(83, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"DF6B1DA14D90E2D2"; avalon_mm_byteenable_o <= "11111111";
 when 2752 to 2753 => avalon_mm_address_o <= std_logic_vector(to_unsigned(84, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6488B39153706681"; avalon_mm_byteenable_o <= "11111111";
 when 2755 to 2756 => avalon_mm_address_o <= std_logic_vector(to_unsigned(85, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"61483AA581D6C7B5"; avalon_mm_byteenable_o <= "11111111";
 when 2758 to 2759 => avalon_mm_address_o <= std_logic_vector(to_unsigned(86, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"76E42E35FE331515"; avalon_mm_byteenable_o <= "11111111";
 when 2761 to 2762 => avalon_mm_address_o <= std_logic_vector(to_unsigned(87, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B382E4F080E2CEDA"; avalon_mm_byteenable_o <= "11111111";
 when 2764 to 2765 => avalon_mm_address_o <= std_logic_vector(to_unsigned(88, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2569724013F24898"; avalon_mm_byteenable_o <= "11111111";
 when 2767 to 2768 => avalon_mm_address_o <= std_logic_vector(to_unsigned(89, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"5CDD01B16CE059EC"; avalon_mm_byteenable_o <= "11111111";
 when 2770 to 2771 => avalon_mm_address_o <= std_logic_vector(to_unsigned(90, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3BC8C0F1C20D687C"; avalon_mm_byteenable_o <= "11111111";
 when 2773 to 2774 => avalon_mm_address_o <= std_logic_vector(to_unsigned(91, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8A5D87D029FBF44A"; avalon_mm_byteenable_o <= "11111111";
 when 2776 to 2777 => avalon_mm_address_o <= std_logic_vector(to_unsigned(92, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"29524DE9F1D25B5B"; avalon_mm_byteenable_o <= "11111111";
 when 2779 to 2780 => avalon_mm_address_o <= std_logic_vector(to_unsigned(93, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"53F5C3271093A834"; avalon_mm_byteenable_o <= "11111111";
 when 2782 to 2783 => avalon_mm_address_o <= std_logic_vector(to_unsigned(94, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"EE2A1CEAF49EF199"; avalon_mm_byteenable_o <= "11111111";
 when 2785 to 2786 => avalon_mm_address_o <= std_logic_vector(to_unsigned(95, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"709B1C5A5DCE9A36"; avalon_mm_byteenable_o <= "11111111";
 when 2788 to 2789 => avalon_mm_address_o <= std_logic_vector(to_unsigned(96, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F14A67014C1BFA6F"; avalon_mm_byteenable_o <= "11111111";
 when 2791 to 2792 => avalon_mm_address_o <= std_logic_vector(to_unsigned(97, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"DE432D0238B5B4DA"; avalon_mm_byteenable_o <= "11111111";
 when 2794 to 2795 => avalon_mm_address_o <= std_logic_vector(to_unsigned(98, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9544D7D6D3087AF0"; avalon_mm_byteenable_o <= "11111111";
 when 2797 to 2798 => avalon_mm_address_o <= std_logic_vector(to_unsigned(99, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9F4AF9D5A0ED3CB2"; avalon_mm_byteenable_o <= "11111111";
when 2800 to 2801 => avalon_mm_address_o <= std_logic_vector(to_unsigned(100, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"DCA79FDA20ABE57D"; avalon_mm_byteenable_o <= "11111111";
when 2803 to 2804 => avalon_mm_address_o <= std_logic_vector(to_unsigned(101, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8F40E9173729CFCC"; avalon_mm_byteenable_o <= "11111111";
when 2806 to 2807 => avalon_mm_address_o <= std_logic_vector(to_unsigned(102, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"797CD11FD6083D71"; avalon_mm_byteenable_o <= "11111111";
when 2809 to 2810 => avalon_mm_address_o <= std_logic_vector(to_unsigned(103, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"27785127FC60B4A7"; avalon_mm_byteenable_o <= "11111111";
when 2812 to 2813 => avalon_mm_address_o <= std_logic_vector(to_unsigned(104, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A9FF9C2F9A38B2B3"; avalon_mm_byteenable_o <= "11111111";
when 2815 to 2816 => avalon_mm_address_o <= std_logic_vector(to_unsigned(105, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A2647A0E932DC6E8"; avalon_mm_byteenable_o <= "11111111";
when 2818 to 2819 => avalon_mm_address_o <= std_logic_vector(to_unsigned(106, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0F2CB08D5F13FDFA"; avalon_mm_byteenable_o <= "11111111";
when 2821 to 2822 => avalon_mm_address_o <= std_logic_vector(to_unsigned(107, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A85A54F625B6AF89"; avalon_mm_byteenable_o <= "11111111";
when 2824 to 2825 => avalon_mm_address_o <= std_logic_vector(to_unsigned(108, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"12CC42614BFDB51D"; avalon_mm_byteenable_o <= "11111111";
when 2827 to 2828 => avalon_mm_address_o <= std_logic_vector(to_unsigned(109, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8786A8FB4187B290"; avalon_mm_byteenable_o <= "11111111";
when 2830 to 2831 => avalon_mm_address_o <= std_logic_vector(to_unsigned(110, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A950DE5A70E47FC3"; avalon_mm_byteenable_o <= "11111111";
when 2833 to 2834 => avalon_mm_address_o <= std_logic_vector(to_unsigned(111, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"866073CB83398337"; avalon_mm_byteenable_o <= "11111111";
when 2836 to 2837 => avalon_mm_address_o <= std_logic_vector(to_unsigned(112, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6A65AD09108AB2DD"; avalon_mm_byteenable_o <= "11111111";
when 2839 to 2840 => avalon_mm_address_o <= std_logic_vector(to_unsigned(113, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"44CF3BDA29BD2DC7"; avalon_mm_byteenable_o <= "11111111";
when 2842 to 2843 => avalon_mm_address_o <= std_logic_vector(to_unsigned(114, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"5843200D6BC00904"; avalon_mm_byteenable_o <= "11111111";
when 2845 to 2846 => avalon_mm_address_o <= std_logic_vector(to_unsigned(115, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"456CD4698D400DC0"; avalon_mm_byteenable_o <= "11111111";
when 2848 to 2849 => avalon_mm_address_o <= std_logic_vector(to_unsigned(116, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"472B53E321BD24A2"; avalon_mm_byteenable_o <= "11111111";
when 2851 to 2852 => avalon_mm_address_o <= std_logic_vector(to_unsigned(117, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CD0F145B1658BE7F"; avalon_mm_byteenable_o <= "11111111";
when 2854 to 2855 => avalon_mm_address_o <= std_logic_vector(to_unsigned(118, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9E105109A5768DBE"; avalon_mm_byteenable_o <= "11111111";
when 2857 to 2858 => avalon_mm_address_o <= std_logic_vector(to_unsigned(119, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"814F55D718D2BB22"; avalon_mm_byteenable_o <= "11111111";
when 2860 to 2861 => avalon_mm_address_o <= std_logic_vector(to_unsigned(120, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"988F5F7E2C580D51"; avalon_mm_byteenable_o <= "11111111";
when 2863 to 2864 => avalon_mm_address_o <= std_logic_vector(to_unsigned(121, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F778CA742FE95EE1"; avalon_mm_byteenable_o <= "11111111";
when 2866 to 2867 => avalon_mm_address_o <= std_logic_vector(to_unsigned(122, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B955C523D414CCA9"; avalon_mm_byteenable_o <= "11111111";
when 2869 to 2870 => avalon_mm_address_o <= std_logic_vector(to_unsigned(123, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B15728C8DF379EA9"; avalon_mm_byteenable_o <= "11111111";
when 2872 to 2873 => avalon_mm_address_o <= std_logic_vector(to_unsigned(124, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CE707901F4D24A87"; avalon_mm_byteenable_o <= "11111111";
when 2875 to 2876 => avalon_mm_address_o <= std_logic_vector(to_unsigned(125, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"4A35E0C4D7EB6A7A"; avalon_mm_byteenable_o <= "11111111";
when 2878 to 2879 => avalon_mm_address_o <= std_logic_vector(to_unsigned(126, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D2B297525DB8A0C5"; avalon_mm_byteenable_o <= "11111111";
when 2881 to 2882 => avalon_mm_address_o <= std_logic_vector(to_unsigned(127, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0F5590F2BD552923"; avalon_mm_byteenable_o <= "11111111";
when 2884 to 2885 => avalon_mm_address_o <= std_logic_vector(to_unsigned(128, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"73C9654295146A9D"; avalon_mm_byteenable_o <= "11111111";
when 2887 to 2888 => avalon_mm_address_o <= std_logic_vector(to_unsigned(129, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"E2C32468FB8DAA26"; avalon_mm_byteenable_o <= "11111111";
when 2890 to 2891 => avalon_mm_address_o <= std_logic_vector(to_unsigned(130, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C11D52BCB7B7EF52"; avalon_mm_byteenable_o <= "11111111";
when 2893 to 2894 => avalon_mm_address_o <= std_logic_vector(to_unsigned(131, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F26F84888C74F8A3"; avalon_mm_byteenable_o <= "11111111";
when 2896 to 2897 => avalon_mm_address_o <= std_logic_vector(to_unsigned(132, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CA98AAA793B91923"; avalon_mm_byteenable_o <= "11111111";
when 2899 to 2900 => avalon_mm_address_o <= std_logic_vector(to_unsigned(133, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0A497E6A5D778F48"; avalon_mm_byteenable_o <= "11111111";
when 2902 to 2903 => avalon_mm_address_o <= std_logic_vector(to_unsigned(134, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"752529069A165558"; avalon_mm_byteenable_o <= "11111111";
when 2905 to 2906 => avalon_mm_address_o <= std_logic_vector(to_unsigned(135, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"86CA9C3282C2B1AA"; avalon_mm_byteenable_o <= "11111111";
when 2908 to 2909 => avalon_mm_address_o <= std_logic_vector(to_unsigned(136, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8EB421E2AB74F942"; avalon_mm_byteenable_o <= "11111111";
when 2911 to 2912 => avalon_mm_address_o <= std_logic_vector(to_unsigned(137, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B81DBBA5861A74C3"; avalon_mm_byteenable_o <= "11111111";
when 2914 to 2915 => avalon_mm_address_o <= std_logic_vector(to_unsigned(138, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3E30D1C98A823BC2"; avalon_mm_byteenable_o <= "11111111";
when 2917 to 2918 => avalon_mm_address_o <= std_logic_vector(to_unsigned(139, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"658FCCD3675659C7"; avalon_mm_byteenable_o <= "11111111";
when 2920 to 2921 => avalon_mm_address_o <= std_logic_vector(to_unsigned(140, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"1763629FD137CAC9"; avalon_mm_byteenable_o <= "11111111";
when 2923 to 2924 => avalon_mm_address_o <= std_logic_vector(to_unsigned(141, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0B73931487E9710E"; avalon_mm_byteenable_o <= "11111111";
when 2926 to 2927 => avalon_mm_address_o <= std_logic_vector(to_unsigned(142, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D35C6B355E21D01C"; avalon_mm_byteenable_o <= "11111111";
when 2929 to 2930 => avalon_mm_address_o <= std_logic_vector(to_unsigned(143, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"38EE42995B8CD594"; avalon_mm_byteenable_o <= "11111111";
when 2932 to 2933 => avalon_mm_address_o <= std_logic_vector(to_unsigned(144, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6555D54431B5E839"; avalon_mm_byteenable_o <= "11111111";
when 2935 to 2936 => avalon_mm_address_o <= std_logic_vector(to_unsigned(145, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"34036A9A3A85E996"; avalon_mm_byteenable_o <= "11111111";
when 2938 to 2939 => avalon_mm_address_o <= std_logic_vector(to_unsigned(146, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CC990B50CCE2509D"; avalon_mm_byteenable_o <= "11111111";
when 2941 to 2942 => avalon_mm_address_o <= std_logic_vector(to_unsigned(147, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6E5658BFFB9F9129"; avalon_mm_byteenable_o <= "11111111";
when 2944 to 2945 => avalon_mm_address_o <= std_logic_vector(to_unsigned(148, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"DB617307C9932ABA"; avalon_mm_byteenable_o <= "11111111";
when 2947 to 2948 => avalon_mm_address_o <= std_logic_vector(to_unsigned(149, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"579BF4E1F2E91576"; avalon_mm_byteenable_o <= "11111111";
when 2950 to 2951 => avalon_mm_address_o <= std_logic_vector(to_unsigned(150, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A8A9971E22B1440A"; avalon_mm_byteenable_o <= "11111111";
when 2953 to 2954 => avalon_mm_address_o <= std_logic_vector(to_unsigned(151, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A9FC0A900545B188"; avalon_mm_byteenable_o <= "11111111";
when 2956 to 2957 => avalon_mm_address_o <= std_logic_vector(to_unsigned(152, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A38FD75BD96B92BB"; avalon_mm_byteenable_o <= "11111111";
when 2959 to 2960 => avalon_mm_address_o <= std_logic_vector(to_unsigned(153, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CF24DC1360CA5645"; avalon_mm_byteenable_o <= "11111111";
when 2962 to 2963 => avalon_mm_address_o <= std_logic_vector(to_unsigned(154, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"17C3B84BF31ABABA"; avalon_mm_byteenable_o <= "11111111";
when 2965 to 2966 => avalon_mm_address_o <= std_logic_vector(to_unsigned(155, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9380A3CFCBED5023"; avalon_mm_byteenable_o <= "11111111";
when 2968 to 2969 => avalon_mm_address_o <= std_logic_vector(to_unsigned(156, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6EA8754E086BC994"; avalon_mm_byteenable_o <= "11111111";
when 2971 to 2972 => avalon_mm_address_o <= std_logic_vector(to_unsigned(157, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"5C62CC1759E1D677"; avalon_mm_byteenable_o <= "11111111";
when 2974 to 2975 => avalon_mm_address_o <= std_logic_vector(to_unsigned(158, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"1568BCBB531D7B4D"; avalon_mm_byteenable_o <= "11111111";
when 2977 to 2978 => avalon_mm_address_o <= std_logic_vector(to_unsigned(159, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"96A85752DFF7770D"; avalon_mm_byteenable_o <= "11111111";
when 2980 to 2981 => avalon_mm_address_o <= std_logic_vector(to_unsigned(160, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"62F93B3224E04DA4"; avalon_mm_byteenable_o <= "11111111";
when 2983 to 2984 => avalon_mm_address_o <= std_logic_vector(to_unsigned(161, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"168EAC78E1908868"; avalon_mm_byteenable_o <= "11111111";
when 2986 to 2987 => avalon_mm_address_o <= std_logic_vector(to_unsigned(162, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D38EDA48891FF17E"; avalon_mm_byteenable_o <= "11111111";
when 2989 to 2990 => avalon_mm_address_o <= std_logic_vector(to_unsigned(163, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"15DA9B5225C22C1B"; avalon_mm_byteenable_o <= "11111111";
when 2992 to 2993 => avalon_mm_address_o <= std_logic_vector(to_unsigned(164, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C94F5B24D0011B3B"; avalon_mm_byteenable_o <= "11111111";
when 2995 to 2996 => avalon_mm_address_o <= std_logic_vector(to_unsigned(165, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"11CCFEF87716DDA7"; avalon_mm_byteenable_o <= "11111111";
when 2998 to 2999 => avalon_mm_address_o <= std_logic_vector(to_unsigned(166, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"BD1DA86C937A055D"; avalon_mm_byteenable_o <= "11111111";
when 3001 to 3002 => avalon_mm_address_o <= std_logic_vector(to_unsigned(167, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A53DDC7EAE498A48"; avalon_mm_byteenable_o <= "11111111";
when 3004 to 3005 => avalon_mm_address_o <= std_logic_vector(to_unsigned(168, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"4BE5D58CCF3B20F4"; avalon_mm_byteenable_o <= "11111111";
when 3007 to 3008 => avalon_mm_address_o <= std_logic_vector(to_unsigned(169, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8E93635FB4950B9C"; avalon_mm_byteenable_o <= "11111111";
when 3010 to 3011 => avalon_mm_address_o <= std_logic_vector(to_unsigned(170, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A634C3CAF9F573AB"; avalon_mm_byteenable_o <= "11111111";
when 3013 to 3014 => avalon_mm_address_o <= std_logic_vector(to_unsigned(171, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FCEE60914B3C6439"; avalon_mm_byteenable_o <= "11111111";
when 3016 to 3017 => avalon_mm_address_o <= std_logic_vector(to_unsigned(172, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6B8BE4B8BE462068"; avalon_mm_byteenable_o <= "11111111";
when 3019 to 3020 => avalon_mm_address_o <= std_logic_vector(to_unsigned(173, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6EEF505D0023DD21"; avalon_mm_byteenable_o <= "11111111";
when 3022 to 3023 => avalon_mm_address_o <= std_logic_vector(to_unsigned(174, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"65F00D528E503658"; avalon_mm_byteenable_o <= "11111111";
when 3025 to 3026 => avalon_mm_address_o <= std_logic_vector(to_unsigned(175, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"325C34434206C6A3"; avalon_mm_byteenable_o <= "11111111";
when 3028 to 3029 => avalon_mm_address_o <= std_logic_vector(to_unsigned(176, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"366115C2805EBDE2"; avalon_mm_byteenable_o <= "11111111";
when 3031 to 3032 => avalon_mm_address_o <= std_logic_vector(to_unsigned(177, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6E8F3E2451E3D014"; avalon_mm_byteenable_o <= "11111111";
when 3034 to 3035 => avalon_mm_address_o <= std_logic_vector(to_unsigned(178, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"99EA33C18E3B4944"; avalon_mm_byteenable_o <= "11111111";
when 3037 to 3038 => avalon_mm_address_o <= std_logic_vector(to_unsigned(179, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D7217B5FAE23C70C"; avalon_mm_byteenable_o <= "11111111";
when 3040 to 3041 => avalon_mm_address_o <= std_logic_vector(to_unsigned(180, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"E7A68345A999FF8C"; avalon_mm_byteenable_o <= "11111111";
when 3043 to 3044 => avalon_mm_address_o <= std_logic_vector(to_unsigned(181, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D72A859EB240EDDB"; avalon_mm_byteenable_o <= "11111111";
when 3046 to 3047 => avalon_mm_address_o <= std_logic_vector(to_unsigned(182, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"E6FF99D99719EA04"; avalon_mm_byteenable_o <= "11111111";
when 3049 to 3050 => avalon_mm_address_o <= std_logic_vector(to_unsigned(183, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2D40C0A8E4290B5F"; avalon_mm_byteenable_o <= "11111111";
when 3052 to 3053 => avalon_mm_address_o <= std_logic_vector(to_unsigned(184, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2F2AFA82B5068CCD"; avalon_mm_byteenable_o <= "11111111";
when 3055 to 3056 => avalon_mm_address_o <= std_logic_vector(to_unsigned(185, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"552E47FFA00F7B33"; avalon_mm_byteenable_o <= "11111111";
when 3058 to 3059 => avalon_mm_address_o <= std_logic_vector(to_unsigned(186, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FE96EE82BE621475"; avalon_mm_byteenable_o <= "11111111";
when 3061 to 3062 => avalon_mm_address_o <= std_logic_vector(to_unsigned(187, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F0526EDA389ED186"; avalon_mm_byteenable_o <= "11111111";
when 3064 to 3065 => avalon_mm_address_o <= std_logic_vector(to_unsigned(188, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"59DA36B51261AC44"; avalon_mm_byteenable_o <= "11111111";
when 3067 to 3068 => avalon_mm_address_o <= std_logic_vector(to_unsigned(189, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0B0812CB831A57DF"; avalon_mm_byteenable_o <= "11111111";
when 3070 to 3071 => avalon_mm_address_o <= std_logic_vector(to_unsigned(190, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D5F494DBD14F8EFF"; avalon_mm_byteenable_o <= "11111111";
when 3073 to 3074 => avalon_mm_address_o <= std_logic_vector(to_unsigned(191, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7FF9BB2DA0767C1B"; avalon_mm_byteenable_o <= "11111111";
when 3076 to 3077 => avalon_mm_address_o <= std_logic_vector(to_unsigned(192, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CF2840D1B733DA8F"; avalon_mm_byteenable_o <= "11111111";
when 3079 to 3080 => avalon_mm_address_o <= std_logic_vector(to_unsigned(193, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3147890FFDAC4C5E"; avalon_mm_byteenable_o <= "11111111";
when 3082 to 3083 => avalon_mm_address_o <= std_logic_vector(to_unsigned(194, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"148E3484D61A0831"; avalon_mm_byteenable_o <= "11111111";
when 3085 to 3086 => avalon_mm_address_o <= std_logic_vector(to_unsigned(195, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"606ECC714FB6CE91"; avalon_mm_byteenable_o <= "11111111";
when 3088 to 3089 => avalon_mm_address_o <= std_logic_vector(to_unsigned(196, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"57FC955CF0B8D89D"; avalon_mm_byteenable_o <= "11111111";
when 3091 to 3092 => avalon_mm_address_o <= std_logic_vector(to_unsigned(197, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"4E7F6E3A546C705B"; avalon_mm_byteenable_o <= "11111111";
when 3094 to 3095 => avalon_mm_address_o <= std_logic_vector(to_unsigned(198, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"113404DA14CB39E9"; avalon_mm_byteenable_o <= "11111111";
when 3097 to 3098 => avalon_mm_address_o <= std_logic_vector(to_unsigned(199, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"22D90713F161A81C"; avalon_mm_byteenable_o <= "11111111";
when 3100 to 3101 => avalon_mm_address_o <= std_logic_vector(to_unsigned(200, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"1AB79DDE8C83A85C"; avalon_mm_byteenable_o <= "11111111";
when 3103 to 3104 => avalon_mm_address_o <= std_logic_vector(to_unsigned(201, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"4C83999BAC4ADFD8"; avalon_mm_byteenable_o <= "11111111";
when 3106 to 3107 => avalon_mm_address_o <= std_logic_vector(to_unsigned(202, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F98DFDF51C776EB1"; avalon_mm_byteenable_o <= "11111111";
when 3109 to 3110 => avalon_mm_address_o <= std_logic_vector(to_unsigned(203, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D882CF855EA2BA70"; avalon_mm_byteenable_o <= "11111111";
when 3112 to 3113 => avalon_mm_address_o <= std_logic_vector(to_unsigned(204, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"BEA3C10E2BBBD0BB"; avalon_mm_byteenable_o <= "11111111";
when 3115 to 3116 => avalon_mm_address_o <= std_logic_vector(to_unsigned(205, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"04B45A081246B69E"; avalon_mm_byteenable_o <= "11111111";
when 3118 to 3119 => avalon_mm_address_o <= std_logic_vector(to_unsigned(206, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2DB0A4D06E250AA6"; avalon_mm_byteenable_o <= "11111111";
when 3121 to 3122 => avalon_mm_address_o <= std_logic_vector(to_unsigned(207, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7F55829E275B6B62"; avalon_mm_byteenable_o <= "11111111";
when 3124 to 3125 => avalon_mm_address_o <= std_logic_vector(to_unsigned(208, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0B5F5482250479DA"; avalon_mm_byteenable_o <= "11111111";
when 3127 to 3128 => avalon_mm_address_o <= std_logic_vector(to_unsigned(209, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"47DA218A4712D997"; avalon_mm_byteenable_o <= "11111111";
when 3130 to 3131 => avalon_mm_address_o <= std_logic_vector(to_unsigned(210, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C7DE9D3DDD170F08"; avalon_mm_byteenable_o <= "11111111";
when 3133 to 3134 => avalon_mm_address_o <= std_logic_vector(to_unsigned(211, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"957E9512FD9AC102"; avalon_mm_byteenable_o <= "11111111";
when 3136 to 3137 => avalon_mm_address_o <= std_logic_vector(to_unsigned(212, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"79AA5514BDDE1551"; avalon_mm_byteenable_o <= "11111111";
when 3139 to 3140 => avalon_mm_address_o <= std_logic_vector(to_unsigned(213, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"EC4EE4C656AC5D70"; avalon_mm_byteenable_o <= "11111111";
when 3142 to 3143 => avalon_mm_address_o <= std_logic_vector(to_unsigned(214, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CFB92E655869B93A"; avalon_mm_byteenable_o <= "11111111";
when 3145 to 3146 => avalon_mm_address_o <= std_logic_vector(to_unsigned(215, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A3DF3AB29B2C425C"; avalon_mm_byteenable_o <= "11111111";
when 3148 to 3149 => avalon_mm_address_o <= std_logic_vector(to_unsigned(216, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"5E6041721CEEA1A3"; avalon_mm_byteenable_o <= "11111111";
when 3151 to 3152 => avalon_mm_address_o <= std_logic_vector(to_unsigned(217, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"1E73536F0C65DA96"; avalon_mm_byteenable_o <= "11111111";
when 3154 to 3155 => avalon_mm_address_o <= std_logic_vector(to_unsigned(218, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"4F6B7F41442A05EF"; avalon_mm_byteenable_o <= "11111111";
when 3157 to 3158 => avalon_mm_address_o <= std_logic_vector(to_unsigned(219, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2753368867730F60"; avalon_mm_byteenable_o <= "11111111";
when 3160 to 3161 => avalon_mm_address_o <= std_logic_vector(to_unsigned(220, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"33ED56964441D373"; avalon_mm_byteenable_o <= "11111111";
when 3163 to 3164 => avalon_mm_address_o <= std_logic_vector(to_unsigned(221, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"1A2524F7F24A2812"; avalon_mm_byteenable_o <= "11111111";
when 3166 to 3167 => avalon_mm_address_o <= std_logic_vector(to_unsigned(222, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D69E4E051657789C"; avalon_mm_byteenable_o <= "11111111";
when 3169 to 3170 => avalon_mm_address_o <= std_logic_vector(to_unsigned(223, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FD8209AB1AC99962"; avalon_mm_byteenable_o <= "11111111";
when 3172 to 3173 => avalon_mm_address_o <= std_logic_vector(to_unsigned(224, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7E43F9612A351792"; avalon_mm_byteenable_o <= "11111111";
when 3175 to 3176 => avalon_mm_address_o <= std_logic_vector(to_unsigned(225, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"5405FB693F701DE5"; avalon_mm_byteenable_o <= "11111111";
when 3178 to 3179 => avalon_mm_address_o <= std_logic_vector(to_unsigned(226, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2F3B4F26E54A5988"; avalon_mm_byteenable_o <= "11111111";
when 3181 to 3182 => avalon_mm_address_o <= std_logic_vector(to_unsigned(227, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"509DA31A700A9051"; avalon_mm_byteenable_o <= "11111111";
when 3184 to 3185 => avalon_mm_address_o <= std_logic_vector(to_unsigned(228, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"33D776312FC75BD6"; avalon_mm_byteenable_o <= "11111111";
when 3187 to 3188 => avalon_mm_address_o <= std_logic_vector(to_unsigned(229, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C4D4EE8A32DF614F"; avalon_mm_byteenable_o <= "11111111";
when 3190 to 3191 => avalon_mm_address_o <= std_logic_vector(to_unsigned(230, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"07249CDAD066909F"; avalon_mm_byteenable_o <= "11111111";
when 3193 to 3194 => avalon_mm_address_o <= std_logic_vector(to_unsigned(231, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"115D17798AE2A98D"; avalon_mm_byteenable_o <= "11111111";
when 3196 to 3197 => avalon_mm_address_o <= std_logic_vector(to_unsigned(232, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3E838B8085E4323B"; avalon_mm_byteenable_o <= "11111111";
when 3199 to 3200 => avalon_mm_address_o <= std_logic_vector(to_unsigned(233, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"03805F58F3EA9791"; avalon_mm_byteenable_o <= "11111111";
when 3202 to 3203 => avalon_mm_address_o <= std_logic_vector(to_unsigned(234, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0DCB8A71B8247A1E"; avalon_mm_byteenable_o <= "11111111";
when 3205 to 3206 => avalon_mm_address_o <= std_logic_vector(to_unsigned(235, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"59372302DDD1F47F"; avalon_mm_byteenable_o <= "11111111";
when 3208 to 3209 => avalon_mm_address_o <= std_logic_vector(to_unsigned(236, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"BEDC2D70D25F373F"; avalon_mm_byteenable_o <= "11111111";
when 3211 to 3212 => avalon_mm_address_o <= std_logic_vector(to_unsigned(237, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"EAA4971370863DBD"; avalon_mm_byteenable_o <= "11111111";
when 3214 to 3215 => avalon_mm_address_o <= std_logic_vector(to_unsigned(238, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"20EF12E6855365E1"; avalon_mm_byteenable_o <= "11111111";
when 3217 to 3218 => avalon_mm_address_o <= std_logic_vector(to_unsigned(239, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0C94108B23319A3B"; avalon_mm_byteenable_o <= "11111111";
when 3220 to 3221 => avalon_mm_address_o <= std_logic_vector(to_unsigned(240, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9203B2A50EE75ABE"; avalon_mm_byteenable_o <= "11111111";
when 3223 to 3224 => avalon_mm_address_o <= std_logic_vector(to_unsigned(241, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"465E57205BEC1F97"; avalon_mm_byteenable_o <= "11111111";
when 3226 to 3227 => avalon_mm_address_o <= std_logic_vector(to_unsigned(242, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"856D568C90341023"; avalon_mm_byteenable_o <= "11111111";
when 3229 to 3230 => avalon_mm_address_o <= std_logic_vector(to_unsigned(243, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"527C30F9AACC952E"; avalon_mm_byteenable_o <= "11111111";
when 3232 to 3233 => avalon_mm_address_o <= std_logic_vector(to_unsigned(244, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2711DF7E5E3E3F9F"; avalon_mm_byteenable_o <= "11111111";
when 3235 to 3236 => avalon_mm_address_o <= std_logic_vector(to_unsigned(245, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8CAFFFA79AC08A74"; avalon_mm_byteenable_o <= "11111111";
when 3238 to 3239 => avalon_mm_address_o <= std_logic_vector(to_unsigned(246, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B524F56691663957"; avalon_mm_byteenable_o <= "11111111";
when 3241 to 3242 => avalon_mm_address_o <= std_logic_vector(to_unsigned(247, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"E31DDA132F9CCECF"; avalon_mm_byteenable_o <= "11111111";
when 3244 to 3245 => avalon_mm_address_o <= std_logic_vector(to_unsigned(248, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"259FF72A3BB57BB4"; avalon_mm_byteenable_o <= "11111111";
when 3247 to 3248 => avalon_mm_address_o <= std_logic_vector(to_unsigned(249, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"E90702244619A0EF"; avalon_mm_byteenable_o <= "11111111";
when 3250 to 3251 => avalon_mm_address_o <= std_logic_vector(to_unsigned(250, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C118CB3E1AF4F9A2"; avalon_mm_byteenable_o <= "11111111";
when 3253 to 3254 => avalon_mm_address_o <= std_logic_vector(to_unsigned(251, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"49750AF8C1540FC5"; avalon_mm_byteenable_o <= "11111111";
when 3256 to 3257 => avalon_mm_address_o <= std_logic_vector(to_unsigned(252, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"461CE8E23CE8A3E8"; avalon_mm_byteenable_o <= "11111111";
when 3259 to 3260 => avalon_mm_address_o <= std_logic_vector(to_unsigned(253, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A6E94DC2D5442ECF"; avalon_mm_byteenable_o <= "11111111";
when 3262 to 3263 => avalon_mm_address_o <= std_logic_vector(to_unsigned(254, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6D2CAC687A95516E"; avalon_mm_byteenable_o <= "11111111";
when 3265 to 3266 => avalon_mm_address_o <= std_logic_vector(to_unsigned(255, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"AE65F0DA7688B401"; avalon_mm_byteenable_o <= "11111111";
when 3268 to 3269 => avalon_mm_address_o <= std_logic_vector(to_unsigned(256, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8D65D2A811FE83ED"; avalon_mm_byteenable_o <= "11111111";
when 3271 to 3272 => avalon_mm_address_o <= std_logic_vector(to_unsigned(257, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B5104D0CF61A4812"; avalon_mm_byteenable_o <= "11111111";
when 3274 to 3275 => avalon_mm_address_o <= std_logic_vector(to_unsigned(258, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2C44B16D23ECE255"; avalon_mm_byteenable_o <= "11111111";
when 3277 to 3278 => avalon_mm_address_o <= std_logic_vector(to_unsigned(259, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"99492AF9EE7D3D86"; avalon_mm_byteenable_o <= "11111111";
when 3280 to 3281 => avalon_mm_address_o <= std_logic_vector(to_unsigned(260, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C22127D08BB7F1A0"; avalon_mm_byteenable_o <= "11111111";
when 3283 to 3284 => avalon_mm_address_o <= std_logic_vector(to_unsigned(261, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"75618319DD2E1E25"; avalon_mm_byteenable_o <= "11111111";
when 3286 to 3287 => avalon_mm_address_o <= std_logic_vector(to_unsigned(262, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"AC5B0F32726B3648"; avalon_mm_byteenable_o <= "11111111";
when 3289 to 3290 => avalon_mm_address_o <= std_logic_vector(to_unsigned(263, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"4CA00C1B5AE363E0"; avalon_mm_byteenable_o <= "11111111";
when 3292 to 3293 => avalon_mm_address_o <= std_logic_vector(to_unsigned(264, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"76C3553F9742E188"; avalon_mm_byteenable_o <= "11111111";
when 3295 to 3296 => avalon_mm_address_o <= std_logic_vector(to_unsigned(265, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"DC1B8C3659C29CAC"; avalon_mm_byteenable_o <= "11111111";
when 3298 to 3299 => avalon_mm_address_o <= std_logic_vector(to_unsigned(266, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2A40DE0EE69299E3"; avalon_mm_byteenable_o <= "11111111";
when 3301 to 3302 => avalon_mm_address_o <= std_logic_vector(to_unsigned(267, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8362428244CE1ED0"; avalon_mm_byteenable_o <= "11111111";
when 3304 to 3305 => avalon_mm_address_o <= std_logic_vector(to_unsigned(268, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FB6C223D3742076C"; avalon_mm_byteenable_o <= "11111111";
when 3307 to 3308 => avalon_mm_address_o <= std_logic_vector(to_unsigned(269, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C967FEDE2CAEC9DC"; avalon_mm_byteenable_o <= "11111111";
when 3310 to 3311 => avalon_mm_address_o <= std_logic_vector(to_unsigned(270, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"BF6E095C16A2467F"; avalon_mm_byteenable_o <= "11111111";
when 3313 to 3314 => avalon_mm_address_o <= std_logic_vector(to_unsigned(271, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9697903E38F5EBF8"; avalon_mm_byteenable_o <= "11111111";
when 3316 to 3317 => avalon_mm_address_o <= std_logic_vector(to_unsigned(272, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"104DE44D8FBD9307"; avalon_mm_byteenable_o <= "11111111";
when 3319 to 3320 => avalon_mm_address_o <= std_logic_vector(to_unsigned(273, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9143E94BF483D784"; avalon_mm_byteenable_o <= "11111111";
when 3322 to 3323 => avalon_mm_address_o <= std_logic_vector(to_unsigned(274, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"802FBD67BAE71AA0"; avalon_mm_byteenable_o <= "11111111";
when 3325 to 3326 => avalon_mm_address_o <= std_logic_vector(to_unsigned(275, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"556982488FAA89D9"; avalon_mm_byteenable_o <= "11111111";
when 3328 to 3329 => avalon_mm_address_o <= std_logic_vector(to_unsigned(276, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3AE5185E0639FFD1"; avalon_mm_byteenable_o <= "11111111";
when 3331 to 3332 => avalon_mm_address_o <= std_logic_vector(to_unsigned(277, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"290542CFA337EEE3"; avalon_mm_byteenable_o <= "11111111";
when 3334 to 3335 => avalon_mm_address_o <= std_logic_vector(to_unsigned(278, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7F68E27881F048F6"; avalon_mm_byteenable_o <= "11111111";
when 3337 to 3338 => avalon_mm_address_o <= std_logic_vector(to_unsigned(279, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3791E97CC8C6F0CB"; avalon_mm_byteenable_o <= "11111111";
when 3340 to 3341 => avalon_mm_address_o <= std_logic_vector(to_unsigned(280, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"5A2713DBBE5F2F52"; avalon_mm_byteenable_o <= "11111111";
when 3343 to 3344 => avalon_mm_address_o <= std_logic_vector(to_unsigned(281, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"537AE62063F7C10C"; avalon_mm_byteenable_o <= "11111111";
when 3346 to 3347 => avalon_mm_address_o <= std_logic_vector(to_unsigned(282, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CE3152317103C048"; avalon_mm_byteenable_o <= "11111111";
when 3349 to 3350 => avalon_mm_address_o <= std_logic_vector(to_unsigned(283, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F125171DEFBC7F06"; avalon_mm_byteenable_o <= "11111111";
when 3352 to 3353 => avalon_mm_address_o <= std_logic_vector(to_unsigned(284, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"EA6AF8BF881435AF"; avalon_mm_byteenable_o <= "11111111";
when 3355 to 3356 => avalon_mm_address_o <= std_logic_vector(to_unsigned(285, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B209F2F0334D7A5F"; avalon_mm_byteenable_o <= "11111111";
when 3358 to 3359 => avalon_mm_address_o <= std_logic_vector(to_unsigned(286, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A2D4772E8F1F62E6"; avalon_mm_byteenable_o <= "11111111";
when 3361 to 3362 => avalon_mm_address_o <= std_logic_vector(to_unsigned(287, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"BB148E4C7427E781"; avalon_mm_byteenable_o <= "11111111";
when 3364 to 3365 => avalon_mm_address_o <= std_logic_vector(to_unsigned(288, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D3AC9F4A392C7815"; avalon_mm_byteenable_o <= "11111111";
when 3367 to 3368 => avalon_mm_address_o <= std_logic_vector(to_unsigned(289, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B7476E4A6E21CD24"; avalon_mm_byteenable_o <= "11111111";
when 3370 to 3371 => avalon_mm_address_o <= std_logic_vector(to_unsigned(290, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D9EDE0E2F982D8E6"; avalon_mm_byteenable_o <= "11111111";
when 3373 to 3374 => avalon_mm_address_o <= std_logic_vector(to_unsigned(291, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FF04EC25CDA85CE3"; avalon_mm_byteenable_o <= "11111111";
when 3376 to 3377 => avalon_mm_address_o <= std_logic_vector(to_unsigned(292, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"E62D34AEB3041B4E"; avalon_mm_byteenable_o <= "11111111";
when 3379 to 3380 => avalon_mm_address_o <= std_logic_vector(to_unsigned(293, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8D0994E8D75266FC"; avalon_mm_byteenable_o <= "11111111";
when 3382 to 3383 => avalon_mm_address_o <= std_logic_vector(to_unsigned(294, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"73E3CCDA0B0EE9A4"; avalon_mm_byteenable_o <= "11111111";
when 3385 to 3386 => avalon_mm_address_o <= std_logic_vector(to_unsigned(295, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"464342960E40DFCB"; avalon_mm_byteenable_o <= "11111111";
when 3388 to 3389 => avalon_mm_address_o <= std_logic_vector(to_unsigned(296, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"BE9D0DFEB9053D52"; avalon_mm_byteenable_o <= "11111111";
when 3391 to 3392 => avalon_mm_address_o <= std_logic_vector(to_unsigned(297, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"85B7F4853A96D2DF"; avalon_mm_byteenable_o <= "11111111";
when 3394 to 3395 => avalon_mm_address_o <= std_logic_vector(to_unsigned(298, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"583F1AFDF4F7D0FE"; avalon_mm_byteenable_o <= "11111111";
when 3397 to 3398 => avalon_mm_address_o <= std_logic_vector(to_unsigned(299, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9C6CB4663D436D01"; avalon_mm_byteenable_o <= "11111111";
when 3400 to 3401 => avalon_mm_address_o <= std_logic_vector(to_unsigned(300, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9F2F22705BD54FAF"; avalon_mm_byteenable_o <= "11111111";
when 3403 to 3404 => avalon_mm_address_o <= std_logic_vector(to_unsigned(301, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"66F841D0A6BE950C"; avalon_mm_byteenable_o <= "11111111";
when 3406 to 3407 => avalon_mm_address_o <= std_logic_vector(to_unsigned(302, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8B6FEFC14915AE86"; avalon_mm_byteenable_o <= "11111111";
when 3409 to 3410 => avalon_mm_address_o <= std_logic_vector(to_unsigned(303, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8D9C29479ECA9AAB"; avalon_mm_byteenable_o <= "11111111";
when 3412 to 3413 => avalon_mm_address_o <= std_logic_vector(to_unsigned(304, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B9F287D9BDA9E175"; avalon_mm_byteenable_o <= "11111111";
when 3415 to 3416 => avalon_mm_address_o <= std_logic_vector(to_unsigned(305, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"DEB6B12CDFAF9EE2"; avalon_mm_byteenable_o <= "11111111";
when 3418 to 3419 => avalon_mm_address_o <= std_logic_vector(to_unsigned(306, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"02CE0E3115303AC8"; avalon_mm_byteenable_o <= "11111111";
when 3421 to 3422 => avalon_mm_address_o <= std_logic_vector(to_unsigned(307, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9050A5E1911E627C"; avalon_mm_byteenable_o <= "11111111";
when 3424 to 3425 => avalon_mm_address_o <= std_logic_vector(to_unsigned(308, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"EC303DFED656F0DA"; avalon_mm_byteenable_o <= "11111111";
when 3427 to 3428 => avalon_mm_address_o <= std_logic_vector(to_unsigned(309, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6FE48DADE518F1A2"; avalon_mm_byteenable_o <= "11111111";
when 3430 to 3431 => avalon_mm_address_o <= std_logic_vector(to_unsigned(310, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C4F5DA915925E33D"; avalon_mm_byteenable_o <= "11111111";
when 3433 to 3434 => avalon_mm_address_o <= std_logic_vector(to_unsigned(311, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C284BEB2DF022EE4"; avalon_mm_byteenable_o <= "11111111";
when 3436 to 3437 => avalon_mm_address_o <= std_logic_vector(to_unsigned(312, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A01DC31C79749ADB"; avalon_mm_byteenable_o <= "11111111";
when 3439 to 3440 => avalon_mm_address_o <= std_logic_vector(to_unsigned(313, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"E8EB4A3A731D587D"; avalon_mm_byteenable_o <= "11111111";
when 3442 to 3443 => avalon_mm_address_o <= std_logic_vector(to_unsigned(314, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"21F4726AEAF3B2B1"; avalon_mm_byteenable_o <= "11111111";
when 3445 to 3446 => avalon_mm_address_o <= std_logic_vector(to_unsigned(315, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CE7833532087E08F"; avalon_mm_byteenable_o <= "11111111";
when 3448 to 3449 => avalon_mm_address_o <= std_logic_vector(to_unsigned(316, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"33439B04D2AD204D"; avalon_mm_byteenable_o <= "11111111";
when 3451 to 3452 => avalon_mm_address_o <= std_logic_vector(to_unsigned(317, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"22B8B872F1AD86BD"; avalon_mm_byteenable_o <= "11111111";
when 3454 to 3455 => avalon_mm_address_o <= std_logic_vector(to_unsigned(318, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"789D25D8E0AC2E33"; avalon_mm_byteenable_o <= "11111111";
when 3457 to 3458 => avalon_mm_address_o <= std_logic_vector(to_unsigned(319, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FE9895E402596E23"; avalon_mm_byteenable_o <= "11111111";
when 3460 to 3461 => avalon_mm_address_o <= std_logic_vector(to_unsigned(320, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"937BE218696E9728"; avalon_mm_byteenable_o <= "11111111";
when 3463 to 3464 => avalon_mm_address_o <= std_logic_vector(to_unsigned(321, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"12FD93DDD238DEA4"; avalon_mm_byteenable_o <= "11111111";
when 3466 to 3467 => avalon_mm_address_o <= std_logic_vector(to_unsigned(322, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8BF441D9473CEE22"; avalon_mm_byteenable_o <= "11111111";
when 3469 to 3470 => avalon_mm_address_o <= std_logic_vector(to_unsigned(323, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"90E3DE71CDE2FB15"; avalon_mm_byteenable_o <= "11111111";
when 3472 to 3473 => avalon_mm_address_o <= std_logic_vector(to_unsigned(324, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"375C898629513E86"; avalon_mm_byteenable_o <= "11111111";
when 3475 to 3476 => avalon_mm_address_o <= std_logic_vector(to_unsigned(325, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7552374A76532E99"; avalon_mm_byteenable_o <= "11111111";
when 3478 to 3479 => avalon_mm_address_o <= std_logic_vector(to_unsigned(326, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F37C6776BB58E93D"; avalon_mm_byteenable_o <= "11111111";
when 3481 to 3482 => avalon_mm_address_o <= std_logic_vector(to_unsigned(327, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"5FD75A219FD393D8"; avalon_mm_byteenable_o <= "11111111";
when 3484 to 3485 => avalon_mm_address_o <= std_logic_vector(to_unsigned(328, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"126548A9EE528D31"; avalon_mm_byteenable_o <= "11111111";
when 3487 to 3488 => avalon_mm_address_o <= std_logic_vector(to_unsigned(329, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F7E81F3AE395B931"; avalon_mm_byteenable_o <= "11111111";
when 3490 to 3491 => avalon_mm_address_o <= std_logic_vector(to_unsigned(330, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A5A1310D41C9BD48"; avalon_mm_byteenable_o <= "11111111";
when 3493 to 3494 => avalon_mm_address_o <= std_logic_vector(to_unsigned(331, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"2D916B3E459B6B23"; avalon_mm_byteenable_o <= "11111111";
when 3496 to 3497 => avalon_mm_address_o <= std_logic_vector(to_unsigned(332, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"4A9005E039438C60"; avalon_mm_byteenable_o <= "11111111";
when 3499 to 3500 => avalon_mm_address_o <= std_logic_vector(to_unsigned(333, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A8900FD4587EEAB8"; avalon_mm_byteenable_o <= "11111111";
when 3502 to 3503 => avalon_mm_address_o <= std_logic_vector(to_unsigned(334, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F771CC4E08B21736"; avalon_mm_byteenable_o <= "11111111";
when 3505 to 3506 => avalon_mm_address_o <= std_logic_vector(to_unsigned(335, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"61901E3FE0934871"; avalon_mm_byteenable_o <= "11111111";
when 3508 to 3509 => avalon_mm_address_o <= std_logic_vector(to_unsigned(336, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F3606649AAE9A0F4"; avalon_mm_byteenable_o <= "11111111";
when 3511 to 3512 => avalon_mm_address_o <= std_logic_vector(to_unsigned(337, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0E8A087EFD7E7137"; avalon_mm_byteenable_o <= "11111111";
when 3514 to 3515 => avalon_mm_address_o <= std_logic_vector(to_unsigned(338, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"864F772448496098"; avalon_mm_byteenable_o <= "11111111";
when 3517 to 3518 => avalon_mm_address_o <= std_logic_vector(to_unsigned(339, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F8F7746739CDB7F5"; avalon_mm_byteenable_o <= "11111111";
when 3520 to 3521 => avalon_mm_address_o <= std_logic_vector(to_unsigned(340, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"007DE009EC8D4327"; avalon_mm_byteenable_o <= "11111111";
when 3523 to 3524 => avalon_mm_address_o <= std_logic_vector(to_unsigned(341, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9B06C28E7EF8C4D3"; avalon_mm_byteenable_o <= "11111111";
when 3526 to 3527 => avalon_mm_address_o <= std_logic_vector(to_unsigned(342, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A83E0BD67E3236B4"; avalon_mm_byteenable_o <= "11111111";
when 3529 to 3530 => avalon_mm_address_o <= std_logic_vector(to_unsigned(343, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"88B5EEAFF3E1855C"; avalon_mm_byteenable_o <= "11111111";
when 3532 to 3533 => avalon_mm_address_o <= std_logic_vector(to_unsigned(344, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"36DB86B6DCA53889"; avalon_mm_byteenable_o <= "11111111";
when 3535 to 3536 => avalon_mm_address_o <= std_logic_vector(to_unsigned(345, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8D599E836A4AB305"; avalon_mm_byteenable_o <= "11111111";
when 3538 to 3539 => avalon_mm_address_o <= std_logic_vector(to_unsigned(346, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FFB632A0C92109EC"; avalon_mm_byteenable_o <= "11111111";
when 3541 to 3542 => avalon_mm_address_o <= std_logic_vector(to_unsigned(347, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"70A9FB9CDAF9CE37"; avalon_mm_byteenable_o <= "11111111";
when 3544 to 3545 => avalon_mm_address_o <= std_logic_vector(to_unsigned(348, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"5D67FA5766605CB8"; avalon_mm_byteenable_o <= "11111111";
when 3547 to 3548 => avalon_mm_address_o <= std_logic_vector(to_unsigned(349, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"E6FBA7313027A9D3"; avalon_mm_byteenable_o <= "11111111";
when 3550 to 3551 => avalon_mm_address_o <= std_logic_vector(to_unsigned(350, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"916593098602D4B1"; avalon_mm_byteenable_o <= "11111111";
when 3553 to 3554 => avalon_mm_address_o <= std_logic_vector(to_unsigned(351, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"5BBA8B2E3E8AAC92"; avalon_mm_byteenable_o <= "11111111";
when 3556 to 3557 => avalon_mm_address_o <= std_logic_vector(to_unsigned(352, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"4273B8E5AEF464D5"; avalon_mm_byteenable_o <= "11111111";
when 3559 to 3560 => avalon_mm_address_o <= std_logic_vector(to_unsigned(353, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"F389E342334052D7"; avalon_mm_byteenable_o <= "11111111";
when 3562 to 3563 => avalon_mm_address_o <= std_logic_vector(to_unsigned(354, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0E021943EA33764E"; avalon_mm_byteenable_o <= "11111111";
when 3565 to 3566 => avalon_mm_address_o <= std_logic_vector(to_unsigned(355, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"E217C3A851455C78"; avalon_mm_byteenable_o <= "11111111";
when 3568 to 3569 => avalon_mm_address_o <= std_logic_vector(to_unsigned(356, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"8D89024B211E42F0"; avalon_mm_byteenable_o <= "11111111";
when 3571 to 3572 => avalon_mm_address_o <= std_logic_vector(to_unsigned(357, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"683950874CA7B65D"; avalon_mm_byteenable_o <= "11111111";
when 3574 to 3575 => avalon_mm_address_o <= std_logic_vector(to_unsigned(358, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0FB13D39B2AAE686"; avalon_mm_byteenable_o <= "11111111";
when 3577 to 3578 => avalon_mm_address_o <= std_logic_vector(to_unsigned(359, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6CF0D148FD49030C"; avalon_mm_byteenable_o <= "11111111";
when 3580 to 3581 => avalon_mm_address_o <= std_logic_vector(to_unsigned(360, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"CF7BBC467F0E1038"; avalon_mm_byteenable_o <= "11111111";
when 3583 to 3584 => avalon_mm_address_o <= std_logic_vector(to_unsigned(361, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D3E6ECCBE6D1667D"; avalon_mm_byteenable_o <= "11111111";
when 3586 to 3587 => avalon_mm_address_o <= std_logic_vector(to_unsigned(362, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"C5BD2567FCEAB270"; avalon_mm_byteenable_o <= "11111111";
when 3589 to 3590 => avalon_mm_address_o <= std_logic_vector(to_unsigned(363, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"7F3767674E0B94E5"; avalon_mm_byteenable_o <= "11111111";
when 3592 to 3593 => avalon_mm_address_o <= std_logic_vector(to_unsigned(364, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"9E8DE1C5AAF3C329"; avalon_mm_byteenable_o <= "11111111";
when 3595 to 3596 => avalon_mm_address_o <= std_logic_vector(to_unsigned(365, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"1705BF8AAE4EFDAC"; avalon_mm_byteenable_o <= "11111111";
when 3598 to 3599 => avalon_mm_address_o <= std_logic_vector(to_unsigned(366, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"A17C7698FC2155F7"; avalon_mm_byteenable_o <= "11111111";
when 3601 to 3602 => avalon_mm_address_o <= std_logic_vector(to_unsigned(367, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"6ECD581434599B53"; avalon_mm_byteenable_o <= "11111111";
when 3604 to 3605 => avalon_mm_address_o <= std_logic_vector(to_unsigned(368, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D829B29873DE0DE2"; avalon_mm_byteenable_o <= "11111111";
when 3607 to 3608 => avalon_mm_address_o <= std_logic_vector(to_unsigned(369, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"3BFE073D7754CC03"; avalon_mm_byteenable_o <= "11111111";
when 3610 to 3611 => avalon_mm_address_o <= std_logic_vector(to_unsigned(370, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"0EC54B388D9CA097"; avalon_mm_byteenable_o <= "11111111";
when 3613 to 3614 => avalon_mm_address_o <= std_logic_vector(to_unsigned(371, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"052D3F9CD75944AA"; avalon_mm_byteenable_o <= "11111111";
when 3616 to 3617 => avalon_mm_address_o <= std_logic_vector(to_unsigned(372, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"B64A84547A677D27"; avalon_mm_byteenable_o <= "11111111";
when 3619 to 3620 => avalon_mm_address_o <= std_logic_vector(to_unsigned(373, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"948B3A2B14F34F8A"; avalon_mm_byteenable_o <= "11111111";
when 3622 to 3623 => avalon_mm_address_o <= std_logic_vector(to_unsigned(374, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"D5D0AF840BED36FB"; avalon_mm_byteenable_o <= "11111111";
when 3625 to 3626 => avalon_mm_address_o <= std_logic_vector(to_unsigned(375, g_ADDRESS_WIDTH)); avalon_mm_write_o <= '1'; avalon_mm_writedata_o <= x"FFFF8D57E1B62A2C"; avalon_mm_byteenable_o <= "11111111";
	
when 3700 => s_counter <= 2500;
	
	
				when others =>
					null;

			end case;

		end if;
	end process p_avalon_buffer_stimuli;

end architecture RTL;
