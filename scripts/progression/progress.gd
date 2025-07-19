extends Node
# TODO this does not need to be a singleton, since we don't wanna go down if we're home

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

signal back_in_house
signal entered_the_dungeon

var is_in_house : bool = false

func in_house():
	back_in_house.emit()
	time_left = base_time
	is_in_house = true

func to_dungeon():
	entered_the_dungeon.emit()
	is_in_house = false

func _physics_process(delta: float) -> void:
	if not is_in_house:
		time_left -= delta
