#include <stdint.h>

#define XLEN 64

uint64_t test(uint64_t rs1, uint64_t rs2) {
  uint64_t index = rs2 & (XLEN - 1);
  return (rs1 >> index) & 1;
}
