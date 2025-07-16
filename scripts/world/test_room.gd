extends Node3D

@export_enum ('dungeon_start', 'dungeon_room_1', 'dungeon_room_2', 'test_playground', 'test_iwork') var dungeon : String = 'dungeon_start'

func _ready():
	var path : String = 'res://levels/dungeons/' + dungeon + '.tscn' if not dungeon.begins_with('test_') else 'res://levels/test_rooms/' + dungeon + '.tscn'
	var dungeon_scene = load(path).instantiate()
	add_child(dungeon_scene)
