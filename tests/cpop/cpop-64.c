#include <stdint.h>

#define XLEN 64

int64_t test(int64_t rs) {
    int64_t count = 0;
    for (int i = 0; i < XLEN; ++i)
        if (rs & (1ll << i)) 
	    ++count;
    return count;
}