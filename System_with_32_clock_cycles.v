module DCS(
input clk , start , d,
  input [47:0] fec_in,
  output [15:0] CRC_out,

  output  done_fec,
  output [95:0] final_ans
);
  wire [95:0] fec_out;
  
  CRC C(d , clk , start , CRC_out);
  FEC F(clk, start ,fec_in , fec_out,done_fec)
  
   
  
endmodule


module CRC(
input data , clk , start,
  output reg [15:0] r
);
  integer count;
  always @(posedge clk ,start)
    begin
      if(start)begin
        r = 16'hFFFF;
        count = 32;
      end
      else if(count != 0)
        begin
          r[0] <=  data + r[15];
          r[1] <=  r[0];
          r[2] <= r[1] + (data + r[15]);
          r[3] <= r[2];
          r[4] <= r[3];
          r[5] <= r[4];
          r[6] <= r[5];
          r[7] <= r[6];
          r[8] <= r[7];
          r[9] <= r[8];
          r[10] <= r[9];
          r[11] <= r[10];
          r[12] <= r[11];
          r[13] <= r[12];
          r[14] <= r[13];
          r[15] <= r[14]+(data+r[15]);
          count <= count -1;
          
        end
    end
endmodule




module FEC(
input clk,reset,
  input [47:0]q,
  output reg [95:0] fec,
  output reg done
);
  reg [3:0] D; integer count,i;
  reg [47:0] P1,P0;
  always @(posedge clk ,reset)
   begin
      if(reset == 1)
         begin
         D <= 4'b0000;
           count = 48;
         end
            else
               #325 begin
                for(i = 47 ; i>=0 ; i = i-1)
                  begin
                    P0[count] = D[3]^D[2]^D[1]^D[0];
                    P1[count] = D[3]^D[1]^D[0];
                    fec = {fec[93:0],P1[count],P0[count]};
                    D = {q[i],D[3:1]};
                    count = count -1;
                    done = 0;
                  end
                P0[0] = 1'b0^D[2]^D[1]^D[0];
                P1[0] = 1'b0^D[1]^D[0];
                fec = {fec[93:0],P1[0],P0[0]};
                count = count -1;
                done = 1;
              end
          end
endmodule






  




