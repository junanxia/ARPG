extends Control

var hearts = 4 : set= set_hearts
var max_hearts = 4: set = set_max_hearts

@onready var heart_ui_empty: TextureRect = $HeartUIEmpty
@onready var heart_ui_full: TextureRect = $HeartUIFull

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full != null:
		heart_ui_full.size.x = hearts * 15

func set_max_hearts(value):
	print('max herts:', value)
	max_hearts = value
	self.hearts = min(hearts, max_hearts)
	if heart_ui_empty != null:
		heart_ui_empty.size.x = value * 15

func _ready() -> void:
	max_hearts = PlayerStats.max_health
	hearts = PlayerStats.health 
	
	PlayerStats.connect("health_changed", Callable(self, "set_hearts"))
	PlayerStats.connect("max_health_changed", Callable(self, "set_max_hearts"))
