with System;
with Ada.Text_IO;
with Interfaces.C;
with Components; use Components;

package body Test_Component is
    function read(inst: System.Address; addr: Address;
                    byte_size: int; dst: System.Address) return int is
    begin
        Ada.Text_IO.Put_Line("ada read"); return 0;
    end read;
    
    function write(inst: System.Address; addr: Address;
                     byte_size: int; src: System.Address) return int is
    begin
        Ada.Text_IO.Put_Line("ada write"); return 0;
    end write;
end Test_Component;
