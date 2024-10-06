//AXI4_SLAVE

module axi4_slave(
  input clk,
  input reset_n,
  
  //Write address channel
  input [31:0] awaddr, 
  input awvalid, 
  output reg awready, 
  
  // Write Data Channel
  input [31:0] wdata,
  input wvalid,
  output reg wready,
  
  // Write Response Channel
  output reg bvalid,
  input wire bready,
  
  // Read Address Channel
  input [31:0] araddr,
  input arvalid,
  output reg arready,
  
  // Read Data Channel
  output reg [31:0] rdata,
  output reg rvalid,
  input rready
);
  
  reg [31:0] memory [0:255]; //Memory array
  
  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        awready <= 0;
        wready <= 0;
        bvalid <= 0;
        arready <= 0;
        rvalid <= 0;
    end else begin 
      
      // Write Address Handling
            if (awvalid && !awready) begin
                awready <= 1;
            end else begin
                awready <= 0;
            end

            // Write Data Handling
            if (wvalid && !wready) begin
                wready <= 1;
                memory[awaddr] <= wdata; // Store data in memory
                bvalid <= 1;
            end else if (bready && bvalid) begin
                bvalid <= 0;
            end

            // Read Address Handling
            if (arvalid && !arready) begin
                arready <= 1;
                rdata <= memory[araddr]; // Read data from memory
                rvalid <= 1;
            end else if (rready && rvalid) begin
                rvalid <= 0;
            end
        end
    end
endmodule
