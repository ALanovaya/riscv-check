#include <stdint.h>

int32_t test(int32_t rs1) { return __builtin_bswap32(rs1); }