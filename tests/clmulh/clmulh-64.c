#include <stdint.h>

#define XLEN 64

int64_t test(int64_t rs1, int64_t rs2) {
  int64_t result = 0;
  for (int i = 1; i < XLEN; i++) {
    if ((rs2 >> i) & 1) {
      result ^= rs1 >> (XLEN - i);
    }
  }
  return result;
}
