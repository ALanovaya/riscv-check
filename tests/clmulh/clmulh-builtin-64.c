#include <stdint.h>

uint64_t test(uint64_t rs1, uint64_t rs2) {
  return __builtin_riscv_clmulh(rs1, rs2);
}