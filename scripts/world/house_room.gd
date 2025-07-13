extends Node3D

func to_dungeon():
	get_tree().change_scene_to_file("res://world/world.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		call_deferred('to_dungeon')
