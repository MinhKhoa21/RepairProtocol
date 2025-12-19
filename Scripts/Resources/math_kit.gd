extends Resource
class_name MathKit

static func flow_clampi(n:int, min:int, max:int) -> int:
	var range = max - min + 1
	return posmod(n - min, range) + min

static func stretch(_float1:float, _float2:float) -> float:
	return min(_float1, _float2)/max(_float1, _float2)

static func chance_trigger(chance:float) -> bool:
	return randf_range(0, 1) < chance
