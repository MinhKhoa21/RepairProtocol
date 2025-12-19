extends Resource
class_name LogicKit

static func infectiuos_or(arr:Array[bool]) -> bool:
	if arr.any(func(x): return x):
		for i in arr.size(): arr[i] = true
		return true
	return false

static func shutdown_and(arr:Array[bool]) -> bool:
	if arr.all(func(x): return x):
		for i in arr.size(): arr[i] = false
		return true
	return false

static func both_and(_bool1:bool, _bool2:bool) -> bool:
	return _bool1 == _bool2

static func retrieve_xor(_bool1:bool, _bool2:bool, returns:bool):
	if _bool1 != _bool2:
		if _bool1 == returns: return _bool1
		if _bool2 == returns: return _bool2
	return null

static func switch(_bool1:bool, _bool2:bool, watch:bool):
	if _bool1 != watch:
		_bool2 = true
		return true
	else: return false

static func infect(arr:Array[bool], _bool:bool):
	for i in arr.size(): arr[i] = _bool

static func flip(arr:Array[bool]):
	for i in arr.size(): arr[i] = !arr[i]
