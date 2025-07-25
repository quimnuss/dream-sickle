extends Node3D

@export_enum ('dungeon_start', 'dungeon_room_1', 'dungeon_room_2', 'test_playground', 'test_iwork', 'level_2') var dungeon : String = 'dungeon_start'

var path : String

func _ready():
	if dungeon.begins_with('test_'):
		path = 'res://levels/test_rooms/' + dungeon + '.tscn'
	elif dungeon.begins_with('level'):
		path = 'res://levels/' + dungeon + '.tscn'
	else:
		path = 'res://levels/dungeons/' + dungeon + '.tscn'
	var dungeon_scene = load(path).instantiate()
	add_child(dungeon_scene)
