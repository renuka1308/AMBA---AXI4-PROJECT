//AMBA PROTOCOL - AXI4
//This is the top-level module

`include "axi4_master.v"
`include "axi4_slave.v"

module axi4_top_module(
  
  input clk, // Clock signal
  input reset_n, // Active-low reset signal
  
  //Master-Slave interface
  
  //Write address channnel
  input [31:0] awaddr, // Write address from Master to Slave (32 bits)
  input awvalid, // Indicates valid write address
  output awready,  // Slave ready to accept write address
  
  //Write data channel
  input [31:0] wdata,
  input wvalid,
  output wready,
  
  // Write Response Channel
  input bvalid,
  output bready,
  
  // Read Address Channel
  input [31:0] araddr,
  input arvalid,
  output arready,
  
  // Read Data Channel
  input [31:0] rdata,
  input rvalid,
  output rready
  
);
  // Instantiate Master
    axi4_master master (
        .clk(clk),
        .reset_n(reset_n),
      
        .awaddr(awaddr),
        .awvalid(awvalid),
        .awready(awready),
      
        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),
      
        .bvalid(bvalid),
        .bready(bready),
      
        .araddr(araddr),
        .arvalid(arvalid),
        .arready(arready),
      
        .rdata(rdata),
        .rvalid(rvalid),
        .rready(rready)
    );

    // Instantiate Slave
    axi4_slave slave (
        .clk(clk),
        .reset_n(reset_n),
      
        .awaddr(awaddr),
        .awvalid(awvalid),
        .awready(awready),
      
        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),
      
        .bvalid(bvalid),
        .bready(bready),
      
        .araddr(araddr),
        .arvalid(arvalid),
        .arready(arready),
      
        .rdata(rdata),
        .rvalid(rvalid),
        .rready(rready)
    );
  
endmodule





