extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.reset()
	else:
		body.call_deferred('queue_free')
