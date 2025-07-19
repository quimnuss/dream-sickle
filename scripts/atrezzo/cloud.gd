extends Node3D

@export var base_speed : float = 2.0
@export var speed_multiplier : float = 1.0

func _ready():
	var tween : Tween = create_tween().set_loops()
	tween.tween_property(self, 'position:x', 50, 75/(base_speed*speed_multiplier))
	tween.tween_callback(func(): self.position.x = -25)
