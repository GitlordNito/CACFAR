-- THIS FILE WAS GENERATED ON Thu Jun 23 15:27:28 2022 BST
-- BASED ON THE FILE: cacfar.xml
-- YOU PROBABLY SHOULD NOT EDIT IT
-- This file contains the implementation declarations for worker cacfar
-- Interface definition signal names are defined with pattern rule: "%s_"

--                   OCP-based Control Interface, based on the WCI profile,
--                      used for clk/reset, control and configuration
--                                           /\
--                                          /--\
--               +--------------------OCP----||----OCP---------------------------+
--               |                          \--/                                 |
--               |                           \/                                  |
--               |                   Entity: <worker>                            |
--               |                                                               |
--               O   +------------------------------------------------------+    O
--               C   |            Entity: <worker>_worker                   |    C
--               P   |                                                      |    P
--               |   | This "inner layer" is the code you write, based      |    |
-- Data Input    |\  | on definitions the in <worker>_worker_defs package,  |    |\  Data Output
-- Port based  ==| \ | and the <worker>_worker entity, both in this file,   |   =| \ Port based
-- on the WSI  ==| / | both in the "work" library.                          |   =| / on the WSI
-- OCP Profile   |/  | Package and entity declarations are in this          |    |/  OCP Profile
--               |   | <worker>_impl.vhd file. Architecture is in your      |    |
--               O   |  <worker>.vhd file                                   |    O
--               C   |                                                      |    C
--               P   +------------------------------------------------------+    P
--               |                                                               |
--               |     This outer layer is the "worker shell" code which         |
--               |     is automatically generated.  The "worker shell" is        |
--               |     defined as the <worker> entity using definitions in       |
--               |     the <worker>_defs package.  The worker shell is also      |
--               |     defined as a VHDL component in the <worker>_defs package, |
--               |     as declared in the <worker>-defs.vhd file.                |
--               |     The worker shell "architecture" is also in this file,      |
--               |     as well as some subsidiary modules.                       |
--               +---------------------------------------------------------------+

-- This package defines types needed for the inner worker entity's generics or ports
library IEEE; use IEEE.std_logic_1164.all, IEEE.numeric_std.all;
library ocpi; use ocpi.all, ocpi.types.all;
library prims, fixed_float, ocpi, ocpi_core_bsv, cdc;
use work.cacfar_constants.all, work.cacfar_defs.all;
package cacfar_worker_defs is

  -- The following record is for the writable properties of worker "cacfar"
  -- and/or the read strobes of volatile or readonly properties
  -- and/or the constant values of parameter properties (redundant with generics)
  type worker_props_in_t is record
    SAMPLE_SIZE                   : UShort_t;
    SAMPLING_FREQUENCY            : UShort_t;
    NUM_TRAIN_CELLS               : UShort_t;
    NUM_GUARD_CELLS               : UShort_t;
    THRESHOLD_FACTOR              : UShort_t;
    ocpi_debug                    : Bool_t;
    ocpi_endian                   : work.cacfar_constants.ocpi_endian_t;
    ocpi_version                  : UChar_t;
    ocpi_max_opcode_input         : UChar_t;
    ocpi_max_bytes_input          : ULong_t;
    ocpi_max_opcode_output        : UChar_t;
    ocpi_max_bytes_output         : ULong_t;
    ocpi_buffer_size_output       : UShort_t;
    ocpi_blocked_output_read      : Bool_t;
    ocpi_max_latency_output       : UShort_t;
    ocpi_latency_output_read      : Bool_t;
    ocpi_messages_output_read     : Bool_t;
    ocpi_bytes_output_read        : Bool_t;
  end record worker_props_in_t;
-- internal props_out combining internal and from-worker
  type internal_props_out_t is record
    ocpi_blocked_output           : ULong_t;
    ocpi_latency_output           : UShort_t;
    ocpi_messages_output          : ULong_t;
    ocpi_bytes_output             : ULong_t;
  end record internal_props_out_t;

  -- The following record(s) are for the inner/worker interfaces for port "ctl"
  type worker_ctl_in_t is record
    clk        : std_logic; -- this ports clk, as an input, different from wci_clk
    reset            : Bool_t;           -- this port is being reset from the outside
    control_op       : wci.control_op_t; -- control op in progress, or no_op_e
    state            : wci.state_t;      -- wci state: see state_t
    is_operating     : Bool_t;           -- shorthand for state = operating_e
    abort_control_op : Bool_t;           -- demand that slow control op finish now
    is_big_endian    : Bool_t;           -- for endian-switchable workers
  end record worker_ctl_in_t;
  type worker_ctl_out_t is record
    done             : Bool_t;           -- the pending prop access/config op is done
    error            : Bool_t;           -- the pending prop access/config op is erroneous
    finished         : Bool_t;           -- worker is finished
    attention        : Bool_t;           -- worker wants attention
  end record worker_ctl_out_t;

  -- The following record(s) are for the inner/worker interfaces for port "input"
  type worker_input_in_t is record
    reset            : Bool_t;           -- this port is being reset from the outside
    is_connected     : Bool_t;           -- this port is connected
    ready            : Bool_t;           -- this port is ready for data movement
                                         -- true means "take" is allowed
                                         -- one or more of: som, eom, valid are true
    data             : std_logic_vector(ocpi_port_input_data_width-1 downto 0);
    byte_enable      : std_logic_vector(ocpi_port_input_MByteEn_width-1 downto 0);
    som, valid, eom, eof  : Bool_t;           -- valid means data and byte_enable are present
  end record worker_input_in_t;
  type worker_input_out_t is record
    take             : Bool_t;           -- take data now from this port
                                         -- can be asserted when ready is true
  end record worker_input_out_t;

  -- The following record(s) are for the inner/worker interfaces for port "output"
  type worker_output_in_t is record
    reset            : Bool_t;           -- this port is being reset from the outside
    is_connected     : Bool_t;           -- this port is connected
    ready            : Bool_t;           -- this port is ready for data movement
  end record worker_output_in_t;
  type worker_output_out_t is record
    give             : Bool_t;           -- give data now to this port
                                         -- can be asserted when ready is true
    data             : std_logic_vector(ocpi_port_output_data_width-1 downto 0);
    byte_enable      : std_logic_vector(ocpi_port_output_MByteEn_width-1 downto 0);
    som, eom, valid  : Bool_t;       -- one or more must be true when 'give' is asserted
    eof  : Bool_t;
  end record worker_output_out_t;
  constant properties : ocpi.wci.properties_t(0 to 4) := (
  --#   bits    offset bytes-1 slen seqhdr elems write read    vol   debug
    0 => (16, ocpi_buffer_size_output_offset, ocpi_buffer_size_output_nbytes_1, 0,   0, 1, true,  false, false, false), -- ocpi_buffer_size_output
    1 => (32, ocpi_blocked_output_offset, ocpi_blocked_output_nbytes_1, 0,   0, 1, false, true,  true,  true), -- ocpi_blocked_output
    2 => (16, ocpi_latency_output_offset, ocpi_latency_output_nbytes_1, 0,   0, 1, false, true,  true,  false), -- ocpi_latency_output
    3 => (32, ocpi_messages_output_offset, ocpi_messages_output_nbytes_1, 0,   0, 1, false, true,  true,  true), -- ocpi_messages_output
    4 => (32, ocpi_bytes_output_offset, ocpi_bytes_output_nbytes_1, 0,   0, 1, false, true,  true,  true)  -- ocpi_bytes_output
  );
  constant worker : ocpi.wci.worker_t := (work.cacfar_constants.ocpi_port_ctl_MAddr_width, work.cacfar_constants.ocpi_sizeof_non_raw_properties, "00000110");
