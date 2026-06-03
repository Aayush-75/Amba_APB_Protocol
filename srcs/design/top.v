module top#(parameter SLAVE_NO=2)(
    input PCLK,PRESETn,transfer,READ_WRITE,
    input [$clog2(SLAVE_NO)+7:0]apb_write_paddress,apb_read_paddress,
    input [7:0]apb_write_data
    );
    
    wire PREADY,PENABLE,PWRITE;
    wire [7:0]PWDATA,PADDR,PRDATA;
    wire [$clog2(SLAVE_NO)-1:0]PSEL;
    
    wire SLV_PREADY1,SLV_PREADY2;
    wire [7:0]SLV_PRDATA1,SLV_PRDATA2;
    wire SLV_PSEL1,SLV_PSEL2;
    
    wire [7:0]apb_read_data_out;
    
    wire SLV_ERR1,SLV_ERR2;
    
    apb_master a1(PCLK,PRESETn,transfer,READ_WRITE,apb_write_paddress,apb_read_paddress,
                  apb_write_data,PREADY,PRDATA,PENABLE,PWRITE,PWDATA,PADDR,
                  apb_read_data_out,PSEL);
    apb_mux a2(PSEL,SLV_PREADY1,SLV_PRDATA1,SLV_PREADY2,SLV_PRDATA2,SLV_PSEL1,SLV_PSEL2,
               PREADY,PRDATA);
    apb_slv1 a3(SLV_PSEL1,PENABLE,PWRITE,PWDATA,PADDR,SLV_PREADY1,SLV_ERR1,SLV_PRDATA1);
    apb_slv2 a4(SLV_PSEL2,PENABLE,PWRITE,PWDATA,PADDR,SLV_PREADY2,SLV_ERR2,SLV_PRDATA2);
    
endmodule
