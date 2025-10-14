module rf(reg_write,clk,rst,rd,rs1,rs2,rd_data,rs1_data,rs2_data);
input clk,rst,reg_write;
input [4:0]rd,rs1,rs2; //rd is input address & rs1,rs2 is output address
input [31:0]rd_data; //data to be written back
output wire [31:0]rs1_data,rs2_data; //data to be read
reg [31:0] x[15:0];
integer i;
always@(posedge clk or posedge rst) begin
	if(rst) begin
		for (i=0;i<16;i=i+1) begin
			x[i] = 32'b0; //Make everything Zero if rst = 1
			end
		end
//if reg_write = 0 --> read operation
//if reg_write = 1 --> write operation
	else if(reg_write && rd != 0) begin 
		x[rd] <= rd_data; //to make sure x0 is not written
	end
end

assign rs1_data = (rs1 == 5'b0) ? 32'b0 : x[rs1]; //x0 hardwired to zero
assign rs2_data = (rs2 == 5'b0) ? 32'b0 : x[rs2];
endmodule
