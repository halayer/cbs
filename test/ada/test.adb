with System;
with Interfaces.C; use Interfaces.C;
with Components; use Components;
with Buses; use Buses;
with Test_Component; use Test_Component;

procedure test is
    b : Bus;
    c : aliased Component;
    e : int;
begin
    c := (1, check_addr'Access, read'Access, write'Access, System.Null_Address, System.Null_Address, null);
    
    b.attach_component(c'Access);
    e := b.read(1, 2, System.Null_Address);
end test;
