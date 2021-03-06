library verilog;
use verilog.vl_types.all;
entity sc_computer_vlg_check_tst is
    port(
        HEX0            : in     vl_logic_vector(6 downto 0);
        HEX1            : in     vl_logic_vector(6 downto 0);
        HEX2            : in     vl_logic_vector(6 downto 0);
        HEX3            : in     vl_logic_vector(6 downto 0);
        HEX4            : in     vl_logic_vector(6 downto 0);
        HEX5            : in     vl_logic_vector(6 downto 0);
        WangHangyu      : in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end sc_computer_vlg_check_tst;
