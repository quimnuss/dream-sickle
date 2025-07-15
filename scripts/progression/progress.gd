extends Node

@export var base_time : int = 100
@export var time_left : float = base_time :
	set(new_time):
		time_left = new_time
		if time_left <= 0:
			time_left = 0
			time_up.emit()
			time_left = base_time
		time_left_changed.emit(time_left)
signal time_left_changed(time_left_value : float)
signal time_up

func _physics_process(delta: float) -> void:
	time_left -= delta
