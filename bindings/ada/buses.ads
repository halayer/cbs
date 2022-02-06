with System;
with Interfaces.C; use Interfaces.C;
with Components; use Components;

package Buses is

    type Bus_C is private;
    type Bus is tagged record
        struct : aliased Bus_C;
    end record;
    
    procedure attach_component(self: in out Bus; comp: access Component);
    -- Attaches a component to the bus.
    
    function detach_component(self: in out Bus; comp: access Component) return int;
    -- Detaches a component from the bus.
    
    function get_component_count(self: in out Bus) return int;
    -- Returns the number of components currently attached to the bus.
    
    function find_component_by_addr(self: in out Bus; addr: Address) return access Component;
    -- Finds a component index by the component's address space. Overlapping address spaces
    -- cause the component which was attached first for this address space to be returned.
    -- (Might change in the future)
    
    
    function read(self: in out Bus; addr: Address; byte_size: int; dst: System.Address) return int;
    -- Reads from the bus.
    
    function write(self: in out Bus; addr: Address; byte_size: int; src: System.Address) return int;
    -- Writes to the bus.

private

    type Bus_C is record
        first : access Component := null;   -- Pointer to the first component
        last  : access Component := null;   -- Pointer to the last component
        
        comp_amount : aliased int := 0;  -- Total amount of components
        
        debug : System.Address := System.Null_Address;  -- Debug handle. If not NULL, log messages will be written to this handle.
    end record with Convention => C;
    
    procedure c_attach_component(self: access Bus_C; comp: access Component)
        with Import => True, Convention => C, External_Name => "Bus_attachComponent";
    
    function c_detach_component(self: access Bus_C; comp: access Component) return int
        with Import => True, Convention => C, External_Name => "Bus_detachComponent";
    
    function c_find_component_by_addr(self: access Bus_C; addr: Address) return access Component
        with Import => True, Convention => C, External_Name => "Bus_findComponentByAddr";
    
    
    function c_read(self: access Bus_C; addr: Address; byte_size: int; dst: System.Address) return int
        with Import => True, Convention => C, External_Name => "Bus_read";
    
    function c_write(self: access Bus_C; addr: Address; byte_size: int; src: System.Address) return int
        with Import => True, Convention => C, External_Name => "Bus_write";

end Buses;
