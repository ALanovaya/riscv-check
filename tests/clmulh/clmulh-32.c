#include <stdint.h>

#define XLEN 32

int32_t test(int32_t rs1, int32_t rs2) {
  int32_t result = 0;
  for (int i = 1; i < XLEN; i++) {
    if ((rs2 >> i) & 1) {
      result ^= rs1 >> (XLEN - i);
    }
  }
  return result;
}
