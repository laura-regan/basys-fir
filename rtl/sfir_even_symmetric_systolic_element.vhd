library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sfir_even_symmetric_systolic_element is
    generic(
        DSIZE : natural := 16
        );
    port(
        clk                      : in  std_logic;
        coeffin, datain, datazin : in  std_logic_vector(DSIZE-1 downto 0);
        cascin                   : in  std_logic_vector(2 * DSIZE downto 0);
        cascdata                 : out std_logic_vector(DSIZE - 1 downto 0);
        cascout                  : out std_logic_vector(2 * DSIZE downto 0)
        );
end sfir_even_symmetric_systolic_element;

architecture rtl of sfir_even_symmetric_systolic_element is

    signal coeff, data, dataz, datatwo : signed(DSIZE - 1 downto 0);
    signal preadd                      : signed(DSIZE downto 0);
    signal product, cascouttmp         : signed(2 * DSIZE downto 0);
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            coeff      <= signed(coeffin);
            data       <= signed(datain);
            datatwo    <= data;
            dataz      <= signed(datazin);
            preadd     <= resize(datatwo, DSIZE + 1) + resize(dataz, DSIZE + 1);
            product    <= preadd * coeff;
            cascouttmp <= product + signed(cascin);
        end if;
    end process;
    
    cascout <= std_logic_vector(cascouttmp);
    cascdata <= std_logic_vector(datatwo);
            
end rtl;

