extends Node2D

const GrassEffect : PackedScene = preload("res://effects/grass_effect/grass_effect.tscn")

func create_grass_effect() -> void:
	var grassEffect : Node2D = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position
	queue_free()

func _on_Hurtbox_area_entered(_area) -> void:
	create_grass_effect()
	queue_free()
