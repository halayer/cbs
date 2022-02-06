#include <stdio.h>
#include <string.h>

#include "bus.h"

int test_checkAddr(void *inst, uint64_t addr) { return 1; }
int test_read(void *inst, uint64_t addr, int byte_size, void *dst) { printf("c read\n"); memset(dst, 0x41, byte_size); return 0; }
int test_write(void *inst, uint64_t addr, int byte_size, void *src) { printf("c write\n"); return 0; }

int main() {
    char buf[2] = {0, 0};
    Bus bus = {.debug = stdout};
    Component comp = {1, test_checkAddr, test_read, test_write, NULL, NULL};
    
    Bus_attachComponent(&bus, &comp);
    Bus_read(&bus, 1, 2, &buf);
    Bus_detachComponent(&bus, &comp);
}
