extends Resource
class_name ImgPaths

static var img_dict:Dictionary[StringName, StringName] = {
	"":"res://Images/none.tscn",
	ItemNames.wrench:"res://Images/wrench_icon.png",
	ItemNames.hammer:"res://Images/hammer.png"
}

static var wrench:StringName = img_dict[ItemNames.wrench]
static var hammer:StringName = img_dict[ItemNames.hammer]
