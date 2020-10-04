library verilog;
use verilog.vl_types.all;
entity PC is
    port(
        clk             : in     vl_logic;
        NZT4            : in     vl_logic;
        XEC4            : in     vl_logic;
        JMP             : in     vl_logic;
        CALL4           : in     vl_logic;
        RET             : in     vl_logic;
        RST             : in     vl_logic;
        ALU_NZ          : in     vl_logic;
        hazard          : in     vl_logic;
        branch_hazard   : in     vl_logic;
        long_I          : in     vl_logic;
        ALU_data        : in     vl_logic_vector(7 downto 0);
        PC_I_field      : in     vl_logic_vector(12 downto 0);
        A               : out    vl_logic_vector(15 downto 0)
    );
end PC;
