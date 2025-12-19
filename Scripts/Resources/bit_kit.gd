extends Resource
class_name BitKit

static func bit_level(lev:int) -> int:
	return (1 << lev) -1

static func bit_shift(n:int, right:=true, times:=1, bits:=4) -> int:
	if n == 0: return 0
	times = times%bits
	if !right:
		return ((n << times) & bit_level(bits)) | (n >> (bits-times))
	else:
		return (n >> times) | ((n << (bits-times)) & bit_level(bits))

static func bit_bool(num:int, pos:int) -> bool:
	return (num >> (pos-1)) & 1

static func pos_bool(num1:int, pos1:int, num2:int, pos2:int) -> bool:
	return bit_bool(num1, pos1) && bit_bool(num2, pos2)

static func contains_bit(bit:int, mask:int) -> bool:
	return (bit & mask) == mask

static func relates_bit(bit1:int, bit2:int) -> bool:
	return (bit1 & bit2) != 0

static func bit_flip(bit) -> int:
	return bit ^ bit_level(find_level(bit))

static func find_level(bit:int) -> int:
	return int(floor(log(bit) / log(2))) + 1 if bit > 0 else 1

static func counts_bit(bit:int) -> int:
	var count:int = 0
	var temp_bit:int = bit
	while temp_bit > 0:
		count += temp_bit & 1
		temp_bit >>= 1
	return count

static func bit_to_string(bit:int) -> String:
	var char:String = ""
	var temp_bit:int = bit
	while temp_bit > 0:
		char = "%s"%[temp_bit & 1] + char
		temp_bit >>= 1
	return char
