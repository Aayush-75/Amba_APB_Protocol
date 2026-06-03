module apb_slv1(
        input SLV_PSEL1,
        input PENABLE,PWRITE,
        input [7:0]PWDATA,PADDR,
        output reg SLV_PREADY1,SLV_ERR1,
        output reg [7:0]SLV_PRDATA1
    );
    
    reg [7:0]mem1[0:31];
    
    reg [2:0]cnt=0;
    
    always@(*)
        begin
            if(PENABLE && SLV_PSEL1)
                begin
                    SLV_PREADY1 = 1;
                    if(PADDR > (2**5))
                        begin
                            SLV_ERR1 = 1;
                        end
                    else 
                        begin
                            if(PWRITE)
                                begin
                                    SLV_ERR1 = 0;
                                    mem1[PADDR] = PWDATA;
                                end
                            else
                                begin 
                                    SLV_ERR1 = 0;
                                    SLV_PRDATA1 = mem1[PADDR];
                                end
                        end
                end
             else
                begin
                    SLV_PREADY1 = 0;
                end
        end
    endmodule
    