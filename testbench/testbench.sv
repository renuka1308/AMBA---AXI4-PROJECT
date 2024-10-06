module axi4_tb;

  // Testbench signals
  reg clk;
  reg reset_n;

  // Master-Slave interface signals
  wire [31:0] awaddr;
  wire awvalid;
  wire awready; 
  wire [31:0] wdata;
  wire wvalid;
  wire wready; 
  reg bvalid;
  wire bready;
  wire [31:0] araddr;
  wire arvalid;
  wire arready; 
  reg [31:0] rdata;
  reg rvalid;
  wire rready;

  // Instantiate the AXI4 top module
  axi4_top_module dut (
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

   // Clock generation
  always #5 clk = ~clk;  // 10ns clock period
  
  // Initializing signals
  initial begin
    $dumpfile("axi4_top_module.vcd");
    $dumpvars(0, axi4_tb);
    clk = 0;
    reset_n = 0;
    bvalid = 0;
    rdata = 0;
    rvalid = 0;

    // Apply reset
    #10 reset_n = 1;

    // Write transaction
    #10 bvalid = 1;       // Response valid
    #10 bvalid = 0;       // Response sent

    // Read transaction
    #20; // Wait for the arready signal from the DUT
    #10; // Additional delays for synchronization
    #10 rdata = 32'h1234_5678; // Data for read operation
    rvalid = 1;           // Read data valid
    #10 rvalid = 0;       // Data sent to master

    // Finish simulation
    #100 $finish;
  end

endmodule
