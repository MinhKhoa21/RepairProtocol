extends Resource
class_name GridKit
#Supports array[] and grid[cols][rows] interaction

static func return_col(rows:int, idx:int) -> int:
	var cur_row:int = 0
	while cur_row*rows < idx:
		cur_row += 1
	return idx+cur_row*rows

static func get_neighbor(cols:int, rows:int, idx:int) -> Array[int]:
	var arr:Array[int] = []
	var cur_col:int = idx % cols
	var cur_row:int = idx / cols
	for i in [-1, 0, 1]:
		var nrow:int = cur_row + i
		if nrow < 0 || nrow > rows-1: continue
		for j in [-1, 0, 1]:
			if i == 0 && j == 0: continue
			var ncol:int = cur_col + j
			if ncol < 0 || ncol > cols-1: continue
			arr.append(nrow*cols+ncol)
	return arr

static func get_coordinate_neighbor(cols:int, rows:int, idx:int) -> Dictionary[String, int]:
	var neg:Dictionary[String, int] = {}
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
		if nrow < 0 || nrow > rows-1: continue
		for j in [-1, 0, 1]:
			if i == 0 && j == 0: continue
			var ncol:int = cur_col + j
			if ncol < 0 || ncol > cols-1: continue
			neg.get_or_add(pos[Vector2(i, j)], nrow*cols+ncol)
	return neg

static func get_neighbor_idx(rows:int, cols:int, idx:int, pos:Vector2) -> int:
	var cur_row:int = idx/rows
	var cur_col:int = idx%cols
	var neg_row:int = cur_row + pos.x
	var neg_col:int = cur_col + pos.y
	if neg_col < 0 || neg_col > cols-1 || neg_row < 0 || neg_row > rows-1: return -1
	return neg_col+neg_row*cols

static func get_coordinate(cols:int, rows:int, arr:Array, arr_element:Variant) -> Vector2:
	var idx:int = arr.find(arr_element)
	if idx == -1: return Vector2(-1, -1)
	return Vector2(idx/rows, idx%cols)

static func get_coordinateidx(cols:int, rows:int, idx:int) -> Vector2:
	return Vector2(idx/rows, idx%cols)

static func get_manhattan_distance(_pos1:Vector2i, _pos2:Vector2i) -> int:
	return absi(_pos1.x - _pos2.x) + absi(_pos1.y - _pos2.y)

static func get_grid_pos(idx: int, grid_size: Vector2i) -> Vector2i:
	#var rows := grid_size.x
	var cols := grid_size.y
	var row := idx / cols
	var col := idx % cols
	return Vector2i(row, col)

static func get_arr_index(pos: Vector2i, grid_size: Vector2i) -> int:
	#var rows := grid_size.x
	var cols := grid_size.y
	return pos.x * cols + pos.y

static func get_ring(_grid:Array, _col:int) -> Array:
	if _grid.size() <= 0: var _grid2 = _grid.duplicate(); _grid2.clear(); return _grid2
	var _row = _grid.size()/_col
	var is_edge:Callable = func(idx:int) -> bool:
		var x = idx % _col
		var y = idx / _col
		return (y == 0 || y == _row-1) || (x == 0 || x == _col-1)
	var return_grid:Array = []
	for i in _grid.size():
		if is_edge.call(i): return_grid.append(_grid[i])
	return return_grid
