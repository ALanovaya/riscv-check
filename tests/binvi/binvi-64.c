#include <stdint.h>

#define XLEN 64

uint64_t test(uint64_t rs1) {
  uint64_t index = 2023 & (XLEN - 1);
  return rs1 ^ (1ull << index);
}
