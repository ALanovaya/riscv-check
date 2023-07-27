#include <stdint.h>

int32_t test(int32_t rs1, int32_t rs2) {
    return rs1 > rs2 ? rs1 : rs2;
}