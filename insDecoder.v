module insDecoder(ins,rs1,rs2,rd,imm,op_sel);
input [31:0]ins;	//Instruction - 32 Bit

output [4:0]rs1,rs2,rd;		//Source(1 and 2) and destination registers' addresses - 5 Bit each - Goes to RF
output reg [31:0]imm;		//Immediate value - 20Bit (can be 12 Bit or 5 Bit according to the Ins. type) - Goes to ALU
output reg [4:0]op_sel;		//Operation Select - 5 Bits - Goes to ALU 

wire [6:0]opcode;
wire [4:0]rd,rs1,rs2;
wire [2:0]funct3;
wire [6:0]funct7;

assign opcode = ins[6:0];	//opcode is the LSB seven bits of ins.
assign rd = ins[11:7];		//rd - 7th to 11th bits of ins.
assign rs1 = ins[19:15];	//rs1 - 15th to 19th bits of ins.
assign rs2 = ins[24:20];	//rs2 - 20th to 24th bits of ins.
assign funct3 = ins[14:12];	//funct3 - 12th to 14th bits of ins
assign funct7 = ins[31:25];	//funct3 - 31th to 25th bits of ins

always @(*) begin
	case(opcode)
		7'b0110011 : 	//R-Type
			case(funct7)
				7'b0000000 : 
					case(funct3)
						3'b000 : op_sel = 5'b00000;
						3'b111 : op_sel = 5'b00010;
						3'b110 : op_sel = 5'b00011;
						3'b100 : op_sel = 5'b00100;
						3'b001 : op_sel = 5'b00101;
						3'b101 : op_sel = 5'b00110;
						3'b010 : op_sel = 5'b01000;
						
					endcase
				7'b0100000 :  
					case(funct3)
						3'b000 : op_sel = 5'b00001;
						3'b101 : op_sel = 5'b00111;
						
					endcase

			endcase

		7'b0010011 : 	//I-Type
			case(funct3)
				3'b000 : begin op_sel = 5'b01001; imm = {{20{ins[31]}},ins[31:20]}; end //sign extending 20 Bits
				3'b111 : begin op_sel = 5'b01010; imm = {{20{ins[31]}},ins[31:20]}; end
				3'b110 : begin op_sel = 5'b01011; imm = {{20{ins[31]}},ins[31:20]}; end
				3'b100 : begin op_sel = 5'b01100; imm = {{20{ins[31]}},ins[31:20]}; end
				3'b001 : begin op_sel = 5'b01101; imm = {{20{ins[31]}},ins[31:20]}; end
				3'b101 : 
					case(funct7)
						7'b0000000 : begin op_sel = 5'b01110; imm = {{27{1'b0}},ins[24:20]}; end //sign extending 27 Bits
					 	7'b0100000 : begin op_sel = 5'b01111; imm = {{27{1'b0}},ins[24:20]}; end
					endcase
				3'b010 : begin op_sel = 5'b10000; imm = ins[24:20]; end
			endcase

		7'b1100011 : 	//B-Type
			case(funct3)
				3'b000 : begin op_sel = 5'b10001; imm = {{20{ins[31]}},ins[7],ins[30:25],ins[11:8],1'b0}; end //sign extending 20 Bits
				3'b001 : begin op_sel = 5'b10010; imm = {{20{ins[31]}},ins[7],ins[30:25],ins[11:8],1'b0}; end
				3'b100 : begin op_sel = 5'b10011; imm = {{20{ins[31]}},ins[7],ins[30:25],ins[11:8],1'b0}; end
				3'b101 : begin op_sel = 5'b10100; imm = {{20{ins[31]}},ins[7],ins[30:25],ins[11:8],1'b0}; end
			endcase

		7'b0110111  : 	//U-Type (LUI (Load Upper Immediate))
			begin op_sel = 5'b10101; imm = {ins[31:12],{12{1'b0}}}; end //sign extending 20 Bits and imm = (imm << 12)
		7'b0010111  : 	//U-Type (AUIPC (Add Upper Immediate to PC))
			begin op_sel = 5'b10110; imm = {ins[31:12],{12{1'b0}}}; end //imm = (imm << 12)

		7'b1101111  : 	//J-Type (JAL (Jump and Link))
			begin op_sel = 5'b10111; imm = {{12{ins[31]}},ins[19:12],ins[20],ins[30:25],ins[24:21],1'b0}; end //sign extending 12 Bits
		7'b1100111  : 	//J-Type (JALR (Jump and Link Register))
			begin op_sel = 5'b11000; imm = {{12{ins[31]}},ins[19:12],ins[20],ins[30:25],ins[24:21],1'b0}; end 
	endcase
end

endmodule