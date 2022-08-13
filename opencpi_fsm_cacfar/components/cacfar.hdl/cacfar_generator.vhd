-- THIS FILE WAS ORIGINALLY GENERATED ON Mon Apr  4 09:46:05 2022 BST
-- BASED ON THE FILE: CACFAR.xml
-- YOU *ARE* EXPECTED TO EDIT IT
-- This file initially contains the architecture skeleton for worker: CACFAR

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library ocpi;
use ocpi.types.all; -- remove this to avoid all ocpi name collisions

-- Entity CACFAR declaration
--
entity CACFAR_G is
    generic(
      C_G_FDW                 : natural := 512; -- the natural type is the same as positive type except that it can also be assigned to 0, 1023?
      --C_G_SIDE_DATA_WINDOW : integer := 1018;
      C_G_DATA_WIDTH          : natural := 16; -- 16 more than needed
      C_G_GUARD_CELLS         : natural := 4;
      C_G_TRAINING_CELLS      : natural := 12;
      -- Data Window = 1024
      -- Guard cells = 4
      -- CFAR window = 12
      C_G_ALPHA               : natural := 5
      -- Data width should be minimum, have doubled this arbritrarily
    );
    port(
      clk          : in std_logic;
      reset        : in std_logic;
      enable       : in std_logic;
      input_valid  : in std_logic;
      input_data   : in std_logic_vector(C_G_DATA_WIDTH -1 downto 0);
      input_eof    : in std_logic;
      output_data  : out std_logic_vector(C_G_DATA_WIDTH -1 downto 0);
      output_valid : out std_logic;
      output_eof   : out std_logic
    );
end entity CACFAR_G;
--

architecture rtl of CACFAR_G is

  constant C_ADDRESS_WIDTH : positive := positive(ceil(log2(real(C_G_FDW))));
  -- This is the number of memory locations, can also think of this as size of data(bits)

  signal output0_address   : std_logic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  signal output0_valid_in  : std_logic;
  signal output0_data      : std_logic_vector(C_G_DATA_WIDTH - 1 downto 0);
  signal output0_valid_out : std_logic;
  signal output1_address   : std_logic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  signal output1_valid_in  : std_logic;
  signal output1_data      : std_logic_vector(C_G_DATA_WIDTH - 1 downto 0);
  signal output1_valid_out : std_logic;

  -- Finite State Machine (FSM) signals
  type state_type is (
    IDLE_e,
    READ_CUT_e,
    CFAR_ACC_e,
    CFAR_AVG_e,
    CFAR_THRESHOLD_e,
    CFAR_DECISION_e
  );
  signal state: state_type;

  --signal write_address : integer range 0 to 2 * C_ADDRESS_WIDTH - 1;
  signal write_address : unsigned(C_ADDRESS_WIDTH - 1 downto 0);
  signal left_data     : std_logic_vector(C_G_DATA_WIDTH - 1 downto 0);       -- signal to read data section 1
  signal left_address  : unsigned(C_ADDRESS_WIDTH - 1 downto 0);
  signal left_valid    : std_logic;
  signal right_data    : std_logic_vector(C_G_DATA_WIDTH - 1 downto 0);       -- signal to read data section 2
  signal right_address : unsigned(C_ADDRESS_WIDTH - 1 downto 0);
  signal right_valid   : std_logic;
  --

    -- General Comments
    --
    -- There is no division operation in HW
    --
    -- A multiplication by 1/x is synthesize instead.
    --
    -- A set of values 1/x, where x is from 1 to 128 is loaded into LUTs
    --
    -- Values are quantised as signed [10,9] [1 int bit, 9 frac bits]
    --
    -- For Example, if the address pointer to the LUT is 8, the result will be 1/8 = 0.125

    -- Internal constants
    --
    constant C_ACC_GROWTH          : natural := C_G_TRAINING_CELLS/2;
    constant C_ALPHA_WIDTH         : natural := natural(ceil(log2(real(C_G_ALPHA + 1))));
    constant C_WINDOW_WIDTH        : natural := natural(ceil(log2(real(C_G_GUARD_CELLS/2 + C_G_TRAINING_CELLS/2 + 1))));
    constant C_GUARD_CELLS_HALF    : natural := C_G_GUARD_CELLS / 2;
    constant C_TRAINING_CELLS_HALF : natural := C_G_TRAINING_CELLS / 2;
    constant C_TOTAL_SIDE_SIZE     : natural := C_GUARD_CELLS_HALF + C_TRAINING_CELLS_HALF;
    --
    -- Internal signals
    --
    signal window_ptr      : unsigned(C_WINDOW_WIDTH - 1 downto 0);
    signal cut_address     : unsigned(C_ADDRESS_WIDTH - 1 downto 0);
    signal cut_value       : signed(C_G_DATA_WIDTH - 1 downto 0);                            -- latch the value of the current cut
    signal left_acc        : signed(C_G_DATA_WIDTH + C_ACC_GROWTH - 1 downto 0);             -- acc being for accumulator, the accumulator for the "left side"
    signal right_acc       : signed(C_G_DATA_WIDTH + C_ACC_GROWTH - 1 downto 0);                 -- accumulator for the "right side"
    signal total_acc       : signed(C_G_DATA_WIDTH + C_ACC_GROWTH + 1 -1 downto 0);                 -- sum of the window accumulators
    signal avg             : signed(C_G_DATA_WIDTH + C_ACC_GROWTH + 1 -1 downto 0);            -- average signal
    signal threshold       : signed(C_G_DATA_WIDTH + C_ACC_GROWTH + C_ALPHA_WIDTH + 1 - 1 downto 0); -- threshold signal val
    --

