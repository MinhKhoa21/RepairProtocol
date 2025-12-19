extends UIPuzzle

@onready var energy_slider: HSlider = $VBoxContainer/HBoxContainer/HSlider
@onready var coolant_slider: HSlider = $VBoxContainer/HBoxContainer2/HSlider
@onready var gear_slider: HSlider = $VBoxContainer/HBoxContainer3/HSlider
var goal_energy_val:float = 100
var goal_coolant_val:float = 100
var goal_gear_val:float = 100

func _ready():
	energy_slider.value = randf_range(0, 100)
	coolant_slider.value = randf_range(0, 100)
	gear_slider.value = snappedf(randf_range(0, 100), 25)
	goal_energy_val = randf_range(0, 100)
	goal_coolant_val = randf_range(0, 100)
	goal_gear_val = snappedf(randf_range(0, 100), 25)
