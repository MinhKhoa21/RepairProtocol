extends Resource
class_name Direction

static var left:int = 1
static var up:int = 1<<1
static var right:int = 1<<2
static var down:int = 1<<3

var dir:int = left:
	set = set_dir
var dir_arr:Array = [true, false, false, false] #[left, up, right, down]

func rotate(rot_right:bool = true, times:int = 1):
	for i in times:
		if rot_right:
			dir = ((dir >> 1) & 0b1111) | ((dir & 1) << 3)
		else:
			dir = ((dir << 1) & 0b1111) | ((dir >>3) & 1)

func has_left() -> bool: return dir & left
func has_up() -> bool: return dir & up
func has_right() -> bool: return dir & right
func has_down() -> bool: return dir & down

func ran_gen():
	dir = [left, up, right, down].pick_random()
	if MathKit.chance_trigger(0.5): dir = [left, up, right, down].filter(func(x): return x != dir).pick_random()

static func ran_dir_gen() -> Direction:
	var _dir:Direction = Direction.new()
	_dir.ran_gen()
	return _dir

static func spe_dir_gen(_int:int) -> Direction:
	var _dir:Direction = Direction.new()
	_dir.dir = _int
	return _dir

func set_dir(a):
	dir = a
	dir_arr = dir_arr.map(func(x): x = false; return x)
	if has_left(): dir_arr[0] = true
	if has_up(): dir_arr[1] = true
	if has_right(): dir_arr[2] = true
	if has_down(): dir_arr[3] = true

static func get_dir(from_pos:Vector2i, to_pos:Vector2i) -> int:
	var velo = to_pos - from_pos
	match velo:
		Vector2i(0, -1): return left
		Vector2i(-1, 0): return up
		Vector2i(0, 1): return right
		Vector2i(1, 0): return down
		_: return left

static func I_gen() -> Direction:
	var _dir = Direction.new()
	_dir.dir = up | down
	return _dir

static func L_gen() -> Direction:
	var _dir = Direction.new()
	_dir.dir = up | right
	return _dir
