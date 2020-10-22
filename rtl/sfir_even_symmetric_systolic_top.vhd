library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sfir_even_symmetric_systolic_top is 
    generic(
        DSIZE : natural := 16;
        PSIZE : natural := 33;
        NBTAP : natural := 4
    );
    port(
        clk    : in  std_logic;
        datain : in  std_logic_vector(DSIZE - 1 downto 0);
        firout : out std_logic_vector(PSIZE - 1 downto 0)
    );
end sfir_even_symmetric_systolic_top;

architecture rtl of sfir_even_symmetric_systolic_top is

    type DTAB is array (0 to NBTAP - 1) of std_logic_vector(DSIZE - 1 downto 0);
    type HTAB is array (0 to NBTAP - 1) of std_logic_vector(DSIZE - 1 downto 0);
    type PTAB is array (0 to NBTAP - 1) of std_logic_vector(PSIZE - 1 downto 0);

    signal arrayData, dataz : DTAB;
    signal arrayProd        : PTAB;
    signal shifterout       : std_logic_vector(DSIZE - 1 downto 0);
    
    constant h : HTAB := (
        (std_logic_vector(to_signed(63, DSIZE))), 
        (std_logic_vector(to_signed(18, DSIZE))),
        (std_logic_vector(to_signed(-100, DSIZE))),
        (std_logic_vector(to_signed(1, DSIZE)))
        );
    constant zero_psize : std_logic_vector(PSIZE - 1 downto 0) := (others => '0');
    
begin
    
    firout <= arrayprod(NBTAP - 1);
    
    shift_unit : entity work.sfir_shifter
    generic map(
                DSIZE => DSIZE, 
                NBTAP => NBTAP
    )
    port map(
            clk     => clk,
            datain  => datain, 
            dataout => shifterout
    );
        
    gen : for I in 0 to NBTAP - 1 generate
    begin
        g0 : if I = 0 generate
            element_u0 : entity work.sfir_even_symmetric_systolic_element
            generic map(DSIZE => DSIZE)
            port map(clk => clk, coeffin => h(I), datain => datain, datazin => shifterout, 
                     cascin => zero_psize, cascdata => arraydata(I), cascout => arrayprod(I));
        end generate g0;
        gi : if I /= 0 generate
            element_ui : entity work.sfir_even_symmetric_systolic_element
            generic map(DSIZE => DSIZE)
            port map(clk => clk, coeffin => h(I), datain => arraydata(I - 1), datazin => shifterout, 
                     cascin => arrayprod(I - 1), cascdata => arraydata(I), cascout => arrayprod(I));
        end generate gi;
    end generate gen;
    
end rtl;




