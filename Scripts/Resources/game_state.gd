extends Resource
class_name GState

enum gstate_enum {
	PAUSED,
	PLAYING,
	TYPING,
	INSPECTING,
	SOLVING,
	CARRYING,
	CHECKING,
	COMPUTING,
	WARE
}

static var game_state:int = 0

static func is_paused() -> bool: return game_state == gstate_enum.PAUSED
static func is_playing() -> bool: return game_state == gstate_enum.PLAYING
static func is_typing() -> bool: return game_state == gstate_enum.TYPING
static func is_inspecting() -> bool: return game_state == gstate_enum.INSPECTING
static func is_solving() -> bool: return game_state == gstate_enum.SOLVING
static func is_carrying() -> bool: return game_state == gstate_enum.CARRYING
static func is_checking() -> bool: return game_state == gstate_enum.CHECKING
static func is_computing() -> bool: return game_state == gstate_enum.COMPUTING
static func is_ware() -> bool: return game_state == gstate_enum.WARE


static func pause(): game_state = gstate_enum.PAUSED
static func play(): game_state = gstate_enum.PLAYING
static func type(): game_state = gstate_enum.TYPING
static func inspect(): game_state = gstate_enum.INSPECTING
static func solve(): game_state = gstate_enum.SOLVING
static func carry(): game_state = gstate_enum.CARRYING
static func check(): game_state = gstate_enum.CHECKING
static func compute(): game_state = gstate_enum.COMPUTING
static func ware(): game_state = gstate_enum.WARE
