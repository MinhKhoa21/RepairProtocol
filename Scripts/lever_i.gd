extends InteractArea
class_name Lever

var on:bool = false

func _ready() -> void:
	interacted.connect(interact)

func interact():
	var ani:AnimationPlayer = $"../AnimationPlayer"
	ani.play("flip", -1, 1, on)
	on = !on
	add_child(TimerKit.generate_timer(ani.current_animation_length, func():
		ani.stop(true)
		#on = !on
		))
