library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avma_avm_arbiter_pkg.all;

entity avma_avm_arbiter_ent is
    port(
        clk_i                : in  std_logic;
        rst_i                : in  std_logic;
        avalon_mm_master_0_i : in  t_avma_avm_arbiter_in;
        avalon_mm_master_1_i : in  t_avma_avm_arbiter_in;
        avalon_mm_master_2_i : in  t_avma_avm_arbiter_in;
        avalon_mm_master_3_i : in  t_avma_avm_arbiter_in;
        avalon_mm_master_4_i : in  t_avma_avm_arbiter_in;
        avalon_mm_master_5_i : in  t_avma_avm_arbiter_in;
        avalon_mm_master_6_i : in  t_avma_avm_arbiter_in;
        avalon_mm_master_7_i : in  t_avma_avm_arbiter_in;
        avalon_mm_slave_i    : in  t_avma_avm_arbiter_out;
        avalon_mm_master_0_o : out t_avma_avm_arbiter_out;
        avalon_mm_master_1_o : out t_avma_avm_arbiter_out;
        avalon_mm_master_2_o : out t_avma_avm_arbiter_out;
        avalon_mm_master_3_o : out t_avma_avm_arbiter_out;
        avalon_mm_master_4_o : out t_avma_avm_arbiter_out;
        avalon_mm_master_5_o : out t_avma_avm_arbiter_out;
        avalon_mm_master_6_o : out t_avma_avm_arbiter_out;
        avalon_mm_master_7_o : out t_avma_avm_arbiter_out;
        avalon_mm_slave_o    : out t_avma_avm_arbiter_in
    );
end entity avma_avm_arbiter_ent;

