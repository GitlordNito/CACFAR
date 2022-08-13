-- THIS FILE WAS GENERATED ON Thu Jun 23 15:27:28 2022 BST
-- BASED ON THE FILE: cacfar.xml
-- YOU PROBABLY SHOULD NOT EDIT IT
-- This file contains the VHDL declarations for the worker with
--  spec name "local.cacfar.cacfar.hdl.cacfar" and implementation name "cacfar".
-- It is needed for instantiating the worker.
-- Interface signal names are defined with pattern rule: "%s_"
Library IEEE; use IEEE.std_logic_1164.all, IEEE.numeric_std.all;
Library ocpi; use ocpi.all, ocpi.types.all;
library prims, fixed_float, ocpi, ocpi_core_bsv, cdc;

-- Package with constant definitions for instantiating this worker
package cacfar_constants is
 -- Declarations of parameter properties.
 -- The actual values used are in the package body,
 -- which is generated for each configuration.
  constant SAMPLE_SIZE : ushort_t;
  constant SAMPLING_FREQUENCY : ushort_t;
  constant NUM_TRAIN_CELLS : ushort_t;
  constant NUM_GUARD_CELLS : ushort_t;
  constant THRESHOLD_FACTOR : ushort_t;
  constant ocpi_debug : bool_t;
  alias ocpi_endian_t is ocpi.types.endian_t;
  constant ocpi_endian : ocpi_endian_t;
  constant ocpi_version : uchar_t;
  constant ocpi_max_opcode_input : uchar_t;
  constant ocpi_max_bytes_input : ulong_t;
  constant ocpi_max_opcode_output : uchar_t;
  constant ocpi_max_bytes_output : ulong_t;
  constant ocpi_buffer_size_output_offset : unsigned(31 downto 0);
  constant ocpi_buffer_size_output_nbytes_1 : natural;
  constant ocpi_blocked_output_offset : unsigned(31 downto 0);
  constant ocpi_blocked_output_nbytes_1 : natural;
  constant ocpi_max_latency_output : ushort_t;
  constant ocpi_latency_output_offset : unsigned(31 downto 0);
  constant ocpi_latency_output_nbytes_1 : natural;
  constant ocpi_messages_output_offset : unsigned(31 downto 0);
  constant ocpi_messages_output_nbytes_1 : natural;
  constant ocpi_bytes_output_offset : unsigned(31 downto 0);
  constant ocpi_bytes_output_nbytes_1 : natural;
  constant ocpi_sizeof_non_raw_properties: natural;

  -- Constant declarations for parameterized signal widths for port "ctl"
  constant ocpi_port_ctl_MAddr_width : natural;
  constant ocpi_port_ctl_MData_width : natural;
  constant ocpi_port_ctl_MByteEn_width : natural;

  -- Constant declarations for parameterized signal widths for port "input"
  constant ocpi_port_input_MData_width : natural;
  constant ocpi_port_input_MByteEn_width : natural;
  constant ocpi_port_input_MDataInfo_width : natural;
  constant ocpi_port_input_data_width : natural;
  constant ocpi_port_input_byte_width : natural;

  -- Constant declarations for parameterized signal widths for port "output"
  constant ocpi_port_output_MData_width : natural;
  constant ocpi_port_output_MByteEn_width : natural;
  constant ocpi_port_output_MDataInfo_width : natural;
  constant ocpi_port_output_data_width : natural;
  constant ocpi_port_output_byte_width : natural;
