#include <stdint.h>

int HighestSetBit(uint32_t x) {
  int bitcount = 0;
  uint32_t val = x;
  
  for (int i = 0; i <= 31; i++) {
    if ((val >> i) & 1) {
      bitcount++;
    }
  }
  
  return bitcount;
}