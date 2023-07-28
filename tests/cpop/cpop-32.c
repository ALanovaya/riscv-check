#include <stdint.h>

#define XLEN 32

int32_t test(int32_t rs) {
    int32_t count = 0;
    for (int i = 0; i < XLEN; ++i)
        if (rs & (1 << i)) 
            ++count;
    return count;
}