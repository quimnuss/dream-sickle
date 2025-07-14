extends Area3D

@export var respawn_point : Node3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.global_position = respawn_point.global_position
	else:
		body.call_deferred('queue_free')
