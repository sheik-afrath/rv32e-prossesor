`timescale 1ns/1ps

module tb_rv32e;
  // clock & reset
  reg        clk;
  reg        rst;
  integer    i;

  // fields for decoding
  reg [31:0] instr;
  reg [6:0]  opcode;
  reg [2:0]  funct3;
  reg [6:0]  funct7;
  reg [4:0]  rd, rs1, rs2;
  reg signed [31:0] imm_i, imm_u, imm_b, imm_j;

  // instantiate your CPU
  rv32e_single_cycle uut (
    .clk(clk),
    .rst(rst)
  );

  // 100?MHz clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // reset for one cycle
  initial begin
    rst = 1;
    #10;
    rst = 0;
  end

  // on each rising edge, decode & print
  always @(posedge clk) begin
    // grab raw bits
    instr  = uut.U_IMEM.ins;
    opcode = instr[6:0];
    rd     = instr[11:7];
    rs1    = instr[19:15];
    rs2    = instr[24:20];
    funct3 = instr[14:12];
    funct7 = instr[31:25];

    // build immediates
    imm_i = $signed(instr[31:20]);                              // I?type
    imm_u = {instr[31:12], 12'b0};                               // U?type
    imm_b = $signed({instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}); // B?type
    imm_j = $signed({instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}); // J?type

    // print registers in decimal
    $display("  Registers (decimal):");
    for (i = 0; i < 16; i = i+1) begin
      $display("    x%0d = %0d", i, uut.U_RF.x[i]);
    end
    $display("");

    // print PC
    $display("Time %0t ns", $time);
    $display("  PC    = %0d", uut.U_PC.pc);
    $display("Next Instruction: ");
    // decode & print mnemonic
    case (opcode)
      7'b0010011: // I?type ALU
        case (funct3)
          3'b000: $display("  ADDI x%0d, x%0d, %0d", rd, rs1, imm_i);
          3'b111: $display("  ANDI x%0d, x%0d, %0d", rd, rs1, imm_i);
          3'b110: $display("  ORI  x%0d, x%0d, %0d", rd, rs1, imm_i);
          3'b100: $display("  XORI x%0d, x%0d, %0d", rd, rs1, imm_i);
          3'b001: $display("  SLLI x%0d, x%0d, %0d", rd, rs1, imm_i[4:0]);
          3'b101:
            if (funct7==7'b0000000) $display("  SRLI x%0d, x%0d, %0d", rd, rs1, imm_i[4:0]);
            else                   $display("  SRAI x%0d, x%0d, %0d", rd, rs1, imm_i[4:0]);
          3'b010: $display("  SLTI x%0d, x%0d, %0d", rd, rs1, imm_i);
          default: $display("  UNKNOWN I?TYPE 0x%08h", instr);
        endcase

      7'b0110011: // R?type
        case ({funct7,funct3})
          10'b0000000_000: $display("  ADD  x%0d, x%0d, x%0d", rd, rs1, rs2);
          10'b0100000_000: $display("  SUB  x%0d, x%0d, x%0d", rd, rs1, rs2);
          10'b0000000_111: $display("  AND  x%0d, x%0d, x%0d", rd, rs1, rs2);
          10'b0000000_110: $display("  OR   x%0d, x%0d, x%0d", rd, rs1, rs2);
          10'b0000000_100: $display("  XOR  x%0d, x%0d, x%0d", rd, rs1, rs2);
          10'b0000000_001: $display("  SLL  x%0d, x%0d, x%0d", rd, rs1, rs2);
          10'b0000000_101: $display("  SRL  x%0d, x%0d, x%0d", rd, rs1, rs2);
          10'b0100000_101: $display("  SRA  x%0d, x%0d, x%0d", rd, rs1, rs2);
          10'b0000000_010: $display("  SLT  x%0d, x%0d, x%0d", rd, rs1, rs2);
          default:          $display("  UNKNOWN R?TYPE 0x%08h", instr);
        endcase

      7'b0110111: // LUI
        $display("  LUI  x%0d, %0d", rd, imm_u >>> 12);
      7'b0010111: // AUIPC
        $display("  AUIPC x%0d, %0d", rd, imm_u >>> 12);

      7'b1101111: // JAL
        $display("  JAL  x%0d, %0d", rd, imm_j);
      7'b1100111: // JALR
        $display("  JALR x%0d, x%0d, %0d", rd, rs1, imm_i);

      7'b1100011: // B?type
        case (funct3)
          3'b000: $display("  BEQ  x%0d, x%0d, %0d", rs1, rs2, imm_b);
          3'b001: $display("  BNE  x%0d, x%0d, %0d", rs1, rs2, imm_b);
          3'b100: $display("  BLT  x%0d, x%0d, %0d", rs1, rs2, imm_b);
          3'b101: $display("  BGE  x%0d, x%0d, %0d", rs1, rs2, imm_b);
          default:$display("  UNKNOWN B?TYPE 0x%08h", instr);
        endcase
      default:
        $display("  ILLEGAL/UNSUPPORTED OPCODE 0x%02h", opcode);
    endcase
  end
endmodule

