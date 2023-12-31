#include <stdint.h>

#define XLEN 64

uint64_t test(uint64_t rc1, uint64_t rc2) {
    uint64_t output = 0;
    for (int i = 0; i < XLEN; i++)
      if ((rc2 >> i) & 1)
        output ^= (rc1 >> (XLEN - i - 1));
    return output;
}