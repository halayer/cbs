with System;
with Interfaces.C; use Interfaces.C;
with Components; use Components;

package Test_Component is
    function check_addr(inst: System.Address; addr: Address) return int is (1) with Convention => C;
    
    function read(inst: System.Address; addr: Address;
                    byte_size: int; dst: System.Address) return int with Convention => C;
    
    function write(inst: System.Address; addr: Address;
                     byte_size: int; src: System.Address) return int with Convention => C;
end Test_Component;
