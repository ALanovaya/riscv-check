#include <stdint.h>

int64_t test(int64_t rs1) { return __builtin_bswap64(rs1); }