library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.srme_rmap_mem_area_subunit_pkg.all;
use work.srme_avalon_mm_rmap_subunit_pkg.all;

entity srme_rmap_mem_area_subunit_arbiter_ent is
	port(
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		subunit_0_wr_rmap_i   : in  t_srme_subunit_rmap_write_in;
		subunit_0_rd_rmap_i   : in  t_srme_subunit_rmap_read_in;
		subunit_1_wr_rmap_i   : in  t_srme_subunit_rmap_write_in;
		subunit_1_rd_rmap_i   : in  t_srme_subunit_rmap_read_in;
		avalon_0_mm_wr_rmap_i : in  t_srme_avalon_mm_rmap_subunit_write_in;
		avalon_0_mm_rd_rmap_i : in  t_srme_avalon_mm_rmap_subunit_read_in;
		subunit_wr_rmap_i     : in  t_srme_subunit_rmap_write_out;
		subunit_rd_rmap_i     : in  t_srme_subunit_rmap_read_out;
		avalon_mm_wr_rmap_i   : in  t_srme_avalon_mm_rmap_subunit_write_out;
		avalon_mm_rd_rmap_i   : in  t_srme_avalon_mm_rmap_subunit_read_out;
		subunit_0_wr_rmap_o   : out t_srme_subunit_rmap_write_out;
		subunit_0_rd_rmap_o   : out t_srme_subunit_rmap_read_out;
		subunit_1_wr_rmap_o   : out t_srme_subunit_rmap_write_out;
		subunit_1_rd_rmap_o   : out t_srme_subunit_rmap_read_out;
		avalon_0_mm_wr_rmap_o : out t_srme_avalon_mm_rmap_subunit_write_out;
		avalon_0_mm_rd_rmap_o : out t_srme_avalon_mm_rmap_subunit_read_out;
		subunit_wr_rmap_o     : out t_srme_subunit_rmap_write_in;
		subunit_rd_rmap_o     : out t_srme_subunit_rmap_read_in;
		avalon_mm_wr_rmap_o   : out t_srme_avalon_mm_rmap_subunit_write_in;
		avalon_mm_rd_rmap_o   : out t_srme_avalon_mm_rmap_subunit_read_in
	);
end entity srme_rmap_mem_area_subunit_arbiter_ent;

