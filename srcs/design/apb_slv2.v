module apb_slv2(
        input SLV_PSEL2,
        input PENABLE,PWRITE,
        input [7:0]PWDATA,PADDR,
        output reg SLV_PREADY2,SLV_ERR2,
        output reg [7:0]SLV_PRDATA2
    );
    
    reg [7:0]mem2[0:31];
    
    reg cnt=0;
    
    always@(*)
        begin
            if(PENABLE && SLV_PSEL2)
                begin
                    cnt = cnt + 1;
                    SLV_PREADY2 = 1;
                    if(PADDR > (2**5))
                        begin
                            SLV_ERR2 = 1;
                        end
                    else 
                        begin
                            if(PWRITE)
                                begin
                                    SLV_ERR2 = 0;
                                    mem2[PADDR] = PWDATA;
                                end
                            else
                                begin 
                                    SLV_ERR2 = 0;
                                    SLV_PRDATA2 = mem2[PADDR];
                                end
                        end
                end
            else
                begin
                    SLV_PREADY2 = 0;
                end
        end
    
    endmodule
    