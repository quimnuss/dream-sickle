extends Node3D

@onready var label_3d: Label3D = $Label3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var is_in_range : bool = false


func _input(event: InputEvent) -> void:
	if is_in_range and event.is_action_pressed("interact"):
		animation_player.play("end_flyby")
		
		

func _on_interactable_area_entered(_area: Area3D) -> void:
	label_3d.visible = true
	is_in_range = true

func _on_interactable_area_exited(_area: Area3D) -> void:
	label_3d.visible = false
	is_in_range = false
