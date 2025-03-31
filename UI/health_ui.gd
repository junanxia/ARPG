extends Control

var hearts = 4 : set= set_hearts
var max_hearts = 4: set = set_max_hearts

@onready var heart_ui_empty: TextureRect = $HeartUIEmpty
@onready var heart_ui_full: TextureRect = $HeartUIFull

func set_hearts(value):
	print("hearts:", value)
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full != null:
		print('xxxxx')
		heart_ui_full.size.x = hearts * 15
		print('asd;jfaskdf:', heart_ui_full.size.x)
	else:
		print('yyyyy')

func set_max_hearts(value):
	max_hearts = max(value, 1)

func _ready() -> void:
	hearts = PlayerStats.health 
	max_hearts = PlayerStats.max_health
	
	heart_ui_empty.size.x = max_hearts * 15
	heart_ui_full.size.x = hearts * 15
	
	PlayerStats.connect("health_changed", Callable(self, "set_hearts"))
