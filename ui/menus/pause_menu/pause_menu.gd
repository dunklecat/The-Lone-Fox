extends Control

signal return_to_menu

var is_paused  : bool = false setget set_is_paused

onready var scene_tree = get_tree()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.is_paused = not is_paused
		scene_tree.set_input_as_handled()


func set_is_paused(value : bool) -> void:
	is_paused = value
	scene_tree.paused = value
	self.visible = value


func _on_ContinueButton_pressed() -> void:
	self.is_paused = false


func _on_ReturnButton_pressed() -> void:
	self.is_paused = false
	emit_signal("return_to_menu")


func _on_ExitButton_pressed() -> void:
	self.is_paused = false
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
