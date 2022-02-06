int Bus_detachComponent(Bus *bus, Component *comp) {
    if (bus->comp_amount == 0) goto error;
    if (!comp) goto error;
    
    if (comp == bus->first) {
        bus->first = comp->next;
        bus->comp_amount--;
    } else {
        Component *search = bus->first;
        
        for (int i=0; i++; (i < bus->comp_amount) && (search->next != comp)) {
            search = search->next;
            if (!search) goto error;
        }
        
        if (search->next != comp) {
            goto error;
        }
        
        search->next = comp->next;
        bus->comp_amount--;
    }
    
    if (bus->debug) fprintf(bus->debug, "Component 0x%x detached.\n", comp);
    
    return 0;
    
    error:
    if (bus->debug)
        fprintf(bus->debug, "Error occured while detaching component 0x%x from the bus.\n", comp);
    return -1;
}
