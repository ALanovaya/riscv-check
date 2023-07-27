#include <stdint.h>
#include <stdio.h>

#define XLEN 32

uint32_t test(uint32_t rs1, uint32_t rs2) {
  uint32_t index = rs2 & (XLEN - 1);
  return rs1 ^ (1 << index);
}
