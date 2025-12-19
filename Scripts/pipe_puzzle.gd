extends PanelContainer

#signal finished
#signal started

var can_draw:bool = false
var fuel:int = 2

@onready var grid_container: GridContainer = $GridContainer
@export var grid_size:Vector2i = Vector2i(5, 5)
@export var cell_size:Vector2 = Vector2(64, 64)
#var grid:Array[Point2]
var grid:Array[Array] #[grid_position, is_check_point, direction, is_head, is_traveled, p_line]
var grid_dict:Dictionary[Vector2i, Array]
const p_pos = 0
const p_checkpoint = 1#bool
const p_route = 2#direction
const p_head = 3#bool
const p_traveled = 4#bool
const p_line = 5#direction
var draw_queue:Array = []
var prev_point:Array

func _ready() -> void:
	grid_container.columns = grid_size.y
	grid_gen()
	await grid_ui_gen()
	grid_ui_update()

func grid_gen():
	grid.clear()
	for i in grid_size.y:
		for j in grid_size.x:
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
				var line_dir = Direction.new();
				line_dir.ran_gen()
				_point[p_line] = line_dir
				_point[p_head] = true
				_point[p_traveled] = true
			
			grid.append(_point)
			grid_dict.get_or_add(_point[p_pos], _point)

func grid_ui_gen():
	var route_texture:Texture = load("res://Images/route.png")
	var line_texture:Texture = load("res://Images/straight_pipe.png")
	var activated:Texture = load("res://Images/junction(activated-transparent).png")
	var deactivated:Texture = load("res://Images/junction(deactivaed-transparent).png") 
	var set_size_:Callable = func(_con:Control, _size:Vector2):
		_con.custom_minimum_size = _size
		_con.pivot_offset = _size/2
	var serialize_cell:Callable = func(_con:Control):
		_con.mouse_filter = Control.MOUSE_FILTER_IGNORE
		set_size_.call(_con, cell_size)
		_con.visible = false
	var set_texture:Callable = func(_text_rect:TextureRect, _text:Texture):
		_text_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_text_rect.texture = _text
		serialize_cell.call(_text_rect)
	
	for i in grid:
		var _control:MouseControl = MouseControl.new()
		set_size_.call(_control, cell_size)
		_control.pressed.connect(func(a):
			if i[p_head]:
				can_draw = true
				draw_queue.append(_control)
			)
		_control.released.connect(func(a):
			can_draw = false
			var i2 = draw_queue.pop_back()
			var point2 = cell_to_point(i2)
			while i2 && !point2[p_checkpoint]:
				point2[p_head] = false
				point2[p_line] = null
				i2 = draw_queue.pop_back()
				point2 = cell_to_point(i2)
				point2[p_head] = true
				fuel += 1
			if !draw_queue.is_empty(): cell_to_point(draw_queue[-1])[p_head] = true
			draw_queue.clear()
			grid_ui_update()
			)
		_control.mouse_entered.connect(func():
			if fuel > 0 && can_draw && !draw_queue.has(_control):
				fuel -= 1
				var last_point = cell_to_point(draw_queue[-1])
				var cur_point = cell_to_point(_control)
				var dir:Vector2i = cur_point[p_pos] - last_point[p_pos]
				if cur_point[p_checkpoint]: fuel += 2
				last_point[p_head] = false
				cur_point[p_head] = true
				draw_queue.append(_control)
				match dir:
					Vector2i(0, -1):#left
						if !last_point[p_line]:
							last_point[p_line] = Direction.spe_dir_gen(Direction.left)
						else: last_point[p_line].dir |= Direction.left
						if !cur_point[p_line]:
							cur_point[p_line] = Direction.spe_dir_gen(Direction.right)
						else: cur_point[p_line].dir |= Direction.right
					Vector2i(-1, 0):#up
						if !last_point[p_line]:
							last_point[p_line] = Direction.spe_dir_gen(Direction.up)
						else: last_point[p_line].dir |= Direction.up
						if !cur_point[p_line]:
							cur_point[p_line] = Direction.spe_dir_gen(Direction.down)
						else: cur_point[p_line].dir |= Direction.down
					Vector2i(0, 1):#right
						if !last_point[p_line]:
							last_point[p_line] = Direction.spe_dir_gen(Direction.right)
						else: last_point[p_line].dir |= Direction.right
						if !cur_point[p_line]:
							cur_point[p_line] = Direction.spe_dir_gen(Direction.left)
						else: cur_point[p_line].dir |= Direction.left
					Vector2i(1, 0):#down
						if !last_point[p_line]:
							last_point[p_line] = Direction.spe_dir_gen(Direction.down)
						else: last_point[p_line].dir |= Direction.down
						if !cur_point[p_line]:
							cur_point[p_line] = Direction.spe_dir_gen(Direction.up)
						else: cur_point[p_line].dir |= Direction.up
				grid_ui_update()
			)
		
		var _panel:PanelContainer = PanelContainer.new()
		serialize_cell.call(_panel)
		_panel.visible = true
		
		var _up_line:TextureRect = TextureRect.new()
		set_texture.call(_up_line, line_texture)
		_up_line.rotation = deg_to_rad(-90)
		var _left_line:TextureRect = _up_line.duplicate(); _left_line.rotation = deg_to_rad(-180)
		var _right_line:TextureRect = _up_line.duplicate(); _right_line.rotation = deg_to_rad(0)
		var _down_line:TextureRect = _up_line.duplicate(); _down_line.rotation = deg_to_rad(90)
		
		var _up_route:TextureRect = TextureRect.new()
		set_texture.call(_up_route, route_texture)
		var _left_route:TextureRect = _up_route.duplicate(); _left_route.rotation = deg_to_rad(-90);
		var _right_route:TextureRect = _up_route.duplicate(); _right_route.rotation = deg_to_rad(90)
		var _down_route:TextureRect = _up_route.duplicate(); _down_route.rotation = deg_to_rad(180)
		
		var _activated:TextureRect = TextureRect.new()
		set_texture.call(_activated, activated)
		var _deactivated:TextureRect = TextureRect.new()
		set_texture.call(_deactivated, deactivated)
		
		var _route_control:Control = Control.new()
		serialize_cell.call(_route_control)
		_route_control.visible = true
		_route_control.add_child(_left_route)#1
		_route_control.add_child(_up_route)#2
		_route_control.add_child(_right_route)#3
		_route_control.add_child(_down_route)#4
		var _line_control:Control = Control.new()
		serialize_cell.call(_line_control)
		_line_control.visible = true
		_line_control.add_child(_left_line)#5
		_line_control.add_child(_up_line)#6
		_line_control.add_child(_right_line)#7
		_line_control.add_child(_down_line)#8
		var _junction_control:Control = Control.new()
		serialize_cell.call(_junction_control)
		_junction_control.visible = true
		_junction_control.add_child(_deactivated)
		_junction_control.add_child(_activated)
		
		
		_control.add_child(_panel)#0
		_control.add_child(_route_control)#1
		_control.add_child(_line_control)#2
		_control.add_child(_junction_control)#3
		
		grid_container.add_child(_control)

func grid_ui_update():
	var grid_childs:Array = grid_container.get_children()
	for i:int in grid.size():
		var j = grid[i]
		if j[p_checkpoint]:
			grid_childs[i].get_child(3).get_child(0).visible = !j[p_traveled] && !j[p_head] && !j[p_line]
			grid_childs[i].get_child(3).get_child(1).visible = j[p_traveled] || j[p_head] || j[p_line]
			for l in j[p_route].dir_arr.size():
				grid_childs[i].get_child(1).get_child(l).visible = j[p_route].dir_arr[l]
		if j[p_line]:
			for l in j[p_line].dir_arr.size():
				grid_childs[i].get_child(2).get_child(l).visible = j[p_line].dir_arr[l]
		else:
			for l in grid_childs[i].get_child(2).get_children().size():
				grid_childs[i].get_child(2).get_child(l).visible = false

func draw_power_line():
	pass

func grid_snap() -> Vector2i:
	var local = grid_container.get_local_mouse_position().clamp(Vector2.ZERO, grid_container.size)
	return local/cell_size

func cell_to_point(_con:Control):
	var index = grid_container.get_children().find(_con)
	return grid[index]
