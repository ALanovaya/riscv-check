#include <stdint.h>

uint64_t test(uint32_t index, uint32_t base) {
	uint64_t res = base + (index << 1);
	return res;
}