end package cacfar_constants;
-- Package with definitions for instantiating this worker
Library IEEE; use IEEE.std_logic_1164.all, IEEE.numeric_std.all;
Library ocpi; use ocpi.all, ocpi.types.all;
library prims, fixed_float, ocpi, ocpi_core_bsv, cdc;
use work.cacfar_constants.all;
package cacfar_defs is

  -- These 2 records correspond to the input and output sides of the OCP bundle
  -- for the "cacfar" worker's "WCI" interface named "ctl"
  -- This interface has its own clock, which is an input.

  -- Record for the WCI input (OCP master) signals for port "ctl" of worker "cacfar"
  type ctl_in_t is record
    Clk                 : std_logic;
    MAddr               : std_logic_vector(ocpi_port_ctl_MAddr_width-1 downto 0);
    MAddrSpace          : std_logic_vector(1-1 downto 0);
    MByteEn             : std_logic_vector(ocpi_port_ctl_MByteEn_width-1 downto 0);
    MCmd                : ocpi.ocp.MCmd_t;
    MData               : std_logic_vector(ocpi_port_ctl_MData_width-1 downto 0);
    MFlag               : std_logic_vector(2-1 downto 0);
    MReset_n            : std_logic;
  end record ctl_in_t;

  -- Record for the WCI output (OCP slave) signals for port "ctl" of worker "cacfar"
  type ctl_out_t is record
    SData               : std_logic_vector(32-1 downto 0);
    SFlag               : std_logic_vector(3-1 downto 0);
    SResp               : ocpi.ocp.SResp_t;
    SThreadBusy         : std_logic_vector(1-1 downto 0);
  end record ctl_out_t;

  -- These 2 records correspond to the input and output sides of the OCP bundle
  -- for the "cacfar" worker's "WSI" interface named "input"

  -- Record for the WSI input (OCP master) signals for port "input" of worker "cacfar"
  type input_in_t is record
    MBurstLength        : std_logic_vector(2-1 downto 0);
    MByteEn             : std_logic_vector(ocpi_port_input_MByteEn_width-1 downto 0);
    MCmd                : ocpi.ocp.MCmd_t;
    MData               : std_logic_vector(ocpi_port_input_MData_width-1 downto 0);
    MDataInfo           : std_logic_vector(ocpi_port_input_MDataInfo_width-1 downto 0);
    MReqLast            : std_logic;
    MReset_n            : std_logic;
  end record input_in_t;

  -- Record for the WSI output (OCP slave) signals for port "input" of worker "cacfar"
  type input_out_t is record
    SReset_n            : std_logic;
    SThreadBusy         : std_logic_vector(1-1 downto 0);
  end record input_out_t;

  -- These 2 records correspond to the input and output sides of the OCP bundle
  -- for the "cacfar" worker's "WSI" interface named "output"

  -- Record for the WSI input (OCP slave) signals for port "output" of worker "cacfar"
  type output_in_t is record
    SReset_n            : std_logic;
    SThreadBusy         : std_logic_vector(1-1 downto 0);
  end record output_in_t;

  -- Record for the WSI output (OCP master) signals for port "output" of worker "cacfar"
  type output_out_t is record
    MBurstLength        : std_logic_vector(2-1 downto 0);
    MByteEn             : std_logic_vector(ocpi_port_output_MByteEn_width-1 downto 0);
    MCmd                : ocpi.ocp.MCmd_t;
    MData               : std_logic_vector(ocpi_port_output_MData_width-1 downto 0);
    MDataInfo           : std_logic_vector(ocpi_port_output_MDataInfo_width-1 downto 0);
    MReqLast            : std_logic;
    MReset_n            : std_logic;
  end record output_out_t;

component cacfar_rv--__
  is
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
end component cacfar_rv--__
;


component cacfar--__
 is
  generic (
      SAMPLE_SIZE           : in   std_logic_vector((16)-1 downto 0) := from_UShort(to_ushort(512));
      SAMPLING_FREQUENCY    : in   std_logic_vector((16)-1 downto 0) := from_UShort(to_ushort(1024));
      NUM_TRAIN_CELLS       : in   std_logic_vector((16)-1 downto 0) := from_UShort(to_ushort(12));
      NUM_GUARD_CELLS       : in   std_logic_vector((16)-1 downto 0) := from_UShort(to_ushort(4));
      THRESHOLD_FACTOR      : in   std_logic_vector((16)-1 downto 0) := from_UShort(to_ushort(5));
      ocpi_debug            : in   std_logic_vector((1)-1 downto 0) := from_Bool(bfalse);
      ocpi_endian           : in   std_logic_vector((2)-1 downto 0) := std_logic_vector(to_unsigned(ocpi_endian_t'pos(little_e), 2));
      ocpi_version          : in   std_logic_vector((8)-1 downto 0) := from_UChar(to_uchar(2));
      ocpi_max_opcode_input : in   std_logic_vector((8)-1 downto 0) := from_UChar(to_uchar(0));
      ocpi_max_bytes_input  : in   std_logic_vector((32)-1 downto 0) := from_ULong(to_ulong(8192));
      ocpi_max_opcode_output: in   std_logic_vector((8)-1 downto 0) := from_UChar(to_uchar(0));
      ocpi_max_bytes_output : in   std_logic_vector((32)-1 downto 0) := from_ULong(to_ulong(8192));
      ocpi_max_latency_output : in   std_logic_vector((16)-1 downto 0) := from_UShort(to_ushort(256))
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
end component cacfar--__
;
end package cacfar_defs;
