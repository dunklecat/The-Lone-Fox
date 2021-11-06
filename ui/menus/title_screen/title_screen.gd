extends Control

var scene : String

onready var fade_effect : ColorRect = $FadeEffect

func _ready() -> void:
	fade_effect.show()
	fade_effect.fade_out()
	fade_effect.hide()

func _on_New_Game_pressed() -> void:
	fade_effect.show()
	fade_effect.fade_in()
	scene = "res://levels/level.tscn"


func _on_FadeIn_fade_finished() -> void:
	fade_effect.hide()
	var _error : = get_tree().change_scene(scene)


func _on_Exit_pressed() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
