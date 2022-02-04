#include <stdio.h>
#include <stdlib.h>

#include "bus.h"

int mon_checkAddr(void *inst, uint64_t addr) { return 1; }
int mon_read(void *inst, uint64_t addr, int byte_size, void *dst) { return 0; }
int mon_write(void *inst, uint64_t addr, int byte_size, void *src) { return 0; }

int main() {
    Bus bus = {.debug = stdout};
    Component bus_comp = {1, mon_checkAddr, mon_read, mon_write, NULL, NULL};
    Component mon_comp = {1, mon_checkAddr, mon_read, mon_write, NULL, NULL};
    
    Bus_attachComponent(&bus, &bus_comp);
    Bus_attachComponent(&bus, &mon_comp);
    
    Bus_write(&bus, 10, 1, &bus);
}