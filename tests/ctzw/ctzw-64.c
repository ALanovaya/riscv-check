#include <stdint.h>

int LowestSetBit32(uint32_t x) {
    for (int i = 0; i < 32; i++) {
      if ((x >> i) & 1) {
        return i;
      }
    }
    return 32;
}