#include <stdint.h>

#define XLEN 32                                                       

uint32_t test(uint32_t rs1, uint32_t rs2) {
    int32_t shamt = rs2;
    for (int i = 5; i < XLEN; ++i) 
	shamt &= ~(1 << i);
    return (rs1 >> shamt) | (rs1 << (XLEN - shamt));
}