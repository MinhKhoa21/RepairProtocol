extends Node3D

@export var INTENSITY: float = 4.0
func _ready() -> void:
	scale = Vector3(3, 3, 3)
	# 🔊 Play âm thanh
	var sound = $BreakSound
	if sound:
		sound.play()

	## 💨 Phát khói
	#var smoke = $SmokeParticles
	#if smoke and smoke is GPUParticles3D:
		#smoke.emitting = true

	# 💥 Áp lực lên các mảnh vỡ
	for child in get_children():
		if child is RigidBody3D:
			for g in child.get_children():
				if g is CollisionShape3D or g is MeshInstance3D:
					g.scale *= 1.3  # hoặc Vector3(2, 2, 2)
			var piece: RigidBody3D = child
			piece.apply_impulse(piece.get_child(0).position * INTENSITY, self.global_position)

	# ⏱️ Xoá sau 5 giây
	await get_tree().create_timer(5).timeout
	queue_free()
