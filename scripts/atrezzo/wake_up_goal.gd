extends Node3D


func _on_player_sensor_body_entered(body: Node3D) -> void:
	Progress.win()
