extends Resource
class_name CharBB

enum char_type {PLAYER, NPC}

var dir:Vector3

static func generate_bb(_type:char_type, bb:Blackboard):
	bb.set_var(BBNames.direction, Vector3(0, 0, 0))
	bb.set_var(BBNames.health, float(100))
