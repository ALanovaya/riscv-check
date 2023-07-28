#include <stdint.h>

#define XLEN 64

int64_t test(int64_t rs) {
  for (int i = 0; i < XLEN; i++) {
    if ((rs >> i) & 1) {
      return i;
    }
  }
  return XLEN;
}