architecture RTL of srme_rmap_mem_area_subunit_arbiter_ent is

	signal s_subunit_rmap_waitrequest   : std_logic;
	signal s_avalon_mm_rmap_waitrequest : std_logic;
	signal s_rmap_waitrequest           : std_logic;

	type t_master_list is (
		master_none,
		master_wr_subunit_0,
		master_wr_subunit_1,
		master_wr_avs_0,
		master_rd_subunit_0,
		master_rd_subunit_1,
		master_rd_avs_0
	);
	signal s_selected_master : t_master_list;

	subtype t_master_queue_index is natural range 0 to 6;
	type t_master_queue is array (0 to t_master_queue_index'high) of t_master_list;
	signal s_master_queue : t_master_queue;

	signal s_master_wr_subunit_0_queued : std_logic;
	signal s_master_wr_subunit_1_queued : std_logic;
	signal s_master_wr_avs_0_queued     : std_logic;
	signal s_master_rd_subunit_0_queued : std_logic;
	signal s_master_rd_subunit_1_queued : std_logic;
	signal s_master_rd_avs_0_queued     : std_logic;

begin

	p_srme_rmap_mem_area_subunit_arbiter : process(clk_i, rst_i) is
		variable v_master_queue_index : t_master_queue_index := 0;

	begin
		if (rst_i = '1') then
			s_selected_master            <= master_none;
			s_master_queue               <= (others => master_none);
			s_master_wr_subunit_0_queued <= '0';
			s_master_wr_subunit_1_queued <= '0';
			s_master_wr_avs_0_queued     <= '0';
			s_master_rd_subunit_0_queued <= '0';
			s_master_rd_subunit_1_queued <= '0';
			s_master_rd_avs_0_queued     <= '0';
			v_master_queue_index         := 0;
		elsif (rising_edge(clk_i)) then

			-- check if master fee 0 requested a write and is not queued
			if ((subunit_0_wr_rmap_i.write = '1') and (s_master_wr_subunit_0_queued = '0')) then
				-- master fee 0 requested a write and is not queued
				-- put master fee 0 write in the queue
				s_master_queue(v_master_queue_index) <= master_wr_subunit_0;
				s_master_wr_subunit_0_queued         <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- check if master fee 1 requested a write and is not queued
			if ((subunit_1_wr_rmap_i.write = '1') and (s_master_wr_subunit_1_queued = '0')) then
				-- master fee 1 requested a write and is not queued
				-- put master fee 1 write in the queue
				s_master_queue(v_master_queue_index) <= master_wr_subunit_1;
				s_master_wr_subunit_1_queued         <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- check if master avs 0 requested a write and is not queued
			if ((avalon_0_mm_wr_rmap_i.write = '1') and (s_master_wr_avs_0_queued = '0')) then
				-- master avs 0 requested a write and is not queued
				-- put master avs 0 write in the queue
				s_master_queue(v_master_queue_index) <= master_wr_avs_0;
				s_master_wr_avs_0_queued             <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- check if master fee 0 requested a read and is not queued
			if ((subunit_0_rd_rmap_i.read = '1') and (s_master_rd_subunit_0_queued = '0')) then
				-- master fee 0 requested a read and is not queued
				-- put master fee read 0 in the queue
				s_master_queue(v_master_queue_index) <= master_rd_subunit_0;
				s_master_rd_subunit_0_queued         <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- check if master fee 1 requested a read and is not queued
			if ((subunit_1_rd_rmap_i.read = '1') and (s_master_rd_subunit_1_queued = '0')) then
				-- master fee 1 requested a read and is not queued
				-- put master fee read 1 in the queue
				s_master_queue(v_master_queue_index) <= master_rd_subunit_1;
				s_master_rd_subunit_1_queued         <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- check if master avs 0 requested a read and is not queued
			if ((avalon_0_mm_rd_rmap_i.read = '1') and (s_master_rd_avs_0_queued = '0')) then
				-- master avs 0 requested a read and is not queued
				-- put master avs read 0 in the queue
				s_master_queue(v_master_queue_index) <= master_rd_avs_0;
				s_master_rd_avs_0_queued             <= '1';
				-- update master queue index
				if (v_master_queue_index < t_master_queue_index'high) then
					v_master_queue_index := v_master_queue_index + 1;
				end if;
			end if;

			-- master queue management
			-- case to handle the master queue
			case (s_master_queue(0)) is

				when master_none =>
					-- no master waiting at the queue
					s_selected_master <= master_none;

				when master_wr_subunit_0 =>
					-- master fee 0 write at top of the queue
					s_selected_master <= master_wr_subunit_0;
					-- check if the master is finished
					if (subunit_0_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_wr_subunit_0_queued              <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

				when master_wr_subunit_1 =>
					-- master fee 1 write at top of the queue
					s_selected_master <= master_wr_subunit_1;
					-- check if the master is finished
					if (subunit_1_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_wr_subunit_1_queued              <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

				when master_wr_avs_0 =>
					-- master avs 0 write at top of the queue
					s_selected_master <= master_wr_avs_0;
					-- check if the master is finished
					if (avalon_0_mm_wr_rmap_i.write = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_wr_avs_0_queued                  <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

				when master_rd_subunit_0 =>
					-- master fee 0 read at top of the queue
					s_selected_master <= master_rd_subunit_0;
					-- check if the master is finished
					if (subunit_0_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_rd_subunit_0_queued              <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

				when master_rd_subunit_1 =>
					-- master fee 1 read at top of the queue
					s_selected_master <= master_rd_subunit_1;
					-- check if the master is finished
					if (subunit_1_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_rd_subunit_1_queued              <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

				when master_rd_avs_0 =>
					-- master avs 0 read at top of the queue
					s_selected_master <= master_rd_avs_0;
					-- check if the master is finished
					if (avalon_0_mm_rd_rmap_i.read = '0') then
						-- master is finished
						-- set master selection to none
						s_selected_master                         <= master_none;
						-- remove master from the queue
						for index in 0 to (t_master_queue_index'high - 1) loop
							s_master_queue(index) <= s_master_queue(index + 1);
						end loop;
						s_master_queue(t_master_queue_index'high) <= master_none;
						s_master_rd_avs_0_queued                  <= '0';
						-- update master queue index
						if (v_master_queue_index > t_master_queue_index'low) then
							v_master_queue_index := v_master_queue_index - 1;
						end if;
					end if;

			end case;

		end if;
	end process p_srme_rmap_mem_area_subunit_arbiter;

	-- Signals assignments --

	-- Waitrequest
	s_subunit_rmap_waitrequest   <= (subunit_wr_rmap_i.waitrequest) and (subunit_rd_rmap_i.waitrequest);
	s_avalon_mm_rmap_waitrequest <= (avalon_mm_wr_rmap_i.waitrequest) and (avalon_mm_rd_rmap_i.waitrequest);
	s_rmap_waitrequest           <= (s_subunit_rmap_waitrequest) and (s_avalon_mm_rmap_waitrequest);

	-- Masters Write inputs
	subunit_wr_rmap_o   <= (c_SRME_SUBUNIT_RMAP_WRITE_IN_RST) when (rst_i = '1')
	                       else (subunit_0_wr_rmap_i) when (s_selected_master = master_wr_subunit_0)
	                       else (subunit_1_wr_rmap_i) when (s_selected_master = master_wr_subunit_1)
	                       else (c_SRME_SUBUNIT_RMAP_WRITE_IN_RST);
	avalon_mm_wr_rmap_o <= (c_SRME_AVALON_MM_RMAP_SUBUNIT_WRITE_IN_RST) when (rst_i = '1')
	                       else (avalon_0_mm_wr_rmap_i) when (s_selected_master = master_wr_avs_0)
	                       else (c_SRME_AVALON_MM_RMAP_SUBUNIT_WRITE_IN_RST);

	-- Masters Write outputs
	subunit_0_wr_rmap_o   <= (c_SRME_SUBUNIT_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (subunit_wr_rmap_i) when (s_selected_master = master_wr_subunit_0)
	                         else (c_SRME_SUBUNIT_RMAP_WRITE_OUT_RST);
	subunit_1_wr_rmap_o   <= (c_SRME_SUBUNIT_RMAP_WRITE_OUT_RST) when (rst_i = '1')
	                         else (subunit_wr_rmap_i) when (s_selected_master = master_wr_subunit_1)
	                         else (c_SRME_SUBUNIT_RMAP_WRITE_OUT_RST);
	avalon_0_mm_wr_rmap_o <= (c_SRME_AVALON_MM_RMAP_SUBUNIT_WRITE_OUT_RST) when (rst_i = '1')
	                         else (avalon_mm_wr_rmap_i) when (s_selected_master = master_wr_avs_0)
	                         else (c_SRME_AVALON_MM_RMAP_SUBUNIT_WRITE_OUT_RST);

	-- Masters Read inputs
	subunit_rd_rmap_o   <= (c_SRME_SUBUNIT_RMAP_READ_IN_RST) when (rst_i = '1')
	                       else (subunit_0_rd_rmap_i) when (s_selected_master = master_rd_subunit_0)
	                       else (subunit_1_rd_rmap_i) when (s_selected_master = master_rd_subunit_1)
	                       else (c_SRME_SUBUNIT_RMAP_READ_IN_RST);
	avalon_mm_rd_rmap_o <= (c_SRME_AVALON_MM_RMAP_SUBUNIT_READ_IN_RST) when (rst_i = '1')
	                       else (avalon_0_mm_rd_rmap_i) when (s_selected_master = master_rd_avs_0)
	                       else (c_SRME_AVALON_MM_RMAP_SUBUNIT_READ_IN_RST);

	-- Masters Read outputs
	subunit_0_rd_rmap_o   <= (c_SRME_SUBUNIT_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (subunit_rd_rmap_i) when (s_selected_master = master_rd_subunit_0)
	                         else (c_SRME_SUBUNIT_RMAP_READ_OUT_RST);
	subunit_1_rd_rmap_o   <= (c_SRME_SUBUNIT_RMAP_READ_OUT_RST) when (rst_i = '1')
	                         else (subunit_rd_rmap_i) when (s_selected_master = master_rd_subunit_1)
	                         else (c_SRME_SUBUNIT_RMAP_READ_OUT_RST);
	avalon_0_mm_rd_rmap_o <= (c_SRME_AVALON_MM_RMAP_SUBUNIT_READ_OUT_RST) when (rst_i = '1')
	                         else (avalon_mm_rd_rmap_i) when (s_selected_master = master_rd_avs_0)
	                         else (c_SRME_AVALON_MM_RMAP_SUBUNIT_READ_OUT_RST);

end architecture RTL;
