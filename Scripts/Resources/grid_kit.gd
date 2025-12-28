extends Resource
class_name GridKit
# Supports array[] and grid[cols][rows] interaction

static func return_col(rows:int, idx:int) -> int:
	var cur_row:int = 0
	while cur_row * rows < idx:
		cur_row += 1
	return idx + cur_row * rows

static func get_neighbori(cols:int, rows:int, idx:int) -> Array[int]:
	var arr:Array[int] = []
	var cur_col:int = idx % cols
	var cur_row:int = idx / cols
	for i in [-1, 0, 1]:
		var nrow:int = cur_row + i
		if nrow < 0 or nrow >= rows: continue
		for j in [-1, 0, 1]:
			if i == 0 and j == 0: continue
			var ncol:int = cur_col + j
			if ncol < 0 or ncol >= cols: continue
			arr.append(nrow * cols + ncol)
	return arr

static func get_coordinate_neighbor(cols:int, rows:int, idx:int) -> Dictionary[String, int]:
	var neighbors:Dictionary = {}
	var pos:Dictionary[Vector2, String] = {
		Vector2(-1, -1) : "top_left",
		Vector2(-1, 0) : "top",
		Vector2(-1, 1) : "top_right",
		Vector2(0, -1) : "left",
		Vector2(0, 1) : "right",
		Vector2(1, -1) : "bottom_left",
		Vector2(1, 0) : "bottom",
		Vector2(1, 1) : "bottom_right"
	}
	var cur_col:int = idx % cols
	var cur_row:int = idx / cols
	for i in [-1, 0, 1]:
		var nrow:int = cur_row + i
		if nrow < 0 or nrow >= rows: continue
		for j in [-1, 0, 1]:
			if i == 0 and j == 0: continue
			var ncol:int = cur_col + j
			if ncol < 0 or ncol >= cols: continue
			neighbors[pos[Vector2(i, j)]] = nrow * cols + ncol
	return neighbors

static func get_neighbor_idx(rows:int, cols:int, idx:int, pos:Vector2) -> int:
	var cur_row:int = idx / cols
	var cur_col:int = idx % cols
	var nrow:int = cur_row + int(pos.x)
	var ncol:int = cur_col + int(pos.y)
	if ncol < 0 or ncol >= cols or nrow < 0 or nrow >= rows:
		return -1
	return nrow * cols + ncol

static func get_coordinate(cols:int, rows:int, arr:Array, arr_element:Variant) -> Vector2:
	var idx:int = arr.find(arr_element)
	if idx == -1:
		return Vector2(-1, -1)
	return Vector2(idx / cols, idx % cols)

static func get_neighbors(arr:Array, cols:int, idx:int) -> Array:
	var neighbors:Array = []
	var rows:int = arr.size() / cols
	var x:int = idx % cols
	var y:int = idx / cols
	for dy in [-1, 0, 1]:
		for dx in [-1, 0, 1]:
			if dx == 0 and dy == 0: continue
			var nx:int = x + dx
			var ny:int = y + dy
			if nx < 0 or nx >= cols or ny < 0 or ny >= rows: continue
			neighbors.append(arr[ny * cols + nx])
	return neighbors

static func get_cardinal_neighbors(arr:Array, cols:int, idx:int) -> Array:
	var neighbors:Array = []
	var rows:int = arr.size() / cols
	var x:int = idx % cols
	var y:int = idx / cols
	for dy in [-1, 0, 1]:
		for dx in [-1, 0, 1]:
			if dx == 0 and dy == 0: continue
			if abs(dx) + abs(dy) != 1: continue
			var nx:int = x + dx
			var ny:int = y + dy
			if nx < 0 or nx >= cols or ny < 0 or ny >= rows: continue
			neighbors.append(arr[ny * cols + nx])
	return neighbors

static func get_adjacents(arr:Array, cols:int, item1, item2) -> Array:
	var idx1:int = arr.find(item1)
	var idx2:int = arr.find(item2)
	if idx1 == -1 or idx2 == -1: return []
	var offset:Vector2 = Vector2(idx1 % cols, idx1 / cols) - Vector2(idx2 % cols, idx2 / cols)
	if abs(offset.x) != 1 and abs(offset.y) != 1:
		return []
	return ArrayKit.join(get_cardinal_neighbors(arr, cols, idx1), get_cardinal_neighbors(arr, cols, idx2))

static func get_coordinateidx(cols:int, rows:int, idx:int) -> Vector2:
	return Vector2(idx / cols, idx % cols)

static func get_manhattan_distance(_pos1:Vector2i, _pos2:Vector2i) -> int:
	return abs(_pos1.x - _pos2.x) + abs(_pos1.y - _pos2.y)

static func get_grid_pos(idx:int, grid_size:Vector2i) -> Vector2i:
	var cols:int = grid_size.y
	var row:int = idx / cols
	var col:int = idx % cols
	return Vector2i(row, col)

static func get_arr_index(pos:Vector2i, grid_size:Vector2i) -> int:
	var cols:int = grid_size.y
	return pos.x * cols + pos.y

static func get_ring(_grid:Array, _col:int) -> Array:
	if _grid.size() <= 0:
		return []
	var _row:int = _grid.size() / _col
	var is_edge:Callable = func(idx:int) -> bool:
		var x:int = idx % _col
		var y:int = idx / _col
		return y == 0 or y == _row - 1 or x == 0 or x == _col - 1
	var return_grid:Array = []
	for i in range(_grid.size()):
		if is_edge.call(i):
			return_grid.append(_grid[i])
	return return_grid

static func get_cardinal_neighbor_pos(pos:Vector2i) -> Array:
	return [pos + Vector2i(0, -1), pos + Vector2i(-1, 0), pos + Vector2i(0, 1), pos + Vector2i(1, 0)]

static func get_manhattan_neighbors(distance:int, arr:Array, cols:int, item) -> Array:
	var result:Array = []
	if distance <= 0: return result
	var idx:int = arr.find(item)
	if idx == -1: return result
	var rows:int = arr.size() / cols
	var origin:Vector2i = Vector2i(idx % cols, idx / cols)
	for dy in range(-distance+1, distance):
		for dx in range(-distance+1, distance):
			if abs(dx) + abs(dy) != distance: continue
			var nx:int = origin.x + dx
			var ny:int = origin.y + dy
			if nx < 0 or nx >= cols or ny < 0 or ny >= rows: continue
			result.append(arr[ny * cols + nx])
	return result

static func get_edges(arr:Array, cols:int, pos:Vector2i) -> Array:
	if pos.x == 0: return arr.filter(func(x): return arr.find(x)/cols == cols-1)
	if pos.x == arr.size()/cols: return arr.filter(func(x): return arr.find(x)/cols == 0)
	if pos.y == 0: return arr.filter(func(x): return arr.find(x)%cols == cols-1)
	if pos.y == cols-1: return arr.filter(func(x): return arr.find(x)%cols == 0)
	return [arr[-1]]
