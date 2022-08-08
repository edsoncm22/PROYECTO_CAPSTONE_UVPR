module PD #(
	parameter n1=16,
	          n2=16,
           	nH=31,
	          nL=0
	)
	(
	input  rst,
	input  clk,
	input  stp,
	input  [n2-1:0] b0,b1,
	input  [n1-1:0] e_k,
	output [nH-nL:0] u_k,
	output eop
	);

	wire rst_acc;
	wire ha,hr,igual,sel;

	wire [n1-1:0] ek;
	wire [n1-1:0] e_1;
	wire [n2-1:0] bk;
	wire [n1+n2-1:0] uk,u;

	assign u_k = uk[nH:nL];

	FSM_FILTER_PD                         C0(rst,clk,stp,igual,sel,ha,hr,rst_acc,eop);
	REGISTRO_PARALELO_HOLD    #(n1)       C1(rst,clk,hr,e_k,e_1);

	assign ek = (sel) ? e_1 : e_k;
	assign bk = (sel) ? b1 : b0;

	// multiplicador de ice40 y icestorm
	
	MULTIPLICADOR             #(n1,n2) C6(ek,bk,m);
	SUMADOR	                  #(n1+n2) C7(m,u,s);
	REGISTRO_PARALELO_HOLD    #(n1+n2) C8(rst | rst_acc,clk,ha,s,u);
	REGISTRO_PARALELO_HOLD    #(n1+n2) C10(rst,clk,hr,u,uk);


endmodule
