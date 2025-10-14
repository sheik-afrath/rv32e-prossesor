module rv32e_single_cycle (
    input  wire        clk,
    input  wire        rst
);

  // --- wires between stages ---
  wire [31:0] pc,        // current PC
              instr,     // fetched instruction
              imm,       // sign or zero extended immediate
              rs1_data,  // read port 1
              rs2_data,  // read port 2
              alu_out,   // ALU result / write back data
              pc_branch; // target PC from ALU for branches/jumps

  wire [4:0]  rs1, rs2, rd, op_sel;
  wire        branch_taken;
  wire        reg_write;

  // --- program counter ---
  pc U_PC (
    .clk(clk),
    .rst(rst),
    .branch_taken(branch_taken),
    .pc_alu(pc_branch),
    .pc(pc)
  );

  // --- instruction memory (fetch) ---
  imem U_IMEM (
    .addr(pc),
    .ins(instr)
  );

  // --- instruction decoder / control ---
  insDecoder U_DEC (
    .ins(instr),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .imm(imm),
    .op_sel(op_sel)
  );

  wire [6:0] opcode = instr[6:0];
  assign reg_write = 
         (opcode==7'b0110011)  // R?type
      || (opcode==7'b0010011)  // I?type ALU
      || (opcode==7'b0110111)  // LUI
      || (opcode==7'b0010111)  // AUIPC
      || (opcode==7'b1101111)  // JAL
      || (opcode==7'b1100111); // JALR

  // --- register file (read + write back) ---
  rf U_RF (
    .reg_write(reg_write),
    .clk(clk),
    .rst(rst),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .rd_data(alu_out),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
  );

  // --- ALU + branch/jump logic ---
  ALU U_ALU (
    .op_sel(op_sel),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .imm(imm),
    .rd_data(alu_out),
    .branch_taken(branch_taken),
    .pc(pc),
    .pc_out(pc_branch)
  );

endmodule

