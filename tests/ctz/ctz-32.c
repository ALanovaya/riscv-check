#include <stdint.h>

#define XLEN 32

int32_t test(int32_t rs) {
  for (int i = 0; i < XLEN; i++) {
    if ((rs >> i) & 1) {
      return i;
    }
  }
  return XLEN;
}
