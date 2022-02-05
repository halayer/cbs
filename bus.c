#include <stdint.h>
#include <string.h>

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
    int ret;
	Component *comp = Bus_findComponentByAddr(bus, addr);
	if (!comp) return -1;
	
	ret = comp->read(comp->inst, addr, byte_size, dst);
    
    if (bus->debug) {
        if (ret != 0) {
            fprintf(bus->debug, "Error occured while reading %d byte(s) from 0x%x\n", byte_size, addr);
            return ret;
        }
        
        if (byte_size <= 8 && dst) {
            char buf[8] = {0, 0, 0, 0, 0, 0, 0, 0};
            memcpy(&buf, dst, (size_t)byte_size);
            
            fprintf(bus->debug, "Read %d byte(s) (0x%x) from 0x%x\n", byte_size, &buf, addr);
        } else {fprintf(bus->debug, "Read %d byte(s) from 0x%x\n", byte_size, addr); }
    }
    
    return ret;
}

int Bus_write(Bus *bus, uint64_t addr, int byte_size, void *src) {
    int ret;
	Component *comp = Bus_findComponentByAddr(bus, addr);
	if (!comp) return -1;
	
	ret = comp->write(comp->inst, addr, byte_size, src);
    
    if (bus->debug) {
        if (ret != 0) {
            fprintf(bus->debug, "Error occured while writing %d byte(s) to 0x%x\n", byte_size, addr);
            return ret;
        }
        
        if (byte_size <= 8 && src) {
            char buf[8] = {0, 0, 0, 0, 0, 0, 0, 0};
            memcpy(&buf, src, (size_t)byte_size);
            
            fprintf(bus->debug, "Wrote %d byte(s) (0x%x) from 0x%x\n", byte_size, &buf, addr);
        } else {fprintf(bus->debug, "Wrote %d byte(s) from 0x%x\n", byte_size, addr); }
    }
    
    return ret;
}
