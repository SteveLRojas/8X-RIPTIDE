library verilog;
use verilog.vl_types.all;
entity call_stack is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        push            : in     vl_logic;
        pop             : in     vl_logic;
        data_in         : in     vl_logic_vector(15 downto 0);
        data_out        : out    vl_logic_vector(15 downto 0)
    );
end call_stack;
