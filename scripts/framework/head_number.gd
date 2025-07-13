extends Label3D




func _on_player_health_changed(health: int) -> void:
	set_text('<3 %d' % health)
