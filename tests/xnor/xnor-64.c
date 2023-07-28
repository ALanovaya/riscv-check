#include <stdint.h>

int64_t test(int64_t rs1, int64_t rs2) {
    return ~(rs1 ^ rs2);
}