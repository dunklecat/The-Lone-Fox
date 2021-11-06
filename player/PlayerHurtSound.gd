extends AudioStreamPlayer

func _ready():
	var _error : = connect("finished", self, "queue_free")
