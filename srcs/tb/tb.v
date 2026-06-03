module tb#(parameter SLAVE_NO=2)();

reg PCLK,PRESETn,transfer,READ_WRITE;
reg [$clog2(SLAVE_NO)+7:0]apb_write_paddress,apb_read_paddress;
reg [7:0]apb_write_data;

top t1(PCLK,PRESETn,transfer,READ_WRITE,apb_write_paddress,apb_read_paddress,apb_write_data);

initial 
begin
    PCLK = 0;
    forever #2 PCLK = ~PCLK;
end

task write_op;
    input t_transfer;
    input t_READ_WRITE;
    input [$clog2(SLAVE_NO)+7:0]t_apb_write_paddress;
    input [7:0]t_apb_write_data;
        begin
            transfer = t_transfer;
            READ_WRITE = t_READ_WRITE;
            apb_write_paddress = t_apb_write_paddress;
            apb_write_data = t_apb_write_data;
            @(posedge PCLK);
            @(posedge PCLK);
            @(negedge PCLK);
        end
endtask

task read_op;
    input t_transfer;
    input t_READ_WRITE;
    input [$clog2(SLAVE_NO)+7:0]t_apb_read_paddress;
        begin
            transfer = t_transfer;
            READ_WRITE = t_READ_WRITE;
            apb_read_paddress = t_apb_read_paddress;
            @(posedge PCLK);
            @(posedge PCLK);
            @(negedge PCLK);
        end
endtask

initial 
    begin
        PRESETn = 1;
        #5;
        PRESETn = 0;
        #5;
        PRESETn = 1;
        #5;
        write_op(1,0,'h105,'h12);
        write_op(1,0,'h106,'h34);
        write_op(1,0,'h107,'h56);
        write_op(1,0,'h108,'h78);
        write_op(1,0,'h109,'h9a);
        transfer=0;
        #20;
        read_op(1,1,'h106);
        read_op(1,1,'h107);
        read_op(1,1,'h108);
        #100;
        $finish;
    end
    
endmodule