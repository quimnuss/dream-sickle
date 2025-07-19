class_name Bed
extends Node3D

@export var level : PackedScene = preload("res://levels/world.tscn")
@export_enum ('dungeon_start', 'dungeon_room_1', 'dungeon_room_2', 'test_playground', 'test_iwork', 'test_game_loop_clicli') var debug_dungeon : String = 'dungeon_start'
@export var go_to_debug_scene : bool = false
@onready var interactable_collision_shape_3d: CollisionShape3D = $Interactable/CollisionShape3D

@onready var label_3d: Label3D = $Label3D

var debug_dungeon_scene : PackedScene

var is_in_range : bool = false

func _ready():
	var path : String = 'res://levels/dungeons/' + debug_dungeon + '.tscn' if not debug_dungeon.begins_with('test_') else 'res://levels/test_rooms/' + debug_dungeon + '.tscn'
	
	if not OS.is_debug_build():
		go_to_debug_scene = false
	else:
		debug_dungeon_scene = load(path)

func _input(event: InputEvent) -> void:
	if is_in_range and event.is_action_pressed("interact"):
		Progress.to_dungeon()
		if go_to_debug_scene:
			get_tree().change_scene_to_packed(debug_dungeon_scene)
		else:
			get_tree().change_scene_to_packed(level)

func disable_interaction():
	interactable_collision_shape_3d.disabled = true


func _on_interactable_area_entered(_area: Area3D) -> void:
	label_3d.visible = true
	is_in_range = true

func _on_interactable_area_exited(_area: Area3D) -> void:
	label_3d.visible = false
	is_in_range = false
