extends Node3D

@export var destination : Node3D


func _on_door_teleport_sensor_body_entered(body: Node3D) -> void:
	if body is Player:
		body.global_position = destination.global_position
