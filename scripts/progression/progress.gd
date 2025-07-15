extends Node

@export var base_time : int = 100
@export var time_left : float = base_time :
	set(new_time):
		time_left = new_time
		time_left_changed.emit(time_left)
		
signal time_left_changed(time_left_value : float)

func _physics_process(delta: float) -> void:
	time_left -= delta
