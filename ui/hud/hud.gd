extends Control

signal return_to_menu


onready var final_message : Control = $FinalMessage
onready var life_bar : TextureProgress = $LifeBar

onready var scene_tree = get_tree()

func _ready() -> void:
	life_bar.value = life_bar.max_value


func update_life(new_value : int) -> void:
	life_bar.value = new_value


func end_game() -> void:
	# scene_tree.paused = true
	final_message.visible = true
	yield(get_tree().create_timer(3), "timeout")
	emit_signal("return_to_menu")

