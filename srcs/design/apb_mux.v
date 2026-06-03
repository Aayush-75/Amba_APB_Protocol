module apb_mux#(parameter SLAVE_NO=2)(
    input [$clog2(SLAVE_NO)-1:0]MST_PSEL,
    input SLV_PREADY1,
    input [7:0]SLV_PRDATA1,
    input SLV_PREADY2,
    input [7:0]SLV_PRDATA2,
    output reg SLV_PSEL1,
    output reg SLV_PSEL2,
    output reg MST_PREADY,
    output reg [7:0]MST_PRDATA
    );
    
    always@(*)
        begin
            if(!MST_PSEL)
                begin
                    SLV_PSEL2 = 0;
                    SLV_PSEL1 = 1;
                    MST_PREADY = SLV_PREADY1;
                    MST_PRDATA = SLV_PRDATA1;
                end
            else
                begin
                    SLV_PSEL1 = 0;
                    SLV_PSEL2 = 1;
                    MST_PREADY = SLV_PREADY2;
                    MST_PRDATA = SLV_PRDATA2;
                end
        end
endmodule
