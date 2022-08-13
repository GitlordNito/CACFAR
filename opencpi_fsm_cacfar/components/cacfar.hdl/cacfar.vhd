library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library ocpi;
use ocpi.types.all; -- remove this to avoid all ocpi name collisions
--


architecture rtl of worker is

  constant C_FDW            : natural := to_integer(SAMPLE_SIZE);
  constant C_GUARD_CELLS    : natural := to_integer(num_guard_cells);
  constant C_TRAINING_CELLS : natural := to_integer(num_train_cells);
  constant C_ALPHA          : natural := to_integer(threshold_factor);

  -- Signals
  signal do_work : bool_t;

  signal output_data  : std_logic_vector(input_in.data'length / 2 - 1 downto 0);
  signal output_valid : std_logic;

  signal output_out_sig : worker_output_out_t; --used for portmap assignment bug

  signal counter : unsigned(natural(ceil(log2(real(C_FDW)))) - 1 downto 0);

begin

  do_work <= output_in.ready and input_in.valid and ctl_in.is_operating;

  input_out.take <= do_work;

  -- Invoke the model
  inst1 : entity work.CACFAR_G
  generic map (
    C_G_FDW            => C_FDW,
    C_G_DATA_WIDTH     => input_in.data'length / 2,
    C_G_GUARD_CELLS    => C_GUARD_CELLS,
    C_G_TRAINING_CELLS => C_TRAINING_CELLS,
    C_G_ALPHA          => C_ALPHA
  )
  port map (
    clk         => ctl_in.clk,
    reset       => ctl_in.reset,
    enable      => ctl_in.is_operating,

    input_data  => input_in.data(input_in.data'length / 2 - 1 downto 0),
    input_valid => input_in.valid,
    input_eof   => input_in.eof,

    output_data  => output_data,
    output_valid => output_valid,
    output_eof   => output_out_sig.eof
  );

  length_count_proc : process(ctl_in.clk)
  begin
    if rising_edge(ctl_in.clk) then
      if ctl_in.reset = '1' then
        counter <= (others =>'0');
      elsif ctl_in.is_operating = '1' then
        if output_out_sig.valid = '1' then
          counter <= counter + 1;
        end if;
      end if;
    end if;
  end process length_count_proc;

  output_out_sig.give        <= output_valid;
  output_out_sig.data        <= std_logic_vector(resize(signed(output_data),
                                                        output_out_sig.data'length));
  output_out_sig.byte_enable <= (others => '1');
  output_out_sig.som         <= to_bool(counter = (counter'range => '0'));
  output_out_sig.eom         <= to_bool(counter = (counter'range => '1'));
  output_out_sig.valid       <= output_valid;

  output_out <= output_out_sig;

end rtl;