end package cacfar_worker_defs;

-- This is the entity to be implemented, depending on the above record types.
library IEEE; use IEEE.std_logic_1164.all, IEEE.numeric_std.all;
library ocpi; use ocpi.types.all;
library prims, fixed_float, ocpi, ocpi_core_bsv, cdc;
use work.cacfar_worker_defs.all, work.cacfar_defs.all, work.cacfar_constants.all;
entity worker is
  generic (
      SAMPLE_SIZE           : in   ushort_t := to_ushort(512);
      SAMPLING_FREQUENCY    : in   ushort_t := to_ushort(1024);
      NUM_TRAIN_CELLS       : in   ushort_t := to_ushort(12);
      NUM_GUARD_CELLS       : in   ushort_t := to_ushort(4);
      THRESHOLD_FACTOR      : in   ushort_t := to_ushort(5);
      ocpi_debug            : in   bool_t := bfalse;
      ocpi_endian           : in   ocpi_endian_t := little_e;
      ocpi_version          : in   uchar_t := to_uchar(2);
      ocpi_max_opcode_input : in   uchar_t := to_uchar(0);
      ocpi_max_bytes_input  : in   ulong_t := to_ulong(8192);
      ocpi_max_opcode_output: in   uchar_t := to_uchar(0);
      ocpi_max_bytes_output : in   ulong_t := to_ulong(8192);
      ocpi_max_latency_output : in   ushort_t := to_ushort(256)
  );
  port (

  -- The WCI interface named "ctl", with "cacfar" acting as OCP slave:
  --   Clock: this interface has its own input clock, named "ctl_Clk"
  -- WIP attributes for this WCI interface are:
  --   SizeOfConfigSpace: 20 (0x14)
  --   WritableConfigProperties: true
  --   ReadableConfigProperties: true
  --   Sub32BitConfigProperties: true
  --   ControlOperations (in addition to the required "start"): ,stop
  --   ResetWhileSuspended: false
    -- Signals for WCI input port named "ctl".  See record types above.
    ctl_in     : in  worker_ctl_in_t;
    ctl_out    : out worker_ctl_out_t := (done=>btrue, others=>bfalse);
    -- Input values and strobes for this worker's writable properties
    props_in   : in  worker_props_in_t;
  -- The WSI interface named "input", with "cacfar" acting as OCP slave:
  --   Clock: this interface uses the worker's clock named "ctl_Clk"
  -- WIP attributes for this WSI interface are:
 --  This interface is a data interface acting as consumer
  --   Protocol: "iqstream"
  --   DataValueWidth: 16
  --   DataValueGranularity: 2
  --   DiverseDataSizes: false
  --   MaxMessageValues: 4096
  --   VariableMessageLength: true
  --   ZeroLengthMessages: true
  --   MinMessageValues: 0
  --   Unbounded: false
  --   NumberOfOpcodes: 1
  --   DefaultBufferSize: 8192
  --   Producer: false
  --   Continuous: false
  --   DataWidth: 32
  --   ByteWidth: 32
  --   ImpreciseBurst: true
  --   Preciseburst: false
  --   Abortable: false
  --   EarlyRequest: false
  --   RegRequest: false
    -- Signals for WSI input port named "input".  See record types above.
    input_in   : in  worker_input_in_t;
    input_out  : out worker_input_out_t;
  -- The WSI interface named "output", with "cacfar" acting as OCP master:
  --   Clock: this interface uses the worker's clock named "ctl_Clk"
  -- WIP attributes for this WSI interface are:
 --  This interface is a data interface acting as producer
  --   Protocol: "iqstream"
  --   DataValueWidth: 16
  --   DataValueGranularity: 2
  --   DiverseDataSizes: false
  --   MaxMessageValues: 4096
  --   VariableMessageLength: true
  --   ZeroLengthMessages: true
  --   MinMessageValues: 0
  --   Unbounded: false
  --   NumberOfOpcodes: 1
  --   DefaultBufferSize: 8192
  --   Producer: true
  --   Continuous: false
  --   DataWidth: 32
  --   ByteWidth: 32
  --   ImpreciseBurst: true
  --   Preciseburst: false
  --   Abortable: false
  --   EarlyRequest: false
  --   RegRequest: false
    -- Signals for WSI output port named "output".  See record types above.
    output_in  : in  worker_output_in_t;
    output_out : out worker_output_out_t := (data => (others => '0'), byte_enable => (others => '1'), others => bfalse));

