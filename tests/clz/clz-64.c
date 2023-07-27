#include <stdint.h>

#define XLEN 64

int HighestSetBit(int64_t x) {
  for (int i = XLEN - 1; i >= 0; i--) {
    if ((x >> i) & 1) {
      return i;
    }
  }
  return -1;
}