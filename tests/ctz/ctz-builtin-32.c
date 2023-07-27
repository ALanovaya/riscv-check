#include <stdint.h>

int32_t test(int32_t rs) {
    return __builtin_ctzll(rs);
}