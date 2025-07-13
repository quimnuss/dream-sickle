extends Node3D

@export_enum ('dungeon_start', 'dungeon_room_1') var dungeon : String = 'dungeon_start'

func _ready():
	var path : String = 'res://levels/dungeons/' + dungeon + '.tscn'
	var dungeon_scene = load(path).instantiate()
	add_child(dungeon_scene)
