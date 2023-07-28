#include <stdint.h>

uint32_t test(uint32_t rs1, uint32_t rs2) {
  return __builtin_riscv_clmul(rs1, rs2);
}