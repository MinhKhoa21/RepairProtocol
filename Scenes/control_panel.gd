extends Puzzle

@onready var energy_slider: HSlider = $ControlPanel/VBoxContainer/HBoxContainer/HSlider
@onready var coolant_slider: HSlider = $ControlPanel/VBoxContainer/HBoxContainer2/HSlider
@onready var gear_slider: HSlider = $ControlPanel/VBoxContainer/HBoxContainer3/HSlider
@onready var energy_label: Label = $ControlPanel/VBoxContainer/HBoxContainer/Label2
@onready var coolant_label: Label = $ControlPanel/VBoxContainer/HBoxContainer2/Label2
@onready var gear_label: Label = $ControlPanel/VBoxContainer/HBoxContainer3/Label2

@onready var control_panel: CControl = $ControlPanel
var goal_energy_val:float = 100
var goal_coolant_val:float = 100
var goal_gear_val:float = 100

func _ready() -> void:
	super()
	control_panel.hide()
	var tempt_dict = {energy_slider:energy_label, coolant_slider:coolant_label, gear_slider:gear_label}
	for i in tempt_dict:
		i.value_changed.connect(func(x):
			tempt_dict[i].text = "%s"%x
			check_win()
			)
	create_puzzle.connect(puzzle_gen)
	open_puzzle.connect(control_panel.ease_show.bind(1, 0.4))
	close_puzzle.connect(control_panel.ease_hide.bind(3, 0.4))

func puzzle_gen():
	energy_slider.value = snappedf(randf_range(0, 100), 5)
	coolant_slider.value = snappedf(randf_range(0, 100), 5)
	gear_slider.value = snappedf(randf_range(0, 100), 25)
	goal_energy_val = snappedf(randf_range(0, 100), 5)
	goal_coolant_val = snappedf(randf_range(0, 100), 5)
	goal_gear_val = snappedf(randf_range(0, 100), 25)
	set_readings()

func check_win():
	if (
		energy_slider.value == goal_energy_val &&
		coolant_slider.value == goal_coolant_val &&
		gear_slider.value == goal_gear_val
	): complete.emit()

func get_correct_setting() -> Array:
	return [goal_energy_val, goal_coolant_val, goal_gear_val]

func set_readings():
	$ControlPanel/Readings/Energy.text = "%s"%goal_energy_val
	$ControlPanel/Readings/Coolant.text = "%s"%goal_coolant_val
	$ControlPanel/Readings/Gear.text = "%s"%goal_gear_val
