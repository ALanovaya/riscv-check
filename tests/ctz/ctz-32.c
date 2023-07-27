#include <stdint.h>

#define XLEN 32

int32_t test(int32_t rs) {
    int32_t rd = 0;

    for (int i = 0; i < XLEN; i++) {
        if ((rs >> i) & 1)
            break;

        rd++;
    }

    return rd;
}