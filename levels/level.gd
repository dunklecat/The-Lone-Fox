extends Node2D

var is_playing : bool = false

onready var fade_effect : = $CanvasLayer/FadeEffect
onready var hud         : = $CanvasLayer/HUD


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_effect.show()
	fade_effect.fade_out()


func _on_FadeIn_fade_finished() -> void:
	fade_effect.hide()
	if not is_playing:
		is_playing = true
	else:
		get_tree().change_scene("res://ui/menus/title_screen/title_screen.tscn")

func return_to_title_menu():
	fade_effect.show()
	fade_effect.fade_in()


func _on_Player_is_dead() -> void:
	return_to_title_menu()


func _on_Player_is_hurt(new_life : int) -> void:
	hud.update_life(new_life)


func _on_PauseMenu_return_to_menu() -> void:
	return_to_title_menu()


func _on_HUD_return_to_menu() -> void:
	return_to_title_menu()


func _on_SuperBat_tree_exited() -> void:
	get_tree().call_group("enemy", "queue_free")
	hud.end_game()
