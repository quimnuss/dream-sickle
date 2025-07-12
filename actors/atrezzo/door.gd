class_name Door extends Node3D

var is_open : bool = false
@export var is_locked : bool = false

var open_tween : Tween
var close_tween : Tween

func open():
	if open_tween:
		open_tween.kill()
	if close_tween:
		close_tween.kill()
	is_locked = false
	is_open = true
	open_tween = get_tree().create_tween()
	open_tween.tween_property(self, 'position:y', -2, 3)

func close():
	if open_tween:
		open_tween.kill()
	if close_tween:
		close_tween.kill()
	is_open = false
	close_tween = get_tree().create_tween()
	close_tween.tween_property(self, 'position:y', 0, 0.5)

func close_and_lock():
	is_locked = true
	close()

func _on_player_sensor_body_entered(body: Node3D) -> void:
	if not is_locked and not is_open and body is Player:
		open()
