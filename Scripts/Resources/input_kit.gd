extends Resource
class_name InputKit

static func press(input:Input, event:StringName, pressed:bool = true) -> bool:
	if pressed: return input.is_action_pressed(event)
	else: return input.is_action_just_released(event)
