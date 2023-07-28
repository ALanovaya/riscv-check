#include <stdint.h>

int test(uint32_t rs) {
    return __builtin_popcount(rs);
}