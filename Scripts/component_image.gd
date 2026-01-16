extends SubViewportContainer
class_name ComponentImage

@onready var svp: SubViewport = $SubViewport
@onready var cam: Camera3D = $SubViewport/Camera3D
@onready var inspect_item: MeshInstance3D = $SubViewport/MeshInstance3D

func _ready() -> void:
	svp.world_3d = preload("res://Worlds/inspect_item_world.tres")

#func _process(delta: float) -> void:
	#if visible: inspect_item.rotation += Vector3(0, delta, 0)

func close():
	visible = false
	svp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	process_mode = Node.PROCESS_MODE_DISABLED

func open():
	visible = true
	svp.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
	process_mode = Node.PROCESS_MODE_PAUSABLE
	adjust_cam(inspect_item.mesh.get_aabb())

func set_item(mesh:Mesh):
	inspect_item.mesh = mesh
	open()

func adjust_cam(aabb:AABB):
	var _size = aabb.get_longest_axis_size()
	var fov_rad = deg_to_rad(cam.fov)
	var distance:float = (_size/2.0)/tan(fov_rad/2.0)
	var padding = 0.5
	distance *= padding
	cam.position.z = distance
	cam.look_at(aabb.get_center())

func get_inspect_mesh() -> Mesh:
	if inspect_item.mesh:
		return inspect_item.mesh
	else: return null

func has_item() -> bool:
	return inspect_item.mesh != null

func remove_item():
	inspect_item.mesh = null
	close()
