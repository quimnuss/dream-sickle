extends Node3D


@onready var entry_marker: Marker3D = $EntryMarker

func _on_kill_zone_body_entered(body: Node3D) -> void:
	if body is Player:
		body.global_position = entry_marker.global_position
	else:
		body.queue_free()
