extends Control
class_name CControl

@onready var og_pos = position
##This function is considered show().
##Direction left:0, up:1, right:2, down:3
func set_show_and_hide_pos(): pass

func ease_show(direction:int, duration:float):
	var viewport_size = get_viewport_rect().size
	var rect_size = get_rect().size
	var tween = create_tween()
	match direction:
		1: position.y = viewport_size.y
		2: position.x = -rect_size.x
		3: position.y = -rect_size.y
		_: position.x = viewport_size.x
	show()
	tween.tween_property(self, "position", og_pos, duration)

func ease_hide(direction:int, duration:float):
	var viewport_size = get_viewport_rect().size
	var rect_size = get_rect().size
	var goal_pos:Vector2 = og_pos
	var tween = create_tween()
	match direction:
		1: goal_pos.y = -rect_size.y
		2: goal_pos.x = viewport_size.x
		3: goal_pos.y = viewport_size.y
		_: goal_pos.x = -rect_size.x
	tween.tween_property(self, "position", goal_pos, duration)
	tween.finished.connect(func():
		hide()
		position = og_pos
		)
