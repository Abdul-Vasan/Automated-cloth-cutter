module counter_4b (C, CLR, CE, Q); 
input C, CLR, CE; 
output [3:0] Q; 
reg    [3:0] tmp; 
 
  always @(negedge C or negedge CLR) 
    begin 
      if (CLR) 
        tmp = 4'b0000; 
      else 
        if (CE) 
          tmp = tmp + 1'b1; 
    end 
  assign Q = tmp; 
endmodule 

module counter_2b (C, CLR,  CE, Q); 
input C, CLR, CE; 
output [1:0] Q; 
reg    [1:0] tmp; 
 
  always @(negedge C or negedge CLR) 
    begin 
      if (CLR) 
        tmp = 2'b00; 
      else 
        if (CE) 
          tmp = tmp + 1'b1; 
    end 
  assign Q = tmp; 
endmodule

module mux_411 (a, b, c, d, s, o); 
  input a,b,c,d; 
  input  [1:0] s; 
  output o; 
  reg    o; 
 
  always @(a or b or c or d or s) 
  begin 
      if (s == 2'b00) o = a; 
    else if (s == 2'b01) o = b; 
    else if (s == 2'b10) o = c; 
    else                 o = d; 
  end 
endmodule

module mux_414 (input [3:0] a,
                input [3:0] b,
                input [3:0] c,
                input [3:0] d, 
                input [1:0] s, 
                output [3:0]o); 
  reg    [3:0]o; 
 
  always @(a or b or c or d or s) 
  begin 
      if (s == 2'b00) o = a; 
    else if (s == 2'b01) o = b; 
    else if (s == 2'b10) o = c; 
    else                 o = d; 
  end
endmodule

module comparator(A, B, less, equal, greater);

    input [3:0] A;
    input [3:0] B;
    output less;
    output equal;
    output greater;
    reg less;
    reg equal;
    reg greater;

    always @(A or B)
     begin
        if(A > B)   
            begin  
                less = 0;
                equal = 0;
                greater = 1;    
            end
        else if(A == B) 
            begin 
                less = 0;
                equal = 1;
                greater = 0;    
            end
        else    
            begin 
                less = 1;
                equal = 0;
                greater =0;
            end 
    end
endmodule


module circ (output Y,
             input CLK,
             input [3:0]In1, 
             input [3:0]In2, 
             input [3:0]In3, 
             input [1:0]NoL, 
             input swi);

    reg [3:0]p = 4'b0000;
    reg q = 1'b1;
    wire w3, w4, w6, w7, w8, w9 ,w10, w11;
    wire [0:1] w1;
    wire [0:3] w2, w5;


    mux_414 m1 (In1, In2, In3, p, w1, w2);
    assign w3 = !swi;
    comparator com_1 (w2, w5, less, w4, greater);
    assign w9 = w3 | w4;
    counter_4b c1 (CLK, w9, swi, w5);
    assign w3 = !(w5[0] |w5[1] |w5[2]|w5[3]);
    assign Y = (w3 & CLK & swi);
    mux_411 m2 (q, q, w1[1], w10, NoL, w7);
    assign w10 = (w1[0] & w1[1]);                         
    assign w8 = (w3 & w7);
    counter_2b c2 (w3, w8, swi, w1);

endmodule

module testbench;

  wire g;
  reg [0:3] h;
  reg [0:3] i;
  reg [0:3] j;
  reg [0:1] k;
  reg l = 1;
  reg r;
    initial r=0;
    always #10 r = ~r;


  initial 
  begin 

    $dumpfile("circ2.vcd");
    $dumpvars(0, circ1);

    h = 4'b0001;
    i = 4'b0010;
    j = 4'b0011;
    k = 2'b11;
    
    

  end

  circ circ1 (g, r, h, i, j, k, l);

endmodule