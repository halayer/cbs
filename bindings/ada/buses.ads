with System;
with Interfaces.C; use Interfaces.C;
with Components; use Components;

package Buses is

    type Bus is tagged record
        first : access Component;   -- Pointer to the first component
        last  : access Component;   -- Pointer to the last component
        
        comp_amount : aliased int;  -- Total amount of components
        
        debug : System.Address;     -- Debug handle. If not NULL, log messages will be written to this handle.
    end record with Convention => C;
    
    
    procedure attach_component(self: in out Bus; comp: access Component)
        with Import => True, Convention => C, External_Name => "Bus_attachComponent";
    -- Attaches a component to the bus.
    
    function detach_component(self: in out Bus; comp: access Component) return int
        with Import => True, Convention => C, External_Name => "Bus_detachComponent";
    -- Detaches a component from the bus.
    
    function find_component_by_addr(self: in out Bus; addr: Address) return access Component
        with Import => True, Convention => C, External_Name => "Bus_findComponentByAddr";
    -- Finds a component index by the component's address space. Overlapping address spaces
    -- cause the component which was attached first for this address space to be returned.
    -- (Might change in the future)
    
    
    function read(self: in out Bus; addr: Address; byte_size: int; dst: System.Address) return int
        with Import => True, Convention => C, External_Name => "Bus_read";
    -- Reads from the bus.
    
    function write(self: in out Bus; addr: Address; byte_size: int; src: System.Address) return int
        with Import => True, Convention => C, External_Name => "Bus_write";
    -- Writes to the bus.

end Buses;
