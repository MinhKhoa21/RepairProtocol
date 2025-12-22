extends Node3D

@export var grid_size:Vector2i = Vector2i(5, 5)
@export var size_mod:float = 1
@onready var points: Node3D = $Points

var grid:Array[Array] #[grid_position, is_check_point, route_direction, is_head, is_traveled, p_line]
const p_pos = 0
const p_checkpoint = 1#bool
const p_route = 2#direction
const p_head = 3#bool
const p_traveled = 4#bool
const p_line = 5#direction
var draw_queue:Array = []
var drew:Array = []

func _ready() -> void:
	grid_gen()
	grid3D_gen()
	#grid_ui_update()

func grid_gen():
	grid.clear()
	for i in grid_size.x:
		for j in grid_size.y:
			var _point:Array = [Vector2i(i, j)]
			if MathKit.chance_trigger(0.3):
				_point.append(true)
				var _dir = Direction.new()
				_dir.ran_gen()
				_point.append(_dir)
			else:
				_point.append_array([false, null])
			_point.append_array([false, false, null])
			
			if grid.is_empty():
				var line_dir = Direction.new()
				line_dir.ran_gen()
				_point[p_line] = line_dir
				_point[p_head] = true
				_point[p_traveled] = true
			
			grid.append(_point)

func grid3D_gen():
	for i in grid:
		var j = load("res://Scenes/grid_cell.tscn").instantiate()
		(j as Node3D).scale = Vector3(1, 1, 1) * size_mod
		points.add_child(j)
		recenter()

func recenter():
	var childs = points.get_children()
	var cell_size = abs(childs[0].get_child(2).get_child(2).get_child(0).global_position.x - childs[0].get_child(2).get_child(0).get_child(0).global_position.x)
	#var total_size_x = cell_size * min(grid_size.x, grid.size())
	#var total_size_y = cell_size * min(grid_size.y, grid.size())
	for i in childs:
		var point = cell_to_point(i)
		i.position = Vector3(point[p_pos].y, point[p_pos].x, 0)*cell_size

func cell_to_point(cell) -> Array:
	return grid[points.get_children().find(cell)]

func point_to_cell(point) -> Node3D:
	return points.get_children()[grid.find(point)]

func grid_ui_update():
	for i in grid:
		if i[p_checkpoint]:
			point_to_cell(i).get_child(0).visible = true
			point_to_cell(i).get_child(1).visible = true
			for j in i[p_route].dir_arr.size():
				point_to_cell(i).get_child(1).get_child(j).visible = i[p_route].dir_arr[j]
		else:
			point_to_cell(i).get_child(0).visible = false
			point_to_cell(i).get_child(1).visible = false
		if i[p_line]:
			point_to_cell(i).get_child(2).visible = true
			for j in i[p_line].dir_arr.size():
				point_to_cell(i).get_child(2).get_child(j).visible = i[p_line].dir_arr[j]
		else:
			point_to_cell(i).get_child(2).visible = false
