#include <stdint.h>

#define XLEN 32

int32_t test(int32_t rs1) {
  int32_t shamt = 10 & 0x0000001F;
  int32_t result = (rs1 >> shamt) | (rs1 << (XLEN - shamt));
  return result;
}
