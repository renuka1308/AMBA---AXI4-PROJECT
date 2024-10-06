//AXI4 - Master 

module axi4_master (
  input clk,
  input reset_n,
  
  //Write address channnel
  output reg [31:0] awaddr,  // Write address output (32 bits)
  output reg awvalid,        // Write address valid signal
  input awready,             // Slave ready to accept write address
  
  //Write data channel
  output reg [31:0] wdata,
  output reg wvalid,
  input wready,
  
  //Write response channel
  input bvalid,
  output reg bready,
  
  //Read address channel
  output reg [31:0] araddr,
  output reg arvalid,
  input arready,
  
  //Read data channel
  input [31:0] rdata,
  input rvalid,
  output reg rready
);
  
  //FSM STATES
  reg [2:0] state; // Stores the current state (3 bit)
  
  localparam IDLE = 3'd0, // IDLE state, no operation happening (000)
  WRITE_ADDR = 3'd1, //Write address (001)
  WRITE_DATA = 3'd2, //Write data (010)
  WRITE_RESP = 3'd3, //Write response(011)
  READ_ADDR = 3'd4, //Read address(100)
  READ_DATA = 3'd5; //Read data(101)
  
  always @(posedge clk or negedge reset_n) begin
    // On reset, set everything to initial state
    if (!reset_n) begin
      state <= IDLE;
      awvalid <= 0;
      wvalid <= 0;
      bready <= 0;
      arvalid <= 0;
      rready <= 0;
    end else begin
      case (state)
        IDLE : begin
          awaddr <= 32'h0000_0000;
          awvalid <= 1;
          state <= WRITE_ADDR;
        end
        
        WRITE_ADDR : begin
          if(awready) begin
            awvalid <= 0;
            wdata <= 32'h1234_5678;
            wvalid <= 1;
            state <= WRITE_DATA;
          end
        end
        
        WRITE_DATA : begin
          if(wready) begin
            wvalid <= 0;
            bready <= 1;
            state <= WRITE_RESP;
          end
        end
        
        WRITE_RESP : begin
          if (bvalid) begin
            bready <= 0;
            state <= READ_ADDR;
          end
        end
        
        READ_ADDR : begin
          araddr <= 32'h4321_1234;
          arvalid <= 1;
          state <= READ_DATA;
        end
        
        READ_DATA : begin
          if (arready) begin
            arvalid <= 0;
            if (rvalid) begin
              rready <= 1;
              state <= IDLE;
            end
          end
        end
      endcase
    end
  end
      
endmodule