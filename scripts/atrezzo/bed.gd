class_name Bed
extends Node3D

@export var level : PackedScene = preload("res://levels/final_levels/world_level_tutorial.tscn")
@onready var interactable_collision_shape_3d: CollisionShape3D = $Interactable/CollisionShape3D

@onready var interaction_hint: Node3D = $InteractionHint

var is_in_range : bool = false

func _input(event: InputEvent) -> void:
	if is_in_range and event.is_action_pressed("interact"):
		Progress.to_dungeon()
		level = load(Progress.current_level)
		get_tree().change_scene_to_packed(level)

func disable_interaction():
	interactable_collision_shape_3d.disabled = true


func _on_interactable_area_entered(_area: Area3D) -> void:
	interaction_hint.visible = true
	is_in_range = true

func _on_interactable_area_exited(_area: Area3D) -> void:
	interaction_hint.visible = false
	is_in_range = false