end entity worker;
-- The rest of the file below here is the implementation of the worker shell
-- which surrounds the entity to be implemented, above.

-- This is the entity declaration for the top level record-based VHDL
-- The achitecture for this entity will be in the implementation file
library IEEE; use IEEE.std_logic_1164.all, IEEE.numeric_std.all;
library ocpi; use ocpi.all, ocpi.types.all;
use work.cacfar_worker_defs.all, work.cacfar_defs.all, work.cacfar_constants.all;
library prims, fixed_float, ocpi, ocpi_core_bsv, cdc;
entity cacfar_rv--__
  is
  generic (
      SAMPLE_SIZE           : in   ushort_t := work.cacfar_constants.SAMPLE_SIZE;
      SAMPLING_FREQUENCY    : in   ushort_t := work.cacfar_constants.SAMPLING_FREQUENCY;
      NUM_TRAIN_CELLS       : in   ushort_t := work.cacfar_constants.NUM_TRAIN_CELLS;
      NUM_GUARD_CELLS       : in   ushort_t := work.cacfar_constants.NUM_GUARD_CELLS;
      THRESHOLD_FACTOR      : in   ushort_t := work.cacfar_constants.THRESHOLD_FACTOR;
      ocpi_debug            : in   bool_t := work.cacfar_constants.ocpi_debug;
      ocpi_endian           : in   ocpi_endian_t := work.cacfar_constants.ocpi_endian;
      ocpi_version          : in   uchar_t := work.cacfar_constants.ocpi_version;
      ocpi_max_opcode_input : in   uchar_t := work.cacfar_constants.ocpi_max_opcode_input;
      ocpi_max_bytes_input  : in   ulong_t := work.cacfar_constants.ocpi_max_bytes_input;
      ocpi_max_opcode_output: in   uchar_t := work.cacfar_constants.ocpi_max_opcode_output;
      ocpi_max_bytes_output : in   ulong_t := work.cacfar_constants.ocpi_max_bytes_output;
      ocpi_max_latency_output : in   ushort_t := work.cacfar_constants.ocpi_max_latency_output
  );
  port (

  -- The WCI interface named "ctl", with "cacfar" acting as OCP slave:
  --   Clock: this interface has its own input clock, named "ctl_Clk"
  -- WIP attributes for this WCI interface are:
  --   SizeOfConfigSpace: 20 (0x14)
  --   WritableConfigProperties: true
  --   ReadableConfigProperties: true
  --   Sub32BitConfigProperties: true
  --   ControlOperations (in addition to the required "start"): ,stop
  --   ResetWhileSuspended: false
    -- Signals for WCI input port named "ctl".  See record types above.
    ctl_in     : in  ctl_in_t;
    ctl_out    : out ctl_out_t;
  -- The WSI interface named "input", with "cacfar" acting as OCP slave:
  --   Clock: this interface uses the worker's clock named "ctl_Clk"
  -- WIP attributes for this WSI interface are:
 --  This interface is a data interface acting as consumer
  --   Protocol: "iqstream"
  --   DataValueWidth: 16
  --   DataValueGranularity: 2
  --   DiverseDataSizes: false
  --   MaxMessageValues: 4096
  --   VariableMessageLength: true
  --   ZeroLengthMessages: true
  --   MinMessageValues: 0
  --   Unbounded: false
  --   NumberOfOpcodes: 1
  --   DefaultBufferSize: 8192
  --   Producer: false
  --   Continuous: false
  --   DataWidth: 32
  --   ByteWidth: 32
  --   ImpreciseBurst: true
  --   Preciseburst: false
  --   Abortable: false
  --   EarlyRequest: false
  --   RegRequest: false
    -- Signals for WSI input port named "input".  See record types above.
    input_in   : in  input_in_t;
    input_out  : out input_out_t;
  -- The WSI interface named "output", with "cacfar" acting as OCP master:
  --   Clock: this interface uses the worker's clock named "ctl_Clk"
  -- WIP attributes for this WSI interface are:
 --  This interface is a data interface acting as producer
  --   Protocol: "iqstream"
  --   DataValueWidth: 16
  --   DataValueGranularity: 2
  --   DiverseDataSizes: false
  --   MaxMessageValues: 4096
  --   VariableMessageLength: true
  --   ZeroLengthMessages: true
  --   MinMessageValues: 0
  --   Unbounded: false
  --   NumberOfOpcodes: 1
  --   DefaultBufferSize: 8192
  --   Producer: true
  --   Continuous: false
  --   DataWidth: 32
  --   ByteWidth: 32
  --   ImpreciseBurst: true
  --   Preciseburst: false
  --   Abortable: false
  --   EarlyRequest: false
  --   RegRequest: false
    -- Signals for WSI output port named "output".  See record types above.
    output_in  : in  output_in_t;
    output_out : out output_out_t);
  -- these signals are used whether there is a control interface or not.
  signal wci_reset         : bool_t;
  signal wci_is_operating  : bool_t;
  -- Aliases for WCI interface "ctl"
  -- Constants for cacfar's property addresses
  -- Aliases for interface "input"
  -- Aliases for interface "output"
  signal props_to_worker   : worker_props_in_t;
  signal internal_props_out : internal_props_out_t; -- this includes builtin volatiles
  signal props_builtin_ocpi_blocked_output : ULong_t;
  signal props_builtin_ocpi_latency_output : UShort_t;
  signal props_builtin_ocpi_messages_output : ULong_t;
  signal props_builtin_ocpi_bytes_output : ULong_t;
  -- wci information into worker
  signal wci_is_big_endian    : Bool_t;
  signal wci_control_op       : wci.control_op_t;
  signal wci_state            : wci.state_t;
  -- wci information from worker
  signal wci_attention        : Bool_t;
  signal wci_abort_control_op : Bool_t;
  signal wci_done             : Bool_t;
  signal wci_error            : Bool_t;
  signal wci_finished         : Bool_t;
  signal input_take  : Bool_t;
  signal input_ready : Bool_t;
  signal input_reset : Bool_t; -- this port is being reset from the outside
  signal input_is_connected : Bool_t;
  signal input_first_take  : Bool_t;
  signal input_data  : std_logic_vector(ocpi_port_input_data_width-1 downto 0);
  signal input_byte_enable: std_logic_vector(ocpi_port_input_MByteEn_width-1 downto 0);
  signal input_som   : Bool_t;
  signal input_eom   : Bool_t;
  signal input_valid : Bool_t;
  signal input_eof   : Bool_t;
  signal output_give  : Bool_t;
  signal output_ready : Bool_t;
  signal output_reset : Bool_t; -- this port is being reset from the outside
  signal output_is_connected : Bool_t;
  signal output_data  : std_logic_vector(ocpi_port_output_data_width-1 downto 0);
  signal output_byte_enable: std_logic_vector(ocpi_port_output_MByteEn_width-1 downto 0);
  signal output_som   : Bool_t;
  signal output_eom   : Bool_t;
  signal output_valid : Bool_t;
  signal output_eof   : Bool_t;
  signal output_out_temp : output_out_t; -- temp needed to workaround Vivado/xsim bug v2016.4
