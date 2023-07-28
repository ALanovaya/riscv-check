#include <stdint.h>

#define XLEN 64

uint64_t test(uint64_t rs1, uint64_t rs2) {
    uint64_t shamt = rs2;
    for (int i = 16; i < XLEN; ++i) 
        shamt &= ~((uint64_t)1 << i);
    return (rs1 << shamt) | (rs1 >> (XLEN - shamt));
}