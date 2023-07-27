#include <stdint.h>

#define XLEN 64

uint64_t test(uint64_t rs1, uint64_t rs2) {
  uint64_t result = 0;
  for (int i = 0; i < XLEN; i++) {
    if ((rs2 >> i) & 1) {
      result ^= rs1 << i;
    }
  }
  return result;
}
