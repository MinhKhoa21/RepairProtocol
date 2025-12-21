extends Resource
class_name ArrayKit

static func cache(_arr:Array):
	var _size = _arr.size()
	_arr.clear()
	_arr.resize(_size)

static func replace_tail(_arr:Array, _start_from:int, _tail:Array):
	_arr.resize(_start_from)
	_arr.append_array(_tail)

static func append_unique(arr:Array, other:Array):
	var seen := {}
	for i in arr:
		seen[i] = true
	for i in other:
		if !seen.has(i):
			seen[i] = true
			arr.append(i)

static func array_snapi(_int:int, arr:Array) -> int:
	var weight = arr[0]
	for i in arr:
		if abs(_int-arr[i]) < abs(_int-weight):
			weight = arr[i]
	return weight
