extends Resource
class_name AniTimes

static var take_powercell_start:float = 0.4
static var take_powercell_short_full:float = 1.2
static var open_case_start:float = 0.3
static var open_case_full:float = 1.25
static var take_powercell_speed:float = 0.7
static var hammer_action_full:float = 0.7083

static var time_from_name:Dictionary[StringName, float] = {
	"":0,
	ItemNames.hammer:hammer_action_full,
	ItemNames.wrench:2,
	"take_powercell_short_full":take_powercell_short_full
}
