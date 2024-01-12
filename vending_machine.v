module vending_machine
               (
                 input i_clock,
                 input i_resetn,
                 input [1:0] i_select,
                 input [6:0] i_money_in,
                 output reg  o_dispense,
                 output reg  [6:0] o_change  
                ) ;
                
reg [6:0] r_price;
reg [6:0] r_totmoney;

reg [1:0] n_state;
reg [1:0] p_state;

parameter item1 = 30 ;
parameter item2 = 40 ;
parameter item3 = 50 ;

parameter start = 2'b00 ;
parameter next1  = 2'b01 ;
parameter next2 = 2'b10 ;

always@(posedge i_clock or posedge i_resetn)
begin
    if(!i_resetn == 1'b1)
    p_state<=0;
    else
    p_state<=n_state;
end

always @(*)
begin
    case(p_state)
    start : 
    begin
    n_state=start;
    o_change=0;
    r_totmoney=0;
    o_dispense=0;
    if(i_select !== 2'b00)
    begin
    if(i_select == 2'b01)
    r_price = item1;
    else if(i_select == 2'b10)
    r_price = item2;
    else if(i_select == 2'b11)
    r_price = item3;
    else 
    r_price=0;
    n_state=next1;
    end
    end
    next1 :
    begin
        if(i_money_in!=7'b0000000)
        begin
            r_totmoney=i_money_in;
            n_state=next2;
        end
    end
    next2 :
    begin
        if(r_totmoney >= r_price)
        begin
            o_dispense = 1;
            o_change = r_totmoney - r_price;
            r_totmoney = 0;
            n_state = start;
        end
        else
        n_state = next1;
    end
    endcase
end
endmodule