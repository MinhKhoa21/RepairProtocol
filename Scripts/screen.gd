extends Sprite3D
class_name Screen

var label:Label
var line_edit:LineEdit
var input_text:String

func _ready() -> void:
	label = $SubViewport/Container/Label
	line_edit = $SubViewport/Container/LineEdit
	#line_edit.text_submitted.connect(func(_str):
		#input_text = _str
		#print(input_text)
		#)

func set_text(_str:String): label.text = _str

func type():
	GState.type()
	line_edit.grab_focus()
	line_edit.edit()

func _input(event: InputEvent) -> void:
	if !GState.is_typing(): return
	$SubViewport.push_input(event)

func check_password(): pass
