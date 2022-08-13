-- This file sets values for constants that may be affected by parameter values
library ocpi; use ocpi.all, ocpi.types.all;
package body cacfar_constants is
  -- Parameter property values as constants
  constant SAMPLE_SIZE : ushort_t := to_ushort(512);
  constant SAMPLING_FREQUENCY : ushort_t := to_ushort(1024);
  constant NUM_TRAIN_CELLS : ushort_t := to_ushort(12);
  constant NUM_GUARD_CELLS : ushort_t := to_ushort(4);
  constant THRESHOLD_FACTOR : ushort_t := to_ushort(5);
  constant ocpi_debug : bool_t := bfalse;
  constant ocpi_endian : ocpi_endian_t := little_e;
  constant ocpi_version : uchar_t := to_uchar(2);
  constant ocpi_max_opcode_input : uchar_t := to_uchar(0);
  constant ocpi_max_bytes_input : ulong_t := to_ulong(8192);
  constant ocpi_max_opcode_output : uchar_t := to_uchar(0);
  constant ocpi_max_bytes_output : ulong_t := to_ulong(8192);
  constant ocpi_max_latency_output : ushort_t := to_ushort(256);
  constant ocpi_buffer_size_output_offset : unsigned(31 downto 0) := X"00000000";
  constant ocpi_buffer_size_output_nbytes_1 : natural := 1;
  constant ocpi_blocked_output_offset : unsigned(31 downto 0) := X"00000004";
  constant ocpi_blocked_output_nbytes_1 : natural := 3;
  constant ocpi_latency_output_offset : unsigned(31 downto 0) := X"00000008";
  constant ocpi_latency_output_nbytes_1 : natural := 1;
  constant ocpi_messages_output_offset : unsigned(31 downto 0) := X"0000000c";
  constant ocpi_messages_output_nbytes_1 : natural := 3;
  constant ocpi_bytes_output_offset : unsigned(31 downto 0) := X"00000010";
  constant ocpi_bytes_output_nbytes_1 : natural := 3;
  constant ocpi_sizeof_non_raw_properties : natural := 20;
  constant ocpi_port_ctl_MAddr_width : natural := 5;
  constant ocpi_port_ctl_MData_width : natural := 32;
  constant ocpi_port_ctl_MByteEn_width : natural := 4;
  constant ocpi_port_input_MData_width : natural := 32;
  constant ocpi_port_input_MByteEn_width : natural := 1;
  constant ocpi_port_input_MDataInfo_width : natural := 1;
  constant ocpi_port_input_data_width : natural := 32;
  constant ocpi_port_input_byte_width : natural := 32;
  constant ocpi_port_output_MData_width : natural := 32;
  constant ocpi_port_output_MByteEn_width : natural := 1;
  constant ocpi_port_output_MDataInfo_width : natural := 1;
  constant ocpi_port_output_data_width : natural := 32;
  constant ocpi_port_output_byte_width : natural := 32;

end cacfar_constants;
