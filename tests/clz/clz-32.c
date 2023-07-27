#include <stdint.h>

#define XLEN 32

int HighestSetBit(int32_t x) {
  for (int i = XLEN - 1; i >= 0; i--) {
    if ((x >> i) & 1) {
      return i;
    }
  }
  return -1;
}