#include <stdint.h>

uint32_t test(uint32_t rs1, uint32_t shamt) {
    uint32_t res = rs1 << shamt;
    return res;
}
