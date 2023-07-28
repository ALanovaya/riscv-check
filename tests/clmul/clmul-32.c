#include <stdint.h>

#define XLEN 32

uint32_t test(uint32_t rs1, uint32_t rs2) {
  uint32_t result = 0;
  for (int i = 0; i < XLEN; i++) {
    if ((rs2 >> i) & 1) {
      result ^= rs1 << i;
    }
  }
  return result;
}
