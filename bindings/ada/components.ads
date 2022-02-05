with System;
with Interfaces.C; use Interfaces.C;

package Components is

    subtype Address is Long_Long_Integer;

    type Component;
    type Component is record
        has_addr_space : aliased int;   -- Indicates whether the component has any address space.
        
        -- CALLBACK FUNCTIONS: (To be implemented by the component)
        is_in_addr_space : access function(inst: System.Address; addr: Address) return int;
            -- Returns 1 when the given address is within the component's address space.
        
        read : access function(inst: System.Address; addr: Address;
                               byte_size: int; dst: System.Address) return int;
            -- Copies byte_size bytes of data from the component's address space to dst.
        
        write : access function(inst: System.Address; addr: Address;
                                byte_size: int; src: System.Address) return int;
            -- Copies copy byte_size bytes of data from src to the component's address space.
        
        intf : System.Address; -- Interface. Here, the implementer can implement additional func-
            -- tion(alities) of the component aside from the standard read and write.
            -- Though to use them properly, the user must have an agreement with the impl-
            -- ementer what these are (preferably a header file), since this library does
            -- not provide a standard for that. Can be NULL.
        
        inst : System.Address; -- Component instance, which is passed to the callback functions.
            -- Can be NULL.
        
        next : access all Component; -- Next list element. MUST NOT BE SET BY USER/IMPLEMENTER.
    end record with Convention => C;
    
end Components;
