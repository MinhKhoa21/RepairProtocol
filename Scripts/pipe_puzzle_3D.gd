extends Puzzle3D

@export var grid_size:Vector2i = Vector2i(5, 5)
@onready var points: Node3D = $Points
@export var i_area:InteractArea
@export var cam:Camera3D

var grid:Array[Array] #[grid_position, is_check_point, route_direction, is_head, is_traveled, p_line, start, goal]
const p_pos = 0
const p_checkpoint = 1#bool
const p_route = 2#direction
const p_head = 3#bool
const p_traveled = 4#bool
const p_line = 5#direction
const p_start = 6#bool
const p_goal = 7#bool
var noise:Array
var draw_queue:Array
var drew:Array
var can_draw:bool = false
var fuel:int = 2:
	set(val):
		fuel = val
		print(fuel)
var hover_cell
var start_point
var goal_point

func _ready() -> void:
	$Boardholder.visible = false
	await puzzle_gen(true)
	i_area.interacted.connect(func():
		GState.solve()
		cam.make_current()
		)
	Watcher.game_state_changed.connect(func(a):
		if a != GState.gstate_enum.SOLVING:
			Watcher.player_cam.make_current()
		)

func grid_gen():
	grid.clear()
	for i in grid_size.x:
		for j in grid_size.y:
			var _point:Array = [Vector2i(i, j)]
			#if MathKit.chance_trigger(0.3):
				#_point.append(true)
				#var _dir = Direction.new()
				#_dir.ran_gen()
				#_point.append(_dir)
			#else:
				#_point.append_array([false, null])
			_point.append_array([false, null, false, false, null, false, false])
			
			grid.append(_point)
	var spawn_points:Array = GridKit.get_ring(grid, grid_size.x)
	start_point = spawn_points.filter(func(x): return !x[p_checkpoint]).pick_random()
	start_point[p_start] = true
	start_point[p_head] = true
	spawn_points = GridKit.get_edges(grid, grid_size.y, start_point[p_pos])
	spawn_points.erase(start_point)
	goal_point = spawn_points.pick_random()
	goal_point[p_goal] = true

func grid3D_gen():
	var cell_size = $Boardholder.mesh.size.x/grid_size.x
	for i in grid:
		var j = load("res://Scenes/grid_cell.tscn").instantiate()
		points.add_child(j)
		if i[p_goal]:
			j.get_child(3).get_child(0).visible = false
			j.get_child(3).get_child(1).visible = true
		
		j.position = Vector3(i[p_pos].y, -i[p_pos].x, 0)*cell_size

