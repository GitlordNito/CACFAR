// THIS FILE WAS GENERATED ON Thu Jun 23 15:27:28 2022 BST
// BASED ON THE FILE: cacfar.xml
// YOU PROBABLY SHOULD NOT EDIT IT
// This file contains the Verilog declarations for the worker with
//  spec name "local.cacfar.cacfar.hdl.cacfar" and implementation name "cacfar".
// It is needed for instantiating the worker.
// Interface signal names are defined with pattern rule: "%s_"

`ifndef NOT_EMPTY_cacfar
(* box_type="user_black_box" *)
`endif
module cacfar//__
(

  // The WCI interface named "ctl", with "cacfar" acting as OCP slave:
  //   Clock: this interface has its own input clock, named "ctl_Clk"
  // WIP attributes for this WCI interface are:
  //   SizeOfConfigSpace: 20 (0x14)
  //   WritableConfigProperties: true
  //   ReadableConfigProperties: true
  //   Sub32BitConfigProperties: true
  //   ControlOperations (in addition to the required "start"): ,stop
  //   ResetWhileSuspended: false
  ctl_Clk,                // input
  ctl_MAddr,              // input [  4:0]
  ctl_MAddrSpace,         // input [  0:0]
  ctl_MByteEn,            // input [  3:0]
  ctl_MCmd,               // input [  2:0]
  ctl_MData,              // input [ 31:0]
  ctl_MFlag,              // input [  1:0]
  ctl_MReset_n,           // input
  ctl_SData,              // output [ 31:0]
  ctl_SFlag,              // output [  2:0]
  ctl_SResp,              // output [  1:0]
  ctl_SThreadBusy,        // output [  0:0]

  // The WSI interface named "input", with "cacfar" acting as OCP slave:
  //   Clock: this interface uses the worker's clock named "ctl_Clk"
  // WIP attributes for this WSI interface are:
 //  This interface is a data interface acting as consumer
  //   Protocol: "iqstream"
  //   DataValueWidth: 16
  //   DataValueGranularity: 2
  //   DiverseDataSizes: false
  //   MaxMessageValues: 4096
  //   VariableMessageLength: true
  //   ZeroLengthMessages: true
  //   MinMessageValues: 0
  //   Unbounded: false
  //   NumberOfOpcodes: 1
  //   DefaultBufferSize: 8192
  //   Producer: false
  //   Continuous: false
  //   DataWidth: 32
  //   ByteWidth: 32
  //   ImpreciseBurst: true
  //   Preciseburst: false
  //   Abortable: false
  //   EarlyRequest: false
  //   RegRequest: false
  // No Clk signal here. The "input" interface uses "ctl_Clk" as clock
  input_MBurstLength,     // input [  1:0]
  input_MByteEn,          // input [  0:0]
  input_MCmd,             // input [  2:0]
  input_MData,            // input [ 31:0]
  input_MDataInfo,        // input [  0:0]
  input_MReqLast,         // input
  input_MReset_n,         // input
  input_SReset_n,         // output
  input_SThreadBusy,      // output [  0:0]

  // The WSI interface named "output", with "cacfar" acting as OCP master:
  //   Clock: this interface uses the worker's clock named "ctl_Clk"
  // WIP attributes for this WSI interface are:
 //  This interface is a data interface acting as producer
  //   Protocol: "iqstream"
  //   DataValueWidth: 16
  //   DataValueGranularity: 2
  //   DiverseDataSizes: false
  //   MaxMessageValues: 4096
  //   VariableMessageLength: true
  //   ZeroLengthMessages: true
  //   MinMessageValues: 0
  //   Unbounded: false
  //   NumberOfOpcodes: 1
  //   DefaultBufferSize: 8192
  //   Producer: true
  //   Continuous: false
  //   DataWidth: 32
  //   ByteWidth: 32
  //   ImpreciseBurst: true
  //   Preciseburst: false
  //   Abortable: false
  //   EarlyRequest: false
  //   RegRequest: false
  // No Clk signal here. The "output" interface uses "ctl_Clk" as clock
  output_SReset_n,        // input
  output_SThreadBusy,     // input [  0:0]
  output_MBurstLength,    // output [  1:0]
  output_MByteEn,         // output [  0:0]
  output_MCmd,            // output [  2:0]
  output_MData,           // output [ 31:0]
  output_MDataInfo,       // output [  0:0]
  output_MReqLast,        // output
  output_MReset_n        // output
);
// This file sets values for constants that may be affected by parameter values
  parameter [15:0] SAMPLE_SIZE  = 16'h0200;
  parameter [15:0] SAMPLING_FREQUENCY  = 16'h0400;
  parameter [15:0] NUM_TRAIN_CELLS  = 16'h000c;
  parameter [15:0] NUM_GUARD_CELLS  = 16'h0004;
  parameter [15:0] THRESHOLD_FACTOR  = 16'h0005;
  parameter [0:0] ocpi_debug  = 1'b0;
  parameter [1:0] ocpi_endian  = 2'b00;
  parameter [7:0] ocpi_version  = 8'h02;
  parameter [7:0] ocpi_max_opcode_input  = 8'h00;
  parameter [31:0] ocpi_max_bytes_input  = 32'h00002000;
  parameter [7:0] ocpi_max_opcode_output  = 8'h00;
  parameter [31:0] ocpi_max_bytes_output  = 32'h00002000;
  parameter [15:0] ocpi_max_latency_output  = 16'h0100;
  localparam ocpi_buffer_size_output_offset = 0;
  localparam ocpi_buffer_size_output_nbytes_1 = 1;
  localparam ocpi_blocked_output_offset = 4;
  localparam ocpi_blocked_output_nbytes_1 = 3;
  localparam ocpi_latency_output_offset = 8;
  localparam ocpi_latency_output_nbytes_1 = 1;
  localparam ocpi_messages_output_offset = 12;
  localparam ocpi_messages_output_nbytes_1 = 3;
  localparam ocpi_bytes_output_offset = 16;
  localparam ocpi_bytes_output_nbytes_1 = 3;
  localparam ocpi_sizeof_non_raw_properties = 20;