end entity cacfar_rv--__
;

-- Here we define and implement the WCI interface module for this worker,
-- which can be used by the worker implementer to avoid all the OCP/WCI issues
library IEEE; use IEEE.std_logic_1164.all, IEEE.numeric_std.all;
library ocpi; use ocpi.all, ocpi.types.all, ocpi.util.all;
use work.cacfar_worker_defs.all, work.cacfar_constants.all, work.cacfar_defs.all;
entity cacfar_wci is
  generic(ocpi_debug : bool_t; endian : endian_t);
  port(
    inputs                        : in  ctl_in_t;          -- signal bundle from wci interface
    done                          : in  bool_t := btrue;   -- worker uses this to delay completion
    error                         : in  bool_t := bfalse;  -- worker uses this to indicate error
    finished                      : in  bool_t := bfalse;  -- worker uses this to indicate finished
    attention                     : in  bool_t := bfalse;  -- worker indicates an attention condition
    outputs                       : out ctl_out_t;         -- signal bundle to wci interface
    reset                         : out bool_t;            -- wci reset for worker
    control_op                    : out wci.control_op_t;  -- control op in progress, or no_op_e
    state                         : out wci.state_t;       -- wci state: see state_t
    is_operating                  : out bool_t;            -- shorthand for state==operating_e
    is_big_endian                 : out bool_t;            -- for endian-switchable workers
    abort_control_op              : out bool_t;            -- forcible abort a control-op when
                                                -- worker uses 'done' to delay it
    props_from_worker  : in  internal_props_out_t;
    props_to_worker    : out worker_props_in_t
);
end entity;
architecture rtl of cacfar_wci is
  signal my_reset : bool_t; -- internal usage of output
  signal my_big_endian : bool_t;
  signal raw_to_worker : wci.raw_in_t;
  -- signals for property reads and writes
  signal offsets       : wci.offset_a_t(0 to 4);  -- offsets within each property
  signal hi32          : bool_t;                 -- high word of 64 bit value
  signal nbytes_1      : types.byte_offset_t;       -- # bytes minus one being read/written
  -- signals between the decoder and the writable property registers
  signal write_enables : bool_array_t(0 to 4);
  signal data          : wci.data_a_t(0 to 4);   -- data being written, right justified
  -- signals between the decoder and the readback mux
  signal read_enables  : bool_array_t(0 to 4);
  signal read_index    : unsigned(ocpi.util.width_for_max(4)-1 downto 0);
  signal readback_data : wci.data_a_t(work.cacfar_worker_defs.properties'range);
  -- The output to SData from nonRaw properties
  signal nonRaw_SData  : std_logic_vector(31 downto 0);
  -- temp signals to workaround isim/fuse crash bug
  signal MFlag   : std_logic_vector(18 downto 0);
  signal wciAddr : std_logic_vector(31 downto 0);
begin
  is_big_endian                          <= my_big_endian;
  wciAddr(inputs.MAddr'range)            <= inputs.MAddr;
  MFlag                                  <= util.slv0(17) & inputs.MFlag;
  wciAddr(31 downto inputs.MAddr'length) <= (others => '0');
  outputs.SFlag(0)                       <= attention;
  outputs.SFlag(1)                       <= '0'; -- waiting for barrier
  outputs.SFlag(2)                       <= finished;
  my_reset                               <= to_bool(inputs.MReset_n = '0');
  reset                                  <= my_reset;
  wci_decode : component wci.decoder
      generic map(worker               => work.cacfar_worker_defs.worker,
                  ocpi_debug           => ocpi_debug,
                  endian               => endian,
                  properties           => work.cacfar_worker_defs.properties)
      port map(   ocp_in.Clk           => inputs.Clk,
                  ocp_in.Maddr         => wciAddr,
                  ocp_in.MAddrSpace    => inputs.MAddrSpace,
                  ocp_in.MByteEn       => inputs.MByteEn,
                  ocp_in.MCmd          => inputs.MCmd,
                  ocp_in.MData         => inputs.MData,
                  ocp_in.MFlag         => MFlag,
                  ocp_in.MReset_n      => inputs.MReset_n,
                  done                 => done,
                  error                => error,
                  finished             => finished,
                  resp                 => outputs.SResp,
                  busy                 => outputs.SThreadBusy(0),
                  control_op           => control_op,
                  state                => state,
                  is_operating         => is_operating,
                  is_big_endian        => my_big_endian,
                  raw_in               => wci.raw_out_zero,
                  raw_out              => open,
                  barrier              => open,
                  crew                 => open,
                  rank                 => open,
                  abort_control_op     => abort_control_op,
                  write_enables        => write_enables,
                  read_enables         => read_enables,
                  offsets              => offsets,
                  hi32                 => hi32,
                  nbytes_1             => nbytes_1,
                  data_outputs         => data,
                  read_index           => read_index);
  readback : component wci.readback
    generic map(work.cacfar_worker_defs.properties, ocpi_debug)
    port map(   read_index   => read_index,
                data_inputs  => readback_data,
                data_output  => nonRaw_SData);
  outputs.SData <= nonRaw_SData;
  props_to_worker.SAMPLE_SIZE <= work.cacfar_constants.SAMPLE_SIZE;
  props_to_worker.SAMPLING_FREQUENCY <= work.cacfar_constants.SAMPLING_FREQUENCY;
  props_to_worker.NUM_TRAIN_CELLS <= work.cacfar_constants.NUM_TRAIN_CELLS;
  props_to_worker.NUM_GUARD_CELLS <= work.cacfar_constants.NUM_GUARD_CELLS;
  props_to_worker.THRESHOLD_FACTOR <= work.cacfar_constants.THRESHOLD_FACTOR;
  props_to_worker.ocpi_debug <= work.cacfar_constants.ocpi_debug;
  props_to_worker.ocpi_endian <= work.cacfar_constants.ocpi_endian;
  props_to_worker.ocpi_version <= work.cacfar_constants.ocpi_version;
  props_to_worker.ocpi_max_opcode_input <= work.cacfar_constants.ocpi_max_opcode_input;
  props_to_worker.ocpi_max_bytes_input <= work.cacfar_constants.ocpi_max_bytes_input;
  props_to_worker.ocpi_max_opcode_output <= work.cacfar_constants.ocpi_max_opcode_output;
  props_to_worker.ocpi_max_bytes_output <= work.cacfar_constants.ocpi_max_bytes_output;
  ocpi_buffer_size_output_property : component ocpi.props.UShort_property
    generic map(worker       => work.cacfar_worker_defs.worker,
                property     => work.cacfar_worker_defs.properties(0),
                default      => to_ushort(0))
    port map(   clk          => inputs.Clk,
                reset        => my_reset,
                is_big_endian=> my_big_endian,
                write_enable => write_enables(0),
                data         => data(0)(15 downto 0),
                value        => props_to_worker.ocpi_buffer_size_output,
                written      => open);
  readback_data(0) <= (others => '0');
  ocpi_blocked_output_readback : component ocpi.props.ULong_read_property
    generic map(worker       => work.cacfar_worker_defs.worker,
                property     => work.cacfar_worker_defs.properties(1))
    port map(   value        => props_from_worker.ocpi_blocked_output,
                is_big_endian=> my_big_endian,
                data_out     => readback_data(1));
  props_to_worker.ocpi_blocked_output_read <= read_enables(1);
  props_to_worker.ocpi_max_latency_output <= work.cacfar_constants.ocpi_max_latency_output;
  ocpi_latency_output_readback : component ocpi.props.UShort_read_property
    generic map(worker       => work.cacfar_worker_defs.worker,
                property     => work.cacfar_worker_defs.properties(2))
    port map(   value        => props_from_worker.ocpi_latency_output,
                is_big_endian=> my_big_endian,
                data_out     => readback_data(2));
  props_to_worker.ocpi_latency_output_read <= read_enables(2);
  ocpi_messages_output_readback : component ocpi.props.ULong_read_property
    generic map(worker       => work.cacfar_worker_defs.worker,
                property     => work.cacfar_worker_defs.properties(3))
    port map(   value        => props_from_worker.ocpi_messages_output,
                is_big_endian=> my_big_endian,
                data_out     => readback_data(3));
  props_to_worker.ocpi_messages_output_read <= read_enables(3);
  ocpi_bytes_output_readback : component ocpi.props.ULong_read_property
    generic map(worker       => work.cacfar_worker_defs.worker,
                property     => work.cacfar_worker_defs.properties(4))
    port map(   value        => props_from_worker.ocpi_bytes_output,
                is_big_endian=> my_big_endian,
                data_out     => readback_data(4));
  props_to_worker.ocpi_bytes_output_read <= read_enables(4);
end architecture rtl;
library IEEE; use IEEE.std_logic_1164.all, ieee.numeric_std.all;
library ocpi; use ocpi.types.all; -- remove this to avoid all ocpi name collisions
library cdc; use cdc.all;
architecture rtl of cacfar_rv--__
  is
  constant num_reset_cycles  : natural := 17;
begin
  input_is_connected <= not input_reset;
  output_is_connected <= not output_reset;
  internal_props_out <=
    (ocpi_blocked_output => props_builtin_ocpi_blocked_output,
     ocpi_latency_output => props_builtin_ocpi_latency_output,
     ocpi_messages_output => props_builtin_ocpi_messages_output,
     ocpi_bytes_output => props_builtin_ocpi_bytes_output);
  -- This instantiates the WCI/Control module/entity generated in the *_impl.vhd file
  -- With no user logic at all, this implements writable properties.
  wci : entity work.cacfar_wci
    generic map(ocpi_debug => ocpi_debug, endian => ocpi_endian)
    port map(-- These first signals are just for use by the wci module, not the worker
             inputs            => ctl_in,
             outputs           => ctl_out,
             -- These are outputs used by the worker logic
             reset             => wci_reset, -- OCP guarantees 16 clocks of reset
             control_op        => wci_control_op,
             state             => wci_state,
             is_operating      => wci_is_operating,
             done              => wci_done,
             error             => wci_error,
             finished          => wci_finished,
             attention         => wci_attention,
             is_big_endian     => wci_is_big_endian,
             abort_control_op  => wci_abort_control_op,
             props_from_worker => internal_props_out,
             props_to_worker   => props_to_worker);
  --
  -- The WSI interface helper component instance for port "input"
  input_port : component ocpi.wsi.slave
    generic map(precise          => false,
                mdata_width      => ocpi_port_input_MData_width,
                mdata_info_width => ocpi_port_input_MDataInfo_width,
                burst_width      => 2,
                n_bytes          => ocpi_port_input_MByteEn_width,
                byte_width       => ocpi_port_input_byte_width,
                opcode_width     => 1,
                own_clock        => false,
                hdl_version      => to_integer(ocpi_version),
                early_request    => false)
    port map   (wsi_clk          => ctl_in.Clk,
                MBurstLength     => input_in.MBurstLength,
                MByteEn          => input_in.MByteEn,
                MCmd             => input_in.MCmd,
                MData            => input_in.MData,
                MDataInfo        => input_in.MDataInfo,
                MDataLast        => open,
                MDataValid       => open,
                MReqInfo         => (others => '0'),
                MReqLast         => input_in.MReqLast,
                MReset_n         => input_in.MReset_n,
                SReset_n         => input_out.SReset_n,
                SThreadBusy      => input_out.SThreadBusy,
                wsi_reset        => wci_reset,
                wsi_is_operating => wci_is_operating,
                first_take       => input_first_take, -- output the input port
                eof              => input_eof,        -- output from the input port
                reset            => input_reset,
                ready            => input_ready,
                som              => input_som,
                eom              => input_eom,
                valid            => input_valid,
                data             => input_data,
                abort            => open,
                byte_enable      => input_byte_enable,
                burst_length     => open,
                opcode           => open,
                take             => input_take);
  --
  -- The WSI interface helper component instance for port "output"
  output_out <= output_out_temp; -- temp needed to workaround Vivado/xsim bug v2016.4
  output_port : component ocpi.wsi.master
    generic map(precise          => false,
                mdata_width      => ocpi_port_output_MData_width,
                mdata_info_width => ocpi_port_output_MDataInfo_width,
                burst_width      => 2,
                n_bytes          => ocpi_port_output_MByteEn_width,
                byte_width       => ocpi_port_output_byte_width,
                opcode_width     => 1,
                own_clock        => false,
                insert_eom        => false,
                max_bytes         => to_integer(ocpi_max_bytes_output),
                max_latency       => to_integer(ocpi_max_latency_output),
                worker_eof        => true,
                fixed_buffer_size => false,
                debug             => its(ocpi_debug),
                hdl_version      => to_integer(ocpi_version),
                early_request    => false)
    port map   (wsi_clk          => ctl_in.Clk,
                MBurstLength     => output_out_temp.MBurstLength,
                MByteEn          => output_out_temp.MByteEn,
                MCmd             => output_out_temp.MCmd,
                MData            => output_out_temp.MData,
                MDataInfo        => output_out_temp.MDataInfo,
                MDataLast        => open,
                MDataValid       => open,
                MReqInfo         => open,
                MReqLast         => output_out_temp.MReqLast,
                MReset_n         => output_out_temp.MReset_n,
                SReset_n         => output_in.SReset_n,
                SThreadBusy      => output_in.SThreadBusy,
                wsi_reset        => wci_reset,
                wsi_is_operating => wci_is_operating,
                first_take       => input_first_take,   -- from input port to output port
                input_eof        => input_eof,   -- from input port to output port
                eof              => output_eof,   -- from worker to output port
                latency          => props_builtin_ocpi_latency_output,
                messages         => props_builtin_ocpi_messages_output,
                bytes            => props_builtin_ocpi_bytes_output,
                buffer_size      => props_to_worker.ocpi_buffer_size_output,
                reset            => output_reset,
                ready            => output_ready,
                som              => output_som,
                eom              => output_eom,
                valid            => output_valid,
                data             => output_data,
                abort            => '0',
                byte_enable      => output_byte_enable,
                burst_length     => (1 downto 0 => '0'),
                opcode           => (0 downto 0 => '0'),
                give             => output_give);
worker : entity work.worker
  generic map(
    SAMPLE_SIZE => SAMPLE_SIZE,
    SAMPLING_FREQUENCY => SAMPLING_FREQUENCY,
    NUM_TRAIN_CELLS => NUM_TRAIN_CELLS,
    NUM_GUARD_CELLS => NUM_GUARD_CELLS,
    THRESHOLD_FACTOR => THRESHOLD_FACTOR,
    ocpi_debug => ocpi_debug,
    ocpi_endian => ocpi_endian,
    ocpi_version => ocpi_version,
    ocpi_max_opcode_input => ocpi_max_opcode_input,
    ocpi_max_bytes_input => ocpi_max_bytes_input,
    ocpi_max_opcode_output => ocpi_max_opcode_output,
    ocpi_max_bytes_output => ocpi_max_bytes_output,
    ocpi_max_latency_output => ocpi_max_latency_output)
  port map(
    ctl_in.clk => ctl_in.Clk,
    ctl_in.reset => wci_reset,
    ctl_in.control_op => wci_control_op,
    ctl_in.state => wci_state,
    ctl_in.is_operating => wci_is_operating,
    ctl_in.abort_control_op => wci_abort_control_op,
    ctl_in.is_big_endian => wci_is_big_endian,
    ctl_out.done => wci_done,
    ctl_out.error => wci_error,
    ctl_out.finished => wci_finished,
    ctl_out.attention => wci_attention,
    input_in.reset => input_reset,
    input_in.is_connected => input_is_connected,
    input_in.ready => input_ready,
    input_in.data => input_data,
    input_in.byte_enable => input_byte_enable,
    input_in.som => input_som,
    input_in.eom => input_eom,
    input_in.valid => input_valid,
    input_in.eof => input_eof,
    input_out.take => input_take,
    output_in.reset => output_reset,
    output_in.is_connected => output_is_connected,
    output_in.ready => output_ready,
    output_out.give => output_give,
    output_out.data => output_data,
    output_out.byte_enable => output_byte_enable,
    output_out.som => output_som,
    output_out.eom => output_eom,
    output_out.valid => output_valid,
    output_out.eof => output_eof,
    props_in => props_to_worker);
end rtl;

-- This is the wrapper entity that does NOT use records for ports
-- It "wraps" the _rv entity that DOES use records for ports
library IEEE; use IEEE.std_logic_1164.all, IEEE.numeric_std.all;
library ocpi; use ocpi.all, ocpi.types.all;
use work.cacfar_defs.all, work.cacfar_constants.all;
library prims, fixed_float, ocpi, ocpi_core_bsv, cdc;
entity cacfar--__
  is
  generic (
      SAMPLE_SIZE           : in   std_logic_vector((16)-1 downto 0) := from_UShort(work.cacfar_constants.SAMPLE_SIZE);
      SAMPLING_FREQUENCY    : in   std_logic_vector((16)-1 downto 0) := from_UShort(work.cacfar_constants.SAMPLING_FREQUENCY);
      NUM_TRAIN_CELLS       : in   std_logic_vector((16)-1 downto 0) := from_UShort(work.cacfar_constants.NUM_TRAIN_CELLS);
      NUM_GUARD_CELLS       : in   std_logic_vector((16)-1 downto 0) := from_UShort(work.cacfar_constants.NUM_GUARD_CELLS);
      THRESHOLD_FACTOR      : in   std_logic_vector((16)-1 downto 0) := from_UShort(work.cacfar_constants.THRESHOLD_FACTOR);
      ocpi_debug            : in   std_logic_vector((1)-1 downto 0) := from_Bool(work.cacfar_constants.ocpi_debug);
      ocpi_endian           : in   std_logic_vector((2)-1 downto 0) := std_logic_vector(to_unsigned(ocpi_endian_t'pos(work.cacfar_constants.ocpi_endian), 2));
      ocpi_version          : in   std_logic_vector((8)-1 downto 0) := from_UChar(work.cacfar_constants.ocpi_version);
      ocpi_max_opcode_input : in   std_logic_vector((8)-1 downto 0) := from_UChar(work.cacfar_constants.ocpi_max_opcode_input);
      ocpi_max_bytes_input  : in   std_logic_vector((32)-1 downto 0) := from_ULong(work.cacfar_constants.ocpi_max_bytes_input);
      ocpi_max_opcode_output: in   std_logic_vector((8)-1 downto 0) := from_UChar(work.cacfar_constants.ocpi_max_opcode_output);
      ocpi_max_bytes_output : in   std_logic_vector((32)-1 downto 0) := from_ULong(work.cacfar_constants.ocpi_max_bytes_output);
      ocpi_max_latency_output : in   std_logic_vector((16)-1 downto 0) := from_UShort(work.cacfar_constants.ocpi_max_latency_output)
  );
  port (

  -- The WCI interface named "ctl", with "cacfar" acting as OCP slave:
  --   Clock: this interface has its own input clock, named "ctl_Clk"
  -- WIP attributes for this WCI interface are:
  --   SizeOfConfigSpace: 20 (0x14)
  --   WritableConfigProperties: true
  --   ReadableConfigProperties: true
  --   Sub32BitConfigProperties: true
  --   ControlOperations (in addition to the required "start"): ,stop
  --   ResetWhileSuspended: false
    ctl_Clk               : in   std_logic;
    ctl_MAddr             : in   std_logic_vector(ocpi_port_ctl_MAddr_width-1 downto 0);
    ctl_MAddrSpace        : in   std_logic_vector(1-1 downto 0);
    ctl_MByteEn           : in   std_logic_vector(ocpi_port_ctl_MByteEn_width-1 downto 0);
    ctl_MCmd              : in   std_logic_vector(3-1 downto 0);
    ctl_MData             : in   std_logic_vector(ocpi_port_ctl_MData_width-1 downto 0);
    ctl_MFlag             : in   std_logic_vector(2-1 downto 0);
    ctl_MReset_n          : in   std_logic;
    ctl_SData             : out  std_logic_vector(32-1 downto 0);
    ctl_SFlag             : out  std_logic_vector(3-1 downto 0);
    ctl_SResp             : out  std_logic_vector(2-1 downto 0);
    ctl_SThreadBusy       : out  std_logic_vector(1-1 downto 0);

  -- The WSI interface named "input", with "cacfar" acting as OCP slave:
  --   Clock: this interface uses the worker's clock named "ctl_Clk"
  -- WIP attributes for this WSI interface are:
 --  This interface is a data interface acting as consumer
  --   Protocol: "iqstream"
  --   DataValueWidth: 16
  --   DataValueGranularity: 2
  --   DiverseDataSizes: false
  --   MaxMessageValues: 4096
  --   VariableMessageLength: true
  --   ZeroLengthMessages: true
  --   MinMessageValues: 0
  --   Unbounded: false
  --   NumberOfOpcodes: 1
  --   DefaultBufferSize: 8192
  --   Producer: false
  --   Continuous: false
  --   DataWidth: 32
  --   ByteWidth: 32
  --   ImpreciseBurst: true
  --   Preciseburst: false
  --   Abortable: false
  --   EarlyRequest: false
  --   RegRequest: false
  -- No Clk signal here. The "input" interface uses "ctl_Clk" as clock
    input_MBurstLength    : in   std_logic_vector(2-1 downto 0);
    input_MByteEn         : in   std_logic_vector(ocpi_port_input_MByteEn_width-1 downto 0);
    input_MCmd            : in   std_logic_vector(3-1 downto 0);
    input_MData           : in   std_logic_vector(ocpi_port_input_MData_width-1 downto 0);
    input_MDataInfo       : in   std_logic_vector(ocpi_port_input_MDataInfo_width-1 downto 0);
    input_MReqLast        : in   std_logic;
    input_MReset_n        : in   std_logic;
    input_SReset_n        : out  std_logic;
    input_SThreadBusy     : out  std_logic_vector(1-1 downto 0);

  -- The WSI interface named "output", with "cacfar" acting as OCP master:
  --   Clock: this interface uses the worker's clock named "ctl_Clk"
  -- WIP attributes for this WSI interface are:
 --  This interface is a data interface acting as producer
  --   Protocol: "iqstream"
  --   DataValueWidth: 16
  --   DataValueGranularity: 2
  --   DiverseDataSizes: false
  --   MaxMessageValues: 4096
  --   VariableMessageLength: true
  --   ZeroLengthMessages: true
  --   MinMessageValues: 0
  --   Unbounded: false
  --   NumberOfOpcodes: 1
  --   DefaultBufferSize: 8192
  --   Producer: true
  --   Continuous: false
  --   DataWidth: 32
  --   ByteWidth: 32
  --   ImpreciseBurst: true
  --   Preciseburst: false
  --   Abortable: false
  --   EarlyRequest: false
  --   RegRequest: false
  -- No Clk signal here. The "output" interface uses "ctl_Clk" as clock
    output_SReset_n       : in   std_logic;
    output_SThreadBusy    : in   std_logic_vector(1-1 downto 0);
    output_MBurstLength   : out  std_logic_vector(2-1 downto 0);
    output_MByteEn        : out  std_logic_vector(ocpi_port_output_MByteEn_width-1 downto 0);
    output_MCmd           : out  std_logic_vector(3-1 downto 0);
    output_MData          : out  std_logic_vector(ocpi_port_output_MData_width-1 downto 0);
    output_MDataInfo      : out  std_logic_vector(ocpi_port_output_MDataInfo_width-1 downto 0);
    output_MReqLast       : out  std_logic;
    output_MReset_n       : out  std_logic
);
end entity cacfar--__
;
library IEEE; use IEEE.std_logic_1164.all, ieee.numeric_std.all;
library ocpi; use ocpi.types.all; -- remove this to avoid all ocpi name collisions
library prims, fixed_float, ocpi, ocpi_core_bsv, cdc;
architecture rtl of cacfar--__
is
begin
  rv: entity work.cacfar_rv--__
    generic map(
      SAMPLE_SIZE => UShort_t(SAMPLE_SIZE),
      SAMPLING_FREQUENCY => UShort_t(SAMPLING_FREQUENCY),
      NUM_TRAIN_CELLS => UShort_t(NUM_TRAIN_CELLS),
      NUM_GUARD_CELLS => UShort_t(NUM_GUARD_CELLS),
      THRESHOLD_FACTOR => UShort_t(THRESHOLD_FACTOR),
      ocpi_debug => to_Bool(ocpi_debug),
      ocpi_endian => ocpi_endian_t'val(to_integer(unsigned(ocpi_endian))),
      ocpi_version => UChar_t(ocpi_version),
      ocpi_max_opcode_input => UChar_t(ocpi_max_opcode_input),
      ocpi_max_bytes_input => ULong_t(ocpi_max_bytes_input),
      ocpi_max_opcode_output => UChar_t(ocpi_max_opcode_output),
      ocpi_max_bytes_output => ULong_t(ocpi_max_bytes_output),
      ocpi_max_latency_output => UShort_t(ocpi_max_latency_output))
    port map(
      ctl_in.Clk => ctl_Clk,
      ctl_in.MAddr => ctl_MAddr,
      ctl_in.MAddrSpace => ctl_MAddrSpace,
      ctl_in.MByteEn => ctl_MByteEn,
      ctl_in.MCmd => ctl_MCmd,
      ctl_in.MData => ctl_MData,
      ctl_in.MFlag => ctl_MFlag,
      ctl_in.MReset_n => ctl_MReset_n,
      ctl_out.SData => ctl_SData,
      ctl_out.SFlag => ctl_SFlag,
      ctl_out.SResp => ctl_SResp,
      ctl_out.SThreadBusy => ctl_SThreadBusy,
      input_in.MBurstLength => input_MBurstLength,
      input_in.MByteEn => input_MByteEn,
      input_in.MCmd => input_MCmd,
      input_in.MData => input_MData,
      input_in.MDataInfo => input_MDataInfo,
      input_in.MReqLast => input_MReqLast,
      input_in.MReset_n => input_MReset_n,
      input_out.SReset_n => input_SReset_n,
      input_out.SThreadBusy => input_SThreadBusy,
      output_in.SReset_n => output_SReset_n,
      output_in.SThreadBusy => output_SThreadBusy,
      output_out.MBurstLength => output_MBurstLength,
      output_out.MByteEn => output_MByteEn,
      output_out.MCmd => output_MCmd,
      output_out.MData => output_MData,
      output_out.MDataInfo => output_MDataInfo,
      output_out.MReqLast => output_MReqLast,
      output_out.MReset_n => output_MReset_n);
end rtl;