architecture RTL of avma_avm_arbiter_ent is

    type t_master_list is (
        master_none,
        master_avm_0,
        master_avm_1,
        master_avm_2,
        master_avm_3,
        master_avm_4,
        master_avm_5,
        master_avm_6,
        master_avm_7
    );
    signal s_selected_master : t_master_list;

    subtype t_master_queue_index is natural range 0 to 8;
    type t_master_queue is array (0 to t_master_queue_index'high) of t_master_list;
    signal s_master_queue : t_master_queue;

    signal s_master_avm_0_queued : std_logic;
    signal s_master_avm_1_queued : std_logic;
    signal s_master_avm_2_queued : std_logic;
    signal s_master_avm_3_queued : std_logic;
    signal s_master_avm_4_queued : std_logic;
    signal s_master_avm_5_queued : std_logic;
    signal s_master_avm_6_queued : std_logic;
    signal s_master_avm_7_queued : std_logic;

    --    signal s_master_avm_0_wr_flag : std_logic;
    --    signal s_master_avm_1_wr_flag : std_logic;
    --    signal s_master_avm_2_wr_flag : std_logic;
    --    signal s_master_avm_3_wr_flag : std_logic;
    --    signal s_master_avm_4_wr_flag : std_logic;
    --    signal s_master_avm_5_wr_flag : std_logic;
    --    signal s_master_avm_6_wr_flag : std_logic;
    --    signal s_master_avm_7_wr_flag : std_logic;

begin

    p_avma_avm_arbiter : process(clk_i, rst_i) is
        variable v_master_queue_insert_index : t_master_queue_index := 0;
        variable v_master_queue_remove_index : t_master_queue_index := 0;

    begin
        if (rst_i = '1') then
            s_selected_master           <= master_none;
            s_master_queue              <= (others => master_none);
            s_master_avm_0_queued       <= '0';
            s_master_avm_1_queued       <= '0';
            s_master_avm_2_queued       <= '0';
            s_master_avm_3_queued       <= '0';
            s_master_avm_4_queued       <= '0';
            s_master_avm_5_queued       <= '0';
            s_master_avm_6_queued       <= '0';
            s_master_avm_7_queued       <= '0';
            --            s_master_avm_0_wr_flag      <= '0';
            --            s_master_avm_1_wr_flag      <= '0';
            --            s_master_avm_2_wr_flag      <= '0';
            --            s_master_avm_3_wr_flag      <= '0';
            --            s_master_avm_4_wr_flag      <= '0';
            --            s_master_avm_5_wr_flag      <= '0';
            --            s_master_avm_6_wr_flag      <= '0';
            --            s_master_avm_7_wr_flag      <= '0';
            v_master_queue_insert_index := 0;
            v_master_queue_remove_index := 0;
        elsif (rising_edge(clk_i)) then

            -- check if master avm 0 requested a write or a read and is not queued
            --            if (((avalon_mm_master_0_i.write = '1') or (avalon_mm_master_0_i.read = '1')) and (s_master_avm_0_queued = '0')) then
            if ((avalon_mm_master_0_i.read = '1') and (s_master_avm_0_queued = '0')) then
                -- master avm 0 requested a write or a read and is not queued
                -- set the master write flag
                --                s_master_avm_0_wr_flag                      <= avalon_mm_master_0_i.write;
                -- put master avm 0 in the queue
                s_master_queue(v_master_queue_insert_index) <= master_avm_0;
                s_master_avm_0_queued                       <= '1';
                -- update master queue index
                if (v_master_queue_insert_index < t_master_queue_index'high) then
                    v_master_queue_insert_index := v_master_queue_insert_index + 1;
                else
                    v_master_queue_insert_index := 0;
                end if;
            end if;

            -- check if master avm 1 requested a write or a read and is not queued
            --            if (((avalon_mm_master_1_i.write = '1') or (avalon_mm_master_1_i.read = '1')) and (s_master_avm_1_queued = '0')) then
            if ((avalon_mm_master_1_i.read = '1') and (s_master_avm_1_queued = '0')) then
                -- master avm 1 requested a write or a read and is not queued
                -- set the master write flag
                --                s_master_avm_1_wr_flag                      <= avalon_mm_master_1_i.write;
                -- put master avm 1 in the queue
                s_master_queue(v_master_queue_insert_index) <= master_avm_1;
                s_master_avm_1_queued                       <= '1';
                -- update master queue index
                if (v_master_queue_insert_index < t_master_queue_index'high) then
                    v_master_queue_insert_index := v_master_queue_insert_index + 1;
                else
                    v_master_queue_insert_index := 0;
                end if;
            end if;

            -- check if master avm 2 requested a write or a read and is not queued
            --            if (((avalon_mm_master_2_i.write = '1') or (avalon_mm_master_2_i.read = '1')) and (s_master_avm_2_queued = '0')) then
            if ((avalon_mm_master_2_i.read = '1') and (s_master_avm_2_queued = '0')) then
                -- master avm 2 requested a write or a read and is not queued
                -- set the master write flag
                --                s_master_avm_2_wr_flag                      <= avalon_mm_master_2_i.write;
                -- put master avm 2 in the queue
                s_master_queue(v_master_queue_insert_index) <= master_avm_2;
                s_master_avm_2_queued                       <= '1';
                -- update master queue index
                if (v_master_queue_insert_index < t_master_queue_index'high) then
                    v_master_queue_insert_index := v_master_queue_insert_index + 1;
                else
                    v_master_queue_insert_index := 0;
                end if;
            end if;

            -- check if master avm 3 requested a write or a read and is not queued
            --            if (((avalon_mm_master_3_i.write = '1') or (avalon_mm_master_3_i.read = '1')) and (s_master_avm_3_queued = '0')) then
            if ((avalon_mm_master_3_i.read = '1') and (s_master_avm_3_queued = '0')) then
                -- master avm 3 requested a write or a read and is not queued
                -- set the master write flag
                --                s_master_avm_3_wr_flag                      <= avalon_mm_master_3_i.write;
                -- put master avm 3 in the queue
                s_master_queue(v_master_queue_insert_index) <= master_avm_3;
                s_master_avm_3_queued                       <= '1';
                -- update master queue index
                if (v_master_queue_insert_index < t_master_queue_index'high) then
                    v_master_queue_insert_index := v_master_queue_insert_index + 1;
                else
                    v_master_queue_insert_index := 0;
                end if;
            end if;

            -- check if master avm 4 requested a write or a read and is not queued
            --            if (((avalon_mm_master_4_i.write = '1') or (avalon_mm_master_4_i.read = '1')) and (s_master_avm_4_queued = '0')) then
            if ((avalon_mm_master_4_i.read = '1') and (s_master_avm_4_queued = '0')) then
                -- master avm 4 requested a write or a read and is not queued
                -- set the master write flag
                --                s_master_avm_4_wr_flag                      <= avalon_mm_master_4_i.write;
                -- put master avm 4 in the queue
                s_master_queue(v_master_queue_insert_index) <= master_avm_4;
                s_master_avm_4_queued                       <= '1';
                -- update master queue index
                if (v_master_queue_insert_index < t_master_queue_index'high) then
                    v_master_queue_insert_index := v_master_queue_insert_index + 1;
                else
                    v_master_queue_insert_index := 0;
                end if;
            end if;

            -- check if master avm 5 requested a write or a read and is not queued
            --            if (((avalon_mm_master_5_i.write = '1') or (avalon_mm_master_5_i.read = '1')) and (s_master_avm_5_queued = '0')) then
            if ((avalon_mm_master_5_i.read = '1') and (s_master_avm_5_queued = '0')) then
                -- master avm 5 requested a write or a read and is not queued
                -- set the master write flag
                --                s_master_avm_5_wr_flag                      <= avalon_mm_master_5_i.write;
                -- put master avm 5 in the queue
                s_master_queue(v_master_queue_insert_index) <= master_avm_5;
                s_master_avm_5_queued                       <= '1';
                -- update master queue index
                if (v_master_queue_insert_index < t_master_queue_index'high) then
                    v_master_queue_insert_index := v_master_queue_insert_index + 1;
                else
                    v_master_queue_insert_index := 0;
                end if;
            end if;

            -- check if master avm 6 requested a write or a read and is not queued
            --            if (((avalon_mm_master_6_i.write = '1') or (avalon_mm_master_6_i.read = '1')) and (s_master_avm_6_queued = '0')) then
            if ((avalon_mm_master_6_i.read = '1') and (s_master_avm_6_queued = '0')) then
                -- master avm 6 requested a write or a read and is not queued
                -- set the master write flag
                --                s_master_avm_6_wr_flag                      <= avalon_mm_master_6_i.write;
                -- put master avm 6 in the queue
                s_master_queue(v_master_queue_insert_index) <= master_avm_6;
                s_master_avm_6_queued                       <= '1';
                -- update master queue index
                if (v_master_queue_insert_index < t_master_queue_index'high) then
                    v_master_queue_insert_index := v_master_queue_insert_index + 1;
                else
                    v_master_queue_insert_index := 0;
                end if;
            end if;

            -- check if master avm 7 requested a write or a read and is not queued
            --            if (((avalon_mm_master_7_i.write = '1') or (avalon_mm_master_7_i.read = '1')) and (s_master_avm_7_queued = '0')) then
            if ((avalon_mm_master_7_i.read = '1') and (s_master_avm_7_queued = '0')) then
                -- master avm 7 requested a write or a read and is not queued
                -- set the master write flag
                --                s_master_avm_7_wr_flag                      <= avalon_mm_master_7_i.write;
                -- put master avm 7 in the queue
                s_master_queue(v_master_queue_insert_index) <= master_avm_7;
                s_master_avm_7_queued                       <= '1';
                -- update master queue index
                if (v_master_queue_insert_index < t_master_queue_index'high) then
                    v_master_queue_insert_index := v_master_queue_insert_index + 1;
                else
                    v_master_queue_insert_index := 0;
                end if;
            end if;

            -- master queue management
            -- case to handle the master queue
            case (s_master_queue(v_master_queue_remove_index)) is

                when master_none =>
                    -- no master waiting at the queue
                    s_selected_master <= master_none;

                when master_avm_0 =>
                    -- master avm 0 write at top of the queue
                    s_selected_master <= master_avm_0;
                    -- check if the master is finished
                    --                    if (((avalon_mm_master_0_i.write = '0') and (s_master_avm_0_wr_flag = '1')) or ((avalon_mm_master_0_i.read = '0') and (s_master_avm_0_wr_flag = '0'))) then
                    if (avalon_mm_master_0_i.read = '0') then
                        -- master is finished
                        -- set master selection to none
                        s_selected_master                           <= master_none;
                        -- remove master from the queue
                        s_master_queue(v_master_queue_remove_index) <= master_none;
                        s_master_avm_0_queued                       <= '0';
                        -- update master queue index
                        if (v_master_queue_remove_index < t_master_queue_index'high) then
                            v_master_queue_remove_index := v_master_queue_remove_index + 1;
                        else
                            v_master_queue_remove_index := 0;
                        end if;
                    end if;

                when master_avm_1 =>
                    -- master avm 1 write at top of the queue
                    s_selected_master <= master_avm_1;
                    -- check if the master is finished
                    --                    if (((avalon_mm_master_1_i.write = '0') and (s_master_avm_1_wr_flag = '1')) or ((avalon_mm_master_1_i.read = '0') and (s_master_avm_1_wr_flag = '0'))) then
                    if (avalon_mm_master_1_i.read = '0') then
                        -- master is finished
                        -- set master selection to none
                        s_selected_master                           <= master_none;
                        -- remove master from the queue
                        s_master_queue(v_master_queue_remove_index) <= master_none;
                        s_master_avm_1_queued                       <= '0';
                        -- update master queue index
                        if (v_master_queue_remove_index < t_master_queue_index'high) then
                            v_master_queue_remove_index := v_master_queue_remove_index + 1;
                        else
                            v_master_queue_remove_index := 0;
                        end if;
                    end if;

                when master_avm_2 =>
                    -- master avm 2 write at top of the queue
                    s_selected_master <= master_avm_2;
                    -- check if the master is finished
                    --                    if (((avalon_mm_master_2_i.write = '0') and (s_master_avm_2_wr_flag = '1')) or ((avalon_mm_master_2_i.read = '0') and (s_master_avm_2_wr_flag = '0'))) then
                    if (avalon_mm_master_2_i.read = '0') then
                        -- master is finished
                        -- set master selection to none
                        s_selected_master                           <= master_none;
                        -- remove master from the queue
                        s_master_queue(v_master_queue_remove_index) <= master_none;
                        s_master_avm_2_queued                       <= '0';
                        -- update master queue index
                        if (v_master_queue_remove_index < t_master_queue_index'high) then
                            v_master_queue_remove_index := v_master_queue_remove_index + 1;
                        else
                            v_master_queue_remove_index := 0;
                        end if;
                    end if;

                when master_avm_3 =>
                    -- master avm 3 write at top of the queue
                    s_selected_master <= master_avm_3;
                    -- check if the master is finished
                    --                    if (((avalon_mm_master_3_i.write = '0') and (s_master_avm_3_wr_flag = '1')) or ((avalon_mm_master_3_i.read = '0') and (s_master_avm_3_wr_flag = '0'))) then
                    if (avalon_mm_master_3_i.read = '0') then
                        -- master is finished
                        -- set master selection to none
                        s_selected_master                           <= master_none;
                        -- remove master from the queue
                        s_master_queue(v_master_queue_remove_index) <= master_none;
                        s_master_avm_3_queued                       <= '0';
                        -- update master queue index
                        if (v_master_queue_remove_index < t_master_queue_index'high) then
                            v_master_queue_remove_index := v_master_queue_remove_index + 1;
                        else
                            v_master_queue_remove_index := 0;
                        end if;
                    end if;

                when master_avm_4 =>
                    -- master avm 4 write at top of the queue
                    s_selected_master <= master_avm_4;
                    -- check if the master is finished
                    --                    if (((avalon_mm_master_4_i.write = '0') and (s_master_avm_4_wr_flag = '1')) or ((avalon_mm_master_4_i.read = '0') and (s_master_avm_4_wr_flag = '0'))) then
                    if (avalon_mm_master_4_i.read = '0') then
                        -- master is finished
                        -- set master selection to none
                        s_selected_master                           <= master_none;
                        -- remove master from the queue
                        s_master_queue(v_master_queue_remove_index) <= master_none;
                        s_master_avm_4_queued                       <= '0';
                        -- update master queue index
                        if (v_master_queue_remove_index < t_master_queue_index'high) then
                            v_master_queue_remove_index := v_master_queue_remove_index + 1;
                        else
                            v_master_queue_remove_index := 0;
                        end if;
                    end if;

                when master_avm_5 =>
                    -- master avm 5 write at top of the queue
                    s_selected_master <= master_avm_5;
                    -- check if the master is finished
                    --                    if (((avalon_mm_master_5_i.write = '0') and (s_master_avm_5_wr_flag = '1')) or ((avalon_mm_master_5_i.read = '0') and (s_master_avm_5_wr_flag = '0'))) then
                    if (avalon_mm_master_5_i.read = '0') then
                        -- master is finished
                        -- set master selection to none
                        s_selected_master                           <= master_none;
                        -- remove master from the queue
                        s_master_queue(v_master_queue_remove_index) <= master_none;
                        s_master_avm_5_queued                       <= '0';
                        -- update master queue index
                        if (v_master_queue_remove_index < t_master_queue_index'high) then
                            v_master_queue_remove_index := v_master_queue_remove_index + 1;
                        else
                            v_master_queue_remove_index := 0;
                        end if;
                    end if;

                when master_avm_6 =>
                    -- master avm 6 write at top of the queue
                    s_selected_master <= master_avm_6;
                    -- check if the master is finished
                    --                    if (((avalon_mm_master_6_i.write = '0') and (s_master_avm_6_wr_flag = '1')) or ((avalon_mm_master_6_i.read = '0') and (s_master_avm_6_wr_flag = '0'))) then
                    if (avalon_mm_master_6_i.read = '0') then
                        -- master is finished
                        -- set master selection to none
                        s_selected_master                           <= master_none;
                        -- remove master from the queue
                        s_master_queue(v_master_queue_remove_index) <= master_none;
                        s_master_avm_6_queued                       <= '0';
                        -- update master queue index
                        if (v_master_queue_remove_index < t_master_queue_index'high) then
                            v_master_queue_remove_index := v_master_queue_remove_index + 1;
                        else
                            v_master_queue_remove_index := 0;
                        end if;
                    end if;

                when master_avm_7 =>
                    -- master avm 7 write at top of the queue
                    s_selected_master <= master_avm_7;
                    -- check if the master is finished
                    --                    if (((avalon_mm_master_7_i.write = '0') and (s_master_avm_7_wr_flag = '1')) or ((avalon_mm_master_7_i.read = '0') and (s_master_avm_7_wr_flag = '0'))) then
                    if (avalon_mm_master_7_i.read = '0') then
                        -- master is finished
                        -- set master selection to none
                        s_selected_master                           <= master_none;
                        -- remove master from the queue
                        s_master_queue(v_master_queue_remove_index) <= master_none;
                        s_master_avm_7_queued                       <= '0';
                        -- update master queue index
                        if (v_master_queue_remove_index < t_master_queue_index'high) then
                            v_master_queue_remove_index := v_master_queue_remove_index + 1;
                        else
                            v_master_queue_remove_index := 0;
                        end if;
                    end if;

                when others =>
                    -- error case, should never reach this state
                    s_selected_master <= master_none;

            end case;

        end if;
    end process p_avma_avm_arbiter;

    -- Signals assignments --

    -- Slave output from Masters inputs
    avalon_mm_slave_o <= (c_AVMA_AVM_ARBITER_IN_RST) when (rst_i = '1') else
                         (avalon_mm_master_0_i) when (s_selected_master = master_avm_0) else
                         (avalon_mm_master_1_i) when (s_selected_master = master_avm_1) else
                         (avalon_mm_master_2_i) when (s_selected_master = master_avm_2) else
                         (avalon_mm_master_3_i) when (s_selected_master = master_avm_3) else
                         (avalon_mm_master_4_i) when (s_selected_master = master_avm_4) else
                         (avalon_mm_master_5_i) when (s_selected_master = master_avm_5) else
                         (avalon_mm_master_6_i) when (s_selected_master = master_avm_6) else
                         (avalon_mm_master_7_i) when (s_selected_master = master_avm_7) else
                         (c_AVMA_AVM_ARBITER_IN_RST);

    -- Masters outputs from Slave input
    avalon_mm_master_0_o <= (c_AVMA_AVM_ARBITER_OUT_RST) when (rst_i = '1') else
                            (avalon_mm_slave_i) when (s_selected_master = master_avm_0) else
                            (c_AVMA_AVM_ARBITER_OUT_RST);
    avalon_mm_master_1_o <= (c_AVMA_AVM_ARBITER_OUT_RST) when (rst_i = '1') else
                            (avalon_mm_slave_i) when (s_selected_master = master_avm_1) else
                            (c_AVMA_AVM_ARBITER_OUT_RST);
    avalon_mm_master_2_o <= (c_AVMA_AVM_ARBITER_OUT_RST) when (rst_i = '1') else
                            (avalon_mm_slave_i) when (s_selected_master = master_avm_2) else
                            (c_AVMA_AVM_ARBITER_OUT_RST);
    avalon_mm_master_3_o <= (c_AVMA_AVM_ARBITER_OUT_RST) when (rst_i = '1') else
                            (avalon_mm_slave_i) when (s_selected_master = master_avm_3) else
                            (c_AVMA_AVM_ARBITER_OUT_RST);
    avalon_mm_master_4_o <= (c_AVMA_AVM_ARBITER_OUT_RST) when (rst_i = '1') else
                            (avalon_mm_slave_i) when (s_selected_master = master_avm_4) else
                            (c_AVMA_AVM_ARBITER_OUT_RST);
    avalon_mm_master_5_o <= (c_AVMA_AVM_ARBITER_OUT_RST) when (rst_i = '1') else
                            (avalon_mm_slave_i) when (s_selected_master = master_avm_5) else
                            (c_AVMA_AVM_ARBITER_OUT_RST);
    avalon_mm_master_6_o <= (c_AVMA_AVM_ARBITER_OUT_RST) when (rst_i = '1') else
                            (avalon_mm_slave_i) when (s_selected_master = master_avm_6) else
                            (c_AVMA_AVM_ARBITER_OUT_RST);
    avalon_mm_master_7_o <= (c_AVMA_AVM_ARBITER_OUT_RST) when (rst_i = '1') else
                            (avalon_mm_slave_i) when (s_selected_master = master_avm_7) else
                            (c_AVMA_AVM_ARBITER_OUT_RST);

end architecture RTL;
