#include <stdint.h>

#include "bus.h"

void Bus_attachComponent(Bus *bus, Component *comp) {
    if (bus->comp_amount == 0) {
        bus->first = comp;
    } else {
        bus->last->next = comp;
    }
    
    bus->last = comp;
    if (bus->debug) fprintf(bus->debug, "Component attached. Index: %d\n", bus->comp_amount);
    bus->comp_amount++;
}

Component *Bus_findComponentByAddr(Bus *bus, uint64_t addr) {
	Component *comp = bus->first;
	
	while (1) {
		if (comp->has_addr_space && comp->is_in_addr_space(comp->inst, addr)) return comp;
        
        comp = comp->next;
	}
	
	return NULL;
}


int Bus_read(Bus *bus, uint64_t addr, int byte_size, void *dst) {
	Component *comp = Bus_findComponentByAddr(bus, addr);
	if (!comp) return -1;
	
    if (bus->debug) fprintf(bus->debug, "Read %d byte(s) from 0x%x\n", byte_size, addr);
	return comp->read(comp->inst, addr, byte_size, dst);
}

int Bus_write(Bus *bus, uint64_t addr, int byte_size, void *src) {
	Component *comp = Bus_findComponentByAddr(bus, addr);
	if (!comp) return -1;
	
    if (bus->debug) fprintf(bus->debug, "Wrote %d byte(s) to 0x%x\n", byte_size, addr);
	return comp->write(comp->inst, addr, byte_size, src);
}
