#include <stdint.h>

int32_t test(int32_t rs) {
    int32_t count = 0;
    for (int i = 0; i < 64; ++i)
        if (rs & (1ll << i)) 
            ++count;
    return count;
}