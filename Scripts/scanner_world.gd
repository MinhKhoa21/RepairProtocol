extends Control

func _ready():
	Watcher.cargo_assigned.connect(func():
		var cargo = Watcher.cargo[0]
		if cargo is Dictionary && (cargo as Dictionary).keys().has("ship_hologram"):
			$SubViewportContainer/SubViewport/shipver2Hologram.global_transform = cargo[0].global_transform
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		)
	
	#Watcher.game_state_changed.connect(func(a):
		#if GState.is_checking():
			#visible = true
		#else: visible = false
		#)

func _process(delta: float) -> void:
	visible = $SubViewportContainer/SubViewport/Camera3D/RayCast3D.is_colliding()
