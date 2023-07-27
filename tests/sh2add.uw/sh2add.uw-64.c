#include <stdint.h>

uint64_t test(uint32_t index, uint32_t base) {
    return base + (index << 2);
}