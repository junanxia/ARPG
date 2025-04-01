extends AudioStreamPlayer

func _ready():
	self.connect("finished", Callable(self, "queue_free"))
