library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package filter_package is
    
    function fir_filter_kernel( x : real_vector(0 to 3); b : real_vector(0 to 3)) return real;
    
end filter_package;

package body filter_package is

    function fir_filter_kernel( x : real_vector(0 to 3); b : real_vector(0 to 3)) return real is
            variable y : real := 0.0;
        begin
            
            return y;
        end function fir_filter_kernel;

end filter_package;