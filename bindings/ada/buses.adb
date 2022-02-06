with System;
with Interfaces.C; use Interfaces.C;
with Buses; use Buses;

package body Buses is

    procedure attach_component(self: in out Bus; comp: access Component) is
    begin
        c_attach_component(self.struct'Access, comp);
    end attach_component;
    
    function detach_component(self: in out Bus; comp: access Component) return int is
    begin
        return c_detach_component(self.struct'Access, comp);
    end detach_component;
    
    function get_component_count(self: in out Bus) return int is
    begin
        return self.struct.comp_amount;
    end get_component_count;
    
    function find_component_by_addr(self: in out Bus; addr: Address) return access Component is
    begin
        return c_find_component_by_addr(self.struct'Access, addr);
    end find_component_by_addr;
    
    
    function read(self: in out Bus; addr: Address; byte_size: int; dst: System.Address) return int is
    begin
        return c_read(self.struct'Access, addr, byte_size, dst);
    end read;
    
    function write(self: in out Bus; addr: Address; byte_size: int; src: System.Address) return int is
    begin
        return c_write(self.struct'Access, addr, byte_size, src);
    end write;
    
end Buses;
