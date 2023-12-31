#include <stdint.h>

#define XLEN 32

uint32_t test(uint32_t rc1, uint32_t rc2) {
    uint32_t output = 0;
    for (int i = 0; i < XLEN; i++) 
      if ((rc2 >> i) & 1)
        output ^= (rc1 >> (XLEN - i - 1));
    return output;
}