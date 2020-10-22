library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity testbench is
end testbench;

architecture arch of testbench is
    -- Constants
    constant T     : time    := 10 ns; -- clk period
    constant DSIZE : natural := 16;    -- Data size
    constant PSIZE : natural := 33;    -- Product size
    constant NBTAP : natural := 4;     -- # of filter taps
    
    
    -- Signals
    signal clk : std_logic;            -- Clock
    signal x   : std_logic_vector(DSIZE - 1 downto 0);
    signal y   : std_logic_vector(PSIZE - 1 downto 0);
    
    file input_file  : text open read_mode is "input.txt";
    file output_file : text open write_mode is "E:/ResearchProject/FIRFilter/FIRFilter.srcs/sim_1/imports/Desktop/output.txt";
    
    -- Types
    type integer_vector is array (0 to NBTAP*2 - 1) of integer;
    
    constant H     : integer_vector := (63, 18, -100, 1, 1, -100, 18, 63);
    
    -- Functions
    -- Filter kernel
    function fir_filter_kernel( x : integer_vector; h : integer_vector) return integer is
        variable y : integer := 0;
    begin
        for i in x'range loop
            y := y + h(i) * x(i);
        end loop;
        return y;
    end function fir_filter_kernel;

begin

    -- Clock
    process
    begin
        clk <= '0';
        wait for T / 2;
        clk <= '1';
        wait for T / 2;
    end process;
    
    -- Instantiation of DUT
    dut : entity work.sfir_even_symmetric_systolic_top 
    generic map(
        DSIZE => DSIZE,
        PSIZE => PSIZE,
        NBTAP => NBTAP
    )
    port map(
        clk => clk,
        datain => x,
        firout => y
    );

    reference_model : process
        variable x_ref    : integer_vector := (others => 0);
        variable y_ref : integer;    
    begin
        wait until falling_edge(clk);
        
        update_x : x_ref := to_integer(signed(x)) & x_ref(0 to x_ref'length - 2);
        
        fir_filter : y_ref := fir_filter_kernel(x_ref, H);
    
        --compare_outputs : assert y_ref = to_integer(y);
    end process reference_model;

    input : process(clk)
    variable input_line : line;
    variable input : integer;
    begin
        if rising_edge(clk) then
            if (not endfile(input_file)) then
                readline(input_file, input_line);
                read(input_line, input);
                x <= std_logic_vector(to_signed(input, DSIZE));
            end if;
        end if;
    end process;

    output : process(clk)
    variable output_line : line;
    begin
        if falling_edge(clk) then    
            write(output_line, to_integer(signed(y)));
            writeline(output_file, output_line);
        end if;      
    end process;

end arch;



