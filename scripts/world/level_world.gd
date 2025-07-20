extends Node3D

@export_enum ('level_tutorial','level_zigzag', 'level_gettrolling', 'level_2',  'level_speed', 'level_precision', 'level_lastlevel_ascend') var dungeon : String = 'level_tutorial'
@onready var level_anchor: Node3D = $LevelAnchor

var path : String

func _ready():
	Progress.to_dungeon()
	if dungeon.begins_with('test_'):
		path = 'res://levels/test_rooms/' + dungeon + '.tscn'
	elif dungeon.begins_with('level'):
		path = 'res://levels/' + dungeon + '.tscn'
	else:
		path = 'res://levels/dungeons/' + dungeon + '.tscn'

	var level = load(path).instantiate()
	level_anchor.add_child(level)
