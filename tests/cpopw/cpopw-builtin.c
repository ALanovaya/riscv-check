#include <stdint.h>
#include <stdio.h>

#define XLEN 64

uint64_t test(uint64_t rs) { return __builtin_popcount(rs); }
