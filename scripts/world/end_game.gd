extends Node3D

@onready var interaction_hint: Node3D = $InteractionHint
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_in_range : bool = false

var is_consumed : bool = false

func _input(event: InputEvent) -> void:
	if is_in_range and event.is_action_pressed("interact") and not is_consumed:
		is_consumed = true
		animation_player.play("end_flyby")

func _on_interactable_area_entered(_area: Area3D) -> void:
	interaction_hint.visible = true
	is_in_range = true

func _on_interactable_area_exited(_area: Area3D) -> void:
	interaction_hint.visible = false
	is_in_range = false
