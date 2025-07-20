extends Node3D

@export_enum ('level_tutorial', 'level_2', 'level_zigzag', 'level_gettrolling', 'level_speed', 'level_precision', 'level_lastlevel_ascend') var dungeon : String = 'level_tutorial'

var path : String

var use_level_world : bool = true

@export var is_back_door : bool = false

func _ready():
	if dungeon.begins_with('test_'):
		path = 'res://levels/test_rooms/' + dungeon + '.tscn'
	elif dungeon.begins_with('level'):
		path = 'res://levels/' + dungeon + '.tscn'
	else:
		path = 'res://levels/dungeons/' + dungeon + '.tscn'

func change_to_level():
	prints('Changing to level',path)
	get_tree().change_scene_to_file(path)

func _on_door_teleport_sensor_body_entered(body: Node3D) -> void:
	if body is Player:
		if use_level_world:
			path = 'res://levels/final_levels/world_' + dungeon + '.tscn'
			if not is_back_door:
				Progress.level_completed(path)
			else:
				Progress.reset_level(path)
		call_deferred('change_to_level')
