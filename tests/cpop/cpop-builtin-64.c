#include <stdint.h>

int test(uint64_t rs) {
    return __builtin_popcount(rs);
}