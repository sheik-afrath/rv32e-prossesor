module ALU(op_sel,rs1_data,rs2_data,imm,rd_data,branch_taken,pc,pc_out);
input  [4:0]op_sel;
input [31:0]imm,rs1_data,rs2_data,pc;
output reg [31:0]rd_data,pc_out;
output reg branch_taken;


always@(*) begin
rd_data       = 32'd0;
pc_out        = 32'd0;
branch_taken  = 1'b0;
case (op_sel)
	//R-TYPE
	5'b00000 : 
		rd_data = rs1_data + rs2_data; //ADD rd,rs1,rs2
	5'b00001 : 
		rd_data = rs1_data - rs2_data; //SUB rd,rs1,rs2
	5'b00010 : 
		rd_data = rs1_data & rs2_data; //AND rd,rs1,rs2
	5'b00011 : 
		rd_data = rs1_data | rs2_data; //OR rd,rs1,rs2
	5'b00100 : 
		rd_data = rs1_data ^ rs2_data; //XOR rd,rs1,rs2
	5'b00101 : 
		rd_data = rs1_data << rs2_data[4:0]; //SLL rd,rs1,rs2
	5'b00110 : 
		rd_data = rs1_data >> rs2_data[4:0]; //SRL rd,rs1,rs2
	5'b00111 : 
		rd_data = $signed(rs1_data) >>> rs2_data[4:0]; //SRA rd,rs1,rs2
	5'b01000 : 
		rd_data = ($signed(rs1_data) < $signed(rs2_data)) ? 32'd1 : 32'd0; //SLT rd,rs1,rs2
	//I-TYPE
	5'b01001 : 
		rd_data = rs1_data + imm; //ADDI rd,rs1,imm
	5'b01010 : 
		rd_data = rs1_data & imm; //ANDI rd,rs1,imm
	5'b01011 : 
		rd_data = rs1_data | imm; //ORI rd,rs1,imm
	5'b01100 : 
		rd_data = rs1_data ^ imm; //XORI rd,rs1,imm
	5'b01101 : 
		rd_data = rs1_data << imm[4:0]; //SLLI rd,rs1,imm
	5'b01110 : 
		rd_data = rs1_data >> imm[4:0]; //SRLI rd,rs1,imm
	5'b01111 : 
		rd_data = $signed(rs1_data) >>> imm[4:0]; //SLRAI rd,rs1,imm
	5'b10000 : 
		rd_data = ($signed(rs1_data)) < ($signed(imm)) ? 32'd1 : 32'd0; //SLTI rd,rs1,rs2
	//B-TYPE
	5'b10001 : begin
		if(rs1_data == rs2_data) begin
		branch_taken = 1; 		// BEQ
		pc_out = pc + imm;
		end
	end
	5'b10010 : begin
		if(rs1_data != rs2_data) begin
		branch_taken = 1; 		// BNE
		pc_out = pc + imm;
		end
	end
	5'b10011 : begin
		if($signed(rs1_data) < $signed(rs2_data)) begin
		branch_taken = 1; 		// BLT
		pc_out = pc + imm;
		end
	end
	5'b10100 : begin
		if($signed(rs1_data) >= $signed(rs2_data)) begin
		branch_taken = 1; 		// BGE
		pc_out = pc + imm;
		end
	end
	//U-TYPE
	5'b10101 : 
		rd_data = imm; 		//LUI rd,imm	//(imm << 12) is already done in control unit
	5'b10110 : 
		rd_data = pc + imm; 	//AUIPC rd,imm	//(imm << 12) is already done in control unit
	//J-TYPE
	5'b10111 : begin
		rd_data = pc + 4;  		//JAL
		branch_taken = 1'b1;
		pc_out = (pc + imm);
		end
	5'b11000 : begin
		rd_data 	= pc + 4; 	//JALR
		branch_taken 	= 1'b1;
		pc_out 		= (rs1_data + imm) & ~32'h3;
		end
	default : begin
		end
	endcase
end
endmodule
