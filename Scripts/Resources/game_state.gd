extends Resource
class_name GState

enum gstate_enum {
	PAUSED,
	PLAYING,
	SETTINGS,
	NONE
}

enum pstate_enum {
	TYPING,
	INSPECTING,
	SOLVING,
	CARRYING,
	CHECKING,
	COMPUTING,
	WARE,
	IDLE
}

static var game_state:int = 0
static var player_state:int = 0

static func is_paused() -> bool: return game_state == gstate_enum.PAUSED
static func is_playing() -> bool: return game_state == gstate_enum.PLAYING
static func is_none() -> bool: return game_state == gstate_enum.NONE
static func is_settings() -> bool: return game_state == gstate_enum.SETTINGS
static func is_idling() -> bool: return player_state == pstate_enum.IDLE
static func is_typing() -> bool: return player_state == pstate_enum.TYPING
static func is_inspecting() -> bool: return player_state == pstate_enum.INSPECTING
static func is_solving() -> bool: return player_state == pstate_enum.SOLVING
static func is_carrying() -> bool: return player_state == pstate_enum.CARRYING
static func is_checking() -> bool: return player_state == pstate_enum.CHECKING
static func is_computing() -> bool: return player_state == pstate_enum.COMPUTING
static func is_ware() -> bool: return player_state == pstate_enum.WARE


static func pause(): game_state = gstate_enum.PAUSED
static func play(): game_state = gstate_enum.PLAYING
static func none(): game_state = gstate_enum.NONE
static func settings(): game_state = gstate_enum.SETTINGS
static func idle(): player_state = pstate_enum.IDLE
static func type(): player_state = pstate_enum.TYPING
static func inspect(): player_state = pstate_enum.INSPECTING
static func solve(): player_state = pstate_enum.SOLVING
static func carry(): player_state = pstate_enum.CARRYING
static func check(): player_state = pstate_enum.CHECKING
static func compute(): player_state = pstate_enum.COMPUTING
static func ware(): player_state = pstate_enum.WARE
