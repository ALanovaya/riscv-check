#include <stdint.h>

#define XLEN 64

int64_t test(int64_t rs) {
    int64_t rd = 0;

    for (int i = 0; i < XLEN; i++) {
        if ((rs >> i) & 1)
            break;

        rd++;
    }

    return rd;
}