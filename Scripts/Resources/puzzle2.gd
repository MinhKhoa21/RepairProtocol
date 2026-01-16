extends Node3D
class_name Puzzle

enum type {panel, pipe}

signal open_puzzle
signal close_puzzle
signal complete
signal create_puzzle

@export var puzzle_type:type

func _ready():
	open_puzzle.connect(GState.solve)
	Watcher.game_state_changed.connect(func(a):
		if a != GState.gstate_enum.SOLVING:
			close_puzzle.emit()
		)