func _input(event: InputEvent) -> void:
	if GState.is_solving() && event is InputEventMouseMotion && hit_cell():
		if hover_cell:
			hover_cell.get_child(4).visible = false
		hover_cell = get_cell()
		hover_cell.get_child(4).visible = true
	if GState.is_solving() && !can_draw && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed() && hit_cell() && cell_to_point(get_cell())[p_checkpoint] && !cell_to_point(get_cell())[p_traveled]: cell_to_point(get_cell())[p_route].rotate(false); grid_ui_update()
	if GState.is_solving() && event is InputEventMouseButton && (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT && event.is_pressed() && hit_cell() && cell_to_point(get_cell())[p_head]:
		can_draw = true
		draw_queue.append(get_cell())
		#print("Can draw now.")
	if GState.is_solving() && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed() && hit_cell():
		var cell = get_cell()
		if cell_to_point(cell)[p_head]:
			var point = cell_to_point(cell)
			point[p_traveled] = false
			while drew[-1] != start_point || !drew[-1][p_checkpoint]:
				point = cell_to_point(drew.pop_back())
				point[p_traveled] = false
				point[p_line] = null
			
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_released():
		can_draw = false
		while !draw_queue.is_empty():
			var cell = draw_queue.pop_back()
			var point = cell_to_point(cell)
			if point[p_checkpoint] || point[p_goal]:
				point[p_head] = true
				drew.append_array(draw_queue)
				fuel += draw_queue.size()
				draw_queue.clear()
				break
			if !draw_queue.is_empty(): fuel += 1
			point[p_line] = null
			point[p_traveled] = false
			
		for i in drew:
			cell_to_point(i)[p_head] = false
		grid_ui_update()
	if can_draw && GState.is_solving() && event is InputEventMouseMotion: project_mouse()

#func recenter():
	#var childs = points.get_children()
	#var cell_size = $Boardholder.mesh.size.x/grid_size.x
	##var total_size_x = cell_size * min(grid_size.x, grid.size())
	##var total_size_y = cell_size * min(grid_size.y, grid.size())
	#for i in childs:
		#var point = cell_to_point(i)
		#i.position = Vector3(point[p_pos].y, point[p_pos].x, 0)*cell_size

func cell_to_point(cell) -> Array:
	return grid[points.get_children().find(cell)]

func point_to_cell(point) -> Node3D:
	return points.get_children()[grid.find(point)]

func grid_ui_update():
	for i in grid:
		var cell = point_to_cell(i)
		if i[p_checkpoint]:
			cell.get_child(0).visible = true
			if i[p_traveled]: (cell.get_child(0).get_child(0) as MeshInstance3D).material_override = preload("res://texture/amber_glow.tres")
			else: (cell.get_child(0).get_child(0) as MeshInstance3D).material_override = preload("res://texture/amber_dim.tres")
			cell.get_child(1).visible = true
			for j in i[p_route].dir_arr.size():
				cell.get_child(1).get_child(j).visible = i[p_route].dir_arr[j]
		else:
			cell.get_child(0).visible = false
			cell.get_child(1).visible = false
		if i[p_line]:
			cell.get_child(2).visible = true
			for j in i[p_line].dir_arr.size():
				cell.get_child(2).get_child(j).visible = i[p_line].dir_arr[j]
		else:
			cell.get_child(2).visible = false
		cell.get_child(3).get_child(0).visible = i[p_start] || (i[p_goal] && [p_traveled])
		cell.get_child(3).get_child(1).visible = i[p_goal] && !i[p_traveled]
		cell.get_child(3).get_child(2).visible = i[p_start] || i[p_goal]
		cell.get_child(-2).visible = cell_to_point(cell)[p_head]

func hit_cell() -> bool:
	var mouse_pos = get_viewport().get_mouse_position()
	var temp_cam := get_viewport().get_camera_3d()
	var from = temp_cam.project_ray_origin(mouse_pos)
	var ray_dir = temp_cam.project_ray_normal(mouse_pos)
	var to = from + ray_dir*(temp_cam.far if temp_cam.far > 0 else 100000.0)
	var query = PhysicsRayQueryParameters3D.create(from, to, 1<<6)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var col = get_world_3d().direct_space_state.intersect_ray(query)
	if !col.is_empty(): return true
	return false

func get_cell() -> Node3D:
	var mouse_pos = get_viewport().get_mouse_position()
	var temp_cam := get_viewport().get_camera_3d()
	var from = temp_cam.project_ray_origin(mouse_pos)
	var ray_dir = temp_cam.project_ray_normal(mouse_pos)
	var to = from + ray_dir*(temp_cam.far if temp_cam.far > 0 else 100000.0)
	var query = PhysicsRayQueryParameters3D.create(from, to, 1<<6)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var col = get_world_3d().direct_space_state.intersect_ray(query)
	#print(col.collider.get_parent())
	return col.collider.get_parent()

func project_mouse() -> void:

	var cam2 := get_viewport().get_camera_3d()
	if cam2 == null:
		return
	
	var mouse_pos := get_viewport().get_mouse_position()

	# Build ray
	var from := cam2.project_ray_origin(mouse_pos)
	var dir2  := cam2.project_ray_normal(mouse_pos)
	var to   := from + dir2 * (cam.far if cam.far > 0.0 else 100000.0)

	# Raycast
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 1<<6
	
	var hit2 = get_world_3d().direct_space_state.intersect_ray(query)
	
	if !hit2.is_empty():
		var cell = hit2.collider.get_parent()
		var can_travel = func() -> bool:
			if fuel <= 0: return false
			if draw_queue.is_empty(): return true
			var prev_point = cell_to_point(draw_queue[-1])
			var cur_point = cell_to_point(cell)
			if cur_point[p_traveled]: return false
			var dir = Direction.get_dir(prev_point[p_pos], cur_point[p_pos])
			var rev_dir = Direction.get_dir(cur_point[p_pos], prev_point[p_pos])
			if dir == -2 || rev_dir == -2: return false
			if prev_point[p_checkpoint] && !(prev_point[p_route].dir & dir): return false
			if cur_point[p_checkpoint] && !(cur_point[p_route].dir & rev_dir): return false
			return true
		if !draw_queue.has(cell) && can_travel.call():
			var prev_point = cell_to_point(draw_queue[-1])
			draw_queue.append(cell)
			fuel -= 1
			if cell_to_point(cell)[p_checkpoint]: fuel += 2
			var cur_point = cell_to_point(cell)
			var dir = Direction.get_dir(prev_point[p_pos], cur_point[p_pos])
			var rev_dir = Direction.get_dir(cur_point[p_pos], prev_point[p_pos])
			print("PrevPos: %s  CurPos: %s  Dir: %s  RevDir: %s"%[prev_point[p_pos], cur_point[p_pos], dir, rev_dir])
			cur_point[p_traveled] = true
			if prev_point:
				if prev_point[p_line]:
					prev_point[p_line].dir |= dir
				else:
					prev_point[p_line] = Direction.spe_dir_gen(dir)
				cur_point[p_line] = Direction.spe_dir_gen(rev_dir)
			if cur_point[p_goal]:
				complete.emit()
			grid_ui_update()

func generate_solution(_point:Array, _traveled:Array, _avoids:Array, _fuel:int = 2):
	var traveled = _traveled
	var avoids = _avoids
	
	var forward = func() -> int:
		traveled.append(_point)
		_fuel -= 1
		print(_fuel)

		if _fuel <= 0 && _point != goal_point:
			_point[p_checkpoint] = true
			_fuel += 2
		return _fuel
	
	var rollback = func() -> int:
		var invalid_point = traveled.pop_back()
		avoids.append(invalid_point)
		if invalid_point[p_checkpoint]: _fuel -= 2
		invalid_point[p_traveled] = false
		invalid_point[p_checkpoint] = false
		invalid_point[p_route] = null
		_fuel += 1
		return _fuel
	
	var validate_checkpoints = func():
		for i in traveled:
			if i[p_checkpoint]:
				var idx = traveled.find(i)
				var adj = GridKit.get_adjacents(grid, grid_size.y, traveled[idx-1], traveled[idx+1])
				if adj.is_empty():
					i[p_route] = Direction.I_gen()
				else:
					i[p_route] = Direction.L_gen()
				traveled[idx+1][p_checkpoint] = false
	
	if traveled.is_empty():
		traveled.append(_point)
		#generate_solution(_point, traveled, avoids, _fuel)
		#return
	
	if _point == goal_point:
		traveled[-1][p_checkpoint] = false
		print(traveled)
		validate_checkpoints.call()
		return
	
	var idx = grid.find(_point)
	var traversable_neighbors:Array = GridKit.get_cardinal_neighbors(grid, grid_size.x, idx).filter(func(x): return !traveled.has(x) && !avoids.has(x))
	
	if traversable_neighbors.has(goal_point):
		_fuel = forward.call()
		generate_solution(goal_point, traveled, avoids, _fuel)
		return
	elif !traversable_neighbors.is_empty():
		_fuel = forward.call()
		generate_solution(traversable_neighbors.pick_random(), traveled, avoids, _fuel)
		return
	else:
		_fuel = rollback.call()
		generate_solution(traveled[-1], traveled, avoids, _fuel)
		return

func grid_randomize():
	for i in grid:
		if i[p_checkpoint]:
			i[p_route].rotate(true, [0, 1, 2, 3].pick_random())

func puzzle_gen(first:bool = false):
	fuel = 2
	start_point = null
	goal_point = null
	hover_cell = null
	grid_gen()
	grid_revalid()
	generate_solution(start_point, [], [], fuel)
	grid_randomize()
	if first: grid3D_gen()
	grid_ui_update()

func grid_revalid():
	if grid.map(func(x): return x[p_head]).is_empty(): start_point[p_head] = true
