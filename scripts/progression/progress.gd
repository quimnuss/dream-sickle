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

var is_game_won : bool = false
var level : int = 0

var current_level : String = 'res://levels/final_levels/world_level_tutorial.tscn'

signal time_left_changed(time_left_value : float)
signal time_up

signal speed_changed(speed_value : float)

signal back_in_house
signal entered_the_dungeon

signal game_won

var is_in_house : bool = true

func in_house():
	is_in_house = true
	back_in_house.emit()
	time_left = base_time

func to_dungeon():
	is_in_house = false
	entered_the_dungeon.emit()

func win():
	is_game_won = true
	game_won.emit()
	in_house()
	self.call_deferred('load_win_house')

func load_win_house():
	get_tree().change_scene_to_file("res://levels/house_room_ending.tscn")

func _physics_process(delta: float) -> void:
	if not is_in_house and not is_game_won:
		time_left -= delta
