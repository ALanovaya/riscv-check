#include <stdint.h>

#define XLEN 64

int64_t test(int64_t rs1) {
  int64_t shamt = 10 & 0x000000000000003F;
  int64_t result = (rs1 >> shamt) | (rs1 << (XLEN - shamt));
  return result;
}