localparam ocpi_port_ctl_MAddr_width = 5;
localparam ocpi_port_ctl_MData_width = 32;
localparam ocpi_port_ctl_MByteEn_width = 4;
localparam ocpi_port_input_MData_width = 32;
localparam ocpi_port_input_MByteEn_width = 1;
localparam ocpi_port_input_MDataInfo_width = 1;
localparam ocpi_port_input_data_width = 32;
localparam ocpi_port_input_byte_width = 32;
localparam ocpi_port_output_MData_width = 32;
localparam ocpi_port_output_MByteEn_width = 1;
localparam ocpi_port_output_MDataInfo_width = 1;
localparam ocpi_port_output_data_width = 32;
localparam ocpi_port_output_byte_width = 32;

  input            ctl_Clk;
  input  [ocpi_port_ctl_MAddr_width-1:0] ctl_MAddr;
  input  [  1-1:0] ctl_MAddrSpace;
  input  [ocpi_port_ctl_MByteEn_width-1:0] ctl_MByteEn;
  input  [  3-1:0] ctl_MCmd;
  input  [ocpi_port_ctl_MData_width-1:0] ctl_MData;
  input  [  2-1:0] ctl_MFlag;
  input            ctl_MReset_n;
  output [ 32-1:0] ctl_SData;
  output [  3-1:0] ctl_SFlag;
  output [  2-1:0] ctl_SResp;
  output [  1-1:0] ctl_SThreadBusy;
  input  [  2-1:0] input_MBurstLength;
  input  [ocpi_port_input_MByteEn_width-1:0] input_MByteEn;
  input  [  3-1:0] input_MCmd;
  input  [ocpi_port_input_MData_width-1:0] input_MData;
  input  [ocpi_port_input_MDataInfo_width-1:0] input_MDataInfo;
  input            input_MReqLast;
  input            input_MReset_n;
  output           input_SReset_n;
  output [  1-1:0] input_SThreadBusy;
  input            output_SReset_n;
  input  [  1-1:0] output_SThreadBusy;
  output [  2-1:0] output_MBurstLength;
  output [ocpi_port_output_MByteEn_width-1:0] output_MByteEn;
  output [  3-1:0] output_MCmd;
  output [ocpi_port_output_MData_width-1:0] output_MData;
  output [ocpi_port_output_MDataInfo_width-1:0] output_MDataInfo;
  output           output_MReqLast;
  output           output_MReset_n;

// NOT_EMPTY_cacfar is defined before including this file when implementing
// the cacfar worker.  Otherwise, this file is a complete empty definition.
`ifndef NOT_EMPTY_cacfar
endmodule
`endif
