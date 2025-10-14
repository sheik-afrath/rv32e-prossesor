module imem(addr,ins);
input [31:0]addr;
output reg [31:0]ins;

reg [31:0] rom [0:15];

initial begin
  rom[0]  = 32'h00000013; // nop               ; (addi x0, x0, 0)
  rom[1]  = 32'h00500193; // addi x3, x0, 5    ; x3 = 5
  rom[2]  = 32'h00318233; // add  x4, x3, x3   ; x4 = x3 + x3 = 10
  rom[3]  = 32'h0041A2B3; // slt  x5, x3, x4   ; x5 = (5 < 10) ? 1 : 0
  rom[4]  = 32'h00B22313; // slti x6, x4, 11   ; x6 = (10 < 11)? 1 : 0
  rom[5]  = 32'h00231393; // slli x7, x6, 2    ; x7 = x6 << 1
  rom[6]  = 32'h0013D413; // srli x8, x7, 1    ; x8 = x7 >> 1 (logical)
  rom[7]  = 32'h40145493; // srai x9, x8, 1    ; x9 = x8 >> 1 (arith)
  rom[8]  = 32'h00748663; // beq x9, x7, 12    ; if(x9 == x7), pc = pc + 12
  rom[9]  = 32'h00527313; // andi x6,x4,5      ; x6 = x4 & 5
  rom[10] = 32'hFE82C6E3; // blt x5,x8,-20     ; if(x5 < x8), pc = pc - 20
  rom[11] = 32'h12345537; // lui  x10,0x12345  ; x10 = 0x12345_000
  rom[12] = 32'h00010597; // auipc x11,0x10    ; x11 = PC + 0x10_000
  rom[13] = 32'h0000006F; // jal  x0, 0        ; infinite loop (jump to self)
end
always @(*) begin
    ins = rom[ addr[5:2] ];  // drop low two bits, use 4?bit index
end
endmodule