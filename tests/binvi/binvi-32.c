#include <stdint.h>

#define XLEN 32

uint32_t test(uint32_t rs1) {
  uint32_t index = 20 & (XLEN - 1);
  return rs1 ^ (1 << index);
}
