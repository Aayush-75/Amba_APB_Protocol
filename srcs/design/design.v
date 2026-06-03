module apb_master#(parameter SLAVE_NO=2)(
    input PCLK,PRESETn,transfer,READ_WRITE,
    input [$clog2(SLAVE_NO)+7:0]apb_write_paddress,apb_read_paddress,
    input [7:0]apb_write_data,
    input PREADY,
    input [7:0]PRDATA,
    output reg PENABLE,PWRITE,
    output reg [7:0]PWDATA,PADDR,apb_read_data_out,
    output reg [$clog2(SLAVE_NO)-1:0]PSEL
    );
    
    reg [1:0]state;
    
    localparam sIDLE = 2'd0,
               sSETUP = 2'd1,
               sACCESS = 2'd2;
    
    always@(posedge PCLK or negedge PRESETn)
    begin
      if(!PRESETn)
        begin
            state <= sIDLE;
        end
        
      else
        begin
            if(state==sIDLE && transfer)
                begin
                    state <= sSETUP;
                end
            if(state==sSETUP)
                begin
                    state <= sACCESS;
                end
            if(state== sACCESS)
                begin
                    if(PREADY)
                        begin
                            if(transfer)
                                begin
                                    state <= sSETUP;
                                end
                             else
                                begin
                                    state <= sIDLE;
                                end
                        end
                    else
                        begin
                            state <= sACCESS;
                        end
                end
        end 
    end
    
    always@(*)
        begin
            case(state)
                sIDLE: 
                    begin
                        PENABLE = 0;
                        PSEL = 0;
                    end
                sSETUP:
                    begin
                        PWRITE = ~READ_WRITE;
                        if(PWRITE)
                            begin
                                PWDATA = apb_write_data;
                                PADDR = apb_write_paddress[7:0];
                                PSEL = apb_write_paddress[$clog2(SLAVE_NO)+7:8];
                            end
                        else
                            begin
                                PADDR = apb_read_paddress[7:0];
                                PSEL = apb_read_paddress[$clog2(SLAVE_NO)+7:8];
                            end
                    end
                sACCESS:
                    begin
                        PENABLE = 1;
                        if(!PWRITE)
                            begin
                                apb_read_data_out = PRDATA;
                            end
                    end
            endcase
        end
endmodule
