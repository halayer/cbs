#include <stdio.h>

#include "bus.h"

int test_checkAddr(void *inst, uint64_t addr) { return 1; }
int test_read(void *inst, uint64_t addr, int byte_size, void *dst) { printf("c read\n"); return 0; }
int test_write(void *inst, uint64_t addr, int byte_size, void *src) { printf("c write\n"); return 0; }

int main() {
    Bus bus = {.debug = stdout};
    Component comp = {1, test_checkAddr, test_read, test_write, NULL, NULL};
    
    Bus_attachComponent(&bus, &comp);
    Bus_read(&bus, 1, 2, NULL);
}