begin

  output0_ram_proc : process(state, write_address, input_valid, output0_valid_out, cut_address, left_address, left_valid)
  begin
    if state = IDLE_e and write_address = C_G_FDW - 1 and its(input_valid) then
      output0_address  <= std_logic_vector(cut_address);
      output0_valid_in <= not output0_valid_out;
    elsif state = CFAR_DECISION_e and cut_address /= C_G_FDW - 1 then
      output0_address  <= std_logic_vector(cut_address + 1);
      output0_valid_in <= not output0_valid_out;
    else
      output0_address  <= std_logic_vector(left_address);
      output0_valid_in <= left_valid;
    end if;
  end process output0_ram_proc;

  output1_address <= std_logic_vector(right_address);
  output1_valid_in <= right_valid;

  ram_inst : entity work.single_write_dual_read_ram
  generic map (
    C_G_DATA_WIDTH => C_G_DATA_WIDTH,
    C_G_ADDR_WIDTH => C_ADDRESS_WIDTH
  )
  port map (
    clk    => clk,
    reset  => reset,
    enable => enable,

    input_data    => input_data,
    input_address => std_logic_vector(write_address),
    input_valid   => input_valid,

    output0_address   => output0_address,
    output0_valid_in  => output0_valid_in,

    output0_data      => output0_data,
    output0_valid_out => output0_valid_out,

    output1_address   => output1_address,
    output1_valid_in  => output1_valid_in,

    output1_data      => output1_data,
    output1_valid_out => output1_valid_out
  );

  left_data  <= output0_data;
  right_data <= output1_data;
  --TODO comment code

  -- Finite State Machine process (FSM)
  fsm_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset ='1' then -- ACTIVE high
        state <= IDLE_e;
      elsif enable = '1' then
        case state is
          when IDLE_e =>
            if input_valid = '1' then
              if write_address = C_G_FDW - 1 then
                state <= READ_CUT_e;
              end if;
            end if;
          when READ_CUT_e =>
            if its(output0_valid_in and output1_valid_in) then
              state <= CFAR_ACC_e;
            end if;
          when CFAR_ACC_e =>
            if window_ptr = C_TOTAL_SIDE_SIZE + 1 and
               its(output0_valid_out and output1_valid_out)
            then
              state <= CFAR_AVG_e;
            end if;
          when CFAR_AVG_e =>
            state <= CFAR_THRESHOLD_e;
          when CFAR_THRESHOLD_e =>
            state <= CFAR_DECISION_e;
          when CFAR_DECISION_e =>
            if cut_address = C_G_FDW - 1 then
              state <= IDLE_e;
            else
              state <= READ_CUT_e;
            end if;
        end case;
      end if;
    end if;
  end process;

  write_address_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then -- ACTIVE high
        write_address <= (others => '0');
      elsif enable = '1' then
        case state is
          when IDLE_e =>
            if input_valid = '1' then
              write_address <= write_address + 1;
            end if;
          when READ_CUT_e =>
          when CFAR_ACC_e =>
          when CFAR_AVG_e =>
          when CFAR_THRESHOLD_e =>
          when CFAR_DECISION_e =>
        end case;
      end if;
    end if;
  end process;

  left_right_address_proc : process(state, cut_address, output0_valid_out, output1_valid_out, window_ptr)
  begin
    left_address  <= (others => '0');
    left_valid    <= '0';
    right_address <= (others => '0');
    right_valid   <= '0';
    case state is
      when IDLE_e =>
      when READ_CUT_e =>
        -- Set training addresses
        left_address  <= cut_address - C_GUARD_CELLS_HALF - 1;
        left_valid    <= '1';
        right_address <= cut_address + C_GUARD_CELLS_HALF + 1;
        right_valid   <= '1';
      when CFAR_ACC_e =>
        -- Update training addresses
        left_address  <= cut_address - window_ptr;
        left_valid    <= '1';
        right_address <= cut_address + window_ptr;
        right_valid   <= '1';
      when CFAR_AVG_e =>
      when CFAR_THRESHOLD_e =>
      when CFAR_DECISION_e =>
    end case;
  end process;

  cut_address_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then -- ACTIVE high
        cut_address <= (others => '0');
      elsif enable = '1' then
        case state is
          when IDLE_e =>
          when READ_CUT_e =>
          when CFAR_ACC_e =>
          when CFAR_AVG_e =>
          when CFAR_THRESHOLD_e =>
          when CFAR_DECISION_e =>
            cut_address <= cut_address + 1;
        end case;
      end if;
    end if;
  end process;

  --TODO better name
  fsm_read_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then -- ACTIVE high
        window_ptr    <= to_unsigned(C_GUARD_CELLS_HALF + 1, window_ptr'length);
        cut_value     <= (others => '0');
        left_acc      <= (others => '0');
        right_acc     <= (others => '0');
        total_acc     <= (others => '0');
        avg           <= (others => '0');
        threshold     <= (others => '0');

      elsif enable = '1' then
        case state is
          when IDLE_e =>

          when READ_CUT_e =>
            if its(output0_valid_in and output1_valid_in) then
              cut_value  <= signed(output0_data);
              window_ptr <= window_ptr + 1;
            end if;

          when CFAR_ACC_e => -- Update the window pointer and accumulate data
            if its(output0_valid_out and output1_valid_out) then
              if cut_address < C_TOTAL_SIDE_SIZE or
                 cut_address > (C_G_FDW - 1) - C_TOTAL_SIDE_SIZE then
                window_ptr <= window_ptr + 1;
                if window_ptr = C_TOTAL_SIDE_SIZE + 1 then
                  window_ptr <= to_unsigned(C_GUARD_CELLS_HALF + 1, window_ptr'length);
                end if;
              else --for the cases where the cut will not spill over
                if window_ptr = C_GUARD_CELLS_HALF + 1 + 1 then
                  window_ptr <= window_ptr + 1;
                  left_acc   <= resize(signed(left_data), left_acc'length);
                  right_acc  <= resize(signed(right_data), right_acc'length);
                elsif window_ptr < C_TOTAL_SIDE_SIZE + 1 then
                  window_ptr <= window_ptr + 1;
                  left_acc   <= left_acc + signed(left_data);
                  right_acc  <= right_acc + signed(right_data);
                else
                  -- Reset back to starting position
                  window_ptr <= to_unsigned(C_GUARD_CELLS_HALF + 1, window_ptr'length);
                  total_acc  <= resize(left_acc + signed(left_data), total_acc'length) +
                                resize(right_acc + signed(right_data), total_acc'length);
                end if;
              end if;
            end if;

          when CFAR_AVG_e =>
            avg <= total_acc / C_G_TRAINING_CELLS;
            total_acc <= (others => '0');

          when CFAR_THRESHOLD_e =>
            threshold <= resize(to_signed(C_G_ALPHA, threshold'length) * resize(avg, threshold'length),threshold'length);
            avg <= (others => '0');

          when CFAR_DECISION_e =>

        end case;
      end if;
    end if;
  end process;

  output_proc : process(state, cut_value, threshold)
  begin
    output_data  <= (others => '0');
    output_valid <= '0';
    case state is
      when IDLE_e =>
      when READ_CUT_e =>
      when CFAR_ACC_e =>
      when CFAR_AVG_e =>
      when CFAR_THRESHOLD_e =>
      when CFAR_DECISION_e =>
        if cut_address < C_TOTAL_SIDE_SIZE or cut_address > C_G_FDW - 1 - C_TOTAL_SIDE_SIZE then
          output_data <= (others => '0');
        elsif resize(cut_value, threshold'length) >= threshold then
          output_data <= std_logic_vector(cut_value);
        end if;
        output_valid <= '1';
    end case;
  end process;

  output_eof <= input_eof and to_bool(state = IDLE_e);

end rtl;
