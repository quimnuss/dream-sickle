extends Node3D

@export_enum ('level_tutorial', 'level_2', 'level_zigzag', 'level_gettrolling', 'level_lastlevel_ascend') var dungeon : String = 'level_tutorial'

var path : String

var use_level_world : bool = true

func _ready():
	if dungeon.begins_with('test_'):
		path = 'res://levels/test_rooms/' + dungeon + '.tscn'
	elif dungeon.begins_with('level'):
		path = 'res://levels/' + dungeon + '.tscn'
	else:
		path = 'res://levels/dungeons/' + dungeon + '.tscn'

func change_to_level():
	get_tree().change_scene_to_file(path)

func _on_door_teleport_sensor_body_entered(body: Node3D) -> void:
	if body is Player:
		if use_level_world:
			path = 'res://levels/final_levels/world_' + dungeon + '.tscn'
			Progress.current_level = path
		call_deferred('change_to_level')
