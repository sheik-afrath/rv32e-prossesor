module pc(clk, rst, branch_taken, pc_alu, pc);
input clk, rst, branch_taken;
input [31:0] pc_alu;
output reg [31:0] pc;

always@(posedge clk or posedge rst) begin
	if(rst) begin
		pc <= 32'b0;
	end
	else begin
		if (branch_taken) 
			pc <= pc_alu; //goes to alu's pc_out if branch conditions is true
		else 
			pc <= pc + 4; //32 bits = 4 bytes
	end
end
endmodule

