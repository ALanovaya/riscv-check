#include <stdint.h>

uint32_t test(uint32_t rs1, uint32_t rs2) {
    uint32_t shamt = rs2;
    for (int i = 12; i < 64; ++i) 
    	shamt &= ~((uint32_t)1 << i);
    return (rs1 << shamt) | (rs1 >> (64 - shamt));
}