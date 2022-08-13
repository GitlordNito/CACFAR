library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ocpi; 
use ocpi.types.all;

entity single_write_dual_read_ram is
  generic (
    C_G_DATA_WIDTH : natural;
    C_G_ADDR_WIDTH : natural
  );
  port (
    clk    : in  std_logic;
    reset  : in  std_logic;
    enable : in  std_logic;
  
    input_data    : in  std_logic_vector(C_G_DATA_WIDTH - 1 downto 0);
    input_address : in  std_logic_vector(C_G_ADDR_WIDTH - 1 downto 0);
    input_valid   : in  std_logic;

    output0_address  : in  std_logic_vector(C_G_ADDR_WIDTH - 1 downto 0);
    output0_valid_in : in  std_logic;

    output0_data      : out std_logic_vector(C_G_DATA_WIDTH - 1 downto 0);
    output0_valid_out : out std_logic;

    output1_address  : in  std_logic_vector(C_G_ADDR_WIDTH - 1 downto 0);
    output1_valid_in : in  std_logic;

    output1_data      : out std_logic_vector(C_G_DATA_WIDTH - 1 downto 0);
    output1_valid_out : out std_logic
  );
end entity single_write_dual_read_ram;

architecture rtl of single_write_dual_read_ram is

  type ram_t is array (0 to 2 ** C_G_ADDR_WIDTH - 1) of std_logic_vector(C_G_DATA_WIDTH - 1 downto 0);

  signal ram : ram_t := (others => (others => '0'));

begin

  ram_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        output0_data      <= (others => '0');
        output0_valid_out <= '0';
        output1_data      <= (others => '0');
        output1_valid_out <= '0';
      elsif enable = '1' then
        -- Write to port
        if input_valid = '1' then
          ram(to_integer(unsigned(input_address))) <= input_data;
        end if;
        -- Read ports
        output0_valid_out <= '0';
        if output0_valid_in = '1' then
          output0_data      <= ram(to_integer(unsigned(output0_address)));
          output0_valid_out <= '1';
        end if;
        output1_valid_out <= '0';
        if output1_valid_in = '1' then
          output1_data <= ram(to_integer(unsigned(output1_address)));
          output1_valid_out <= '1';
        end if;
      end if;
    end if;
  end process ram_proc;

end architecture rtl;
