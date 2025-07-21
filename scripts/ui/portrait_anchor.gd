extends Control

@export var worry_threshold : float = 60.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	Progress.time_left_changed.connect(_on_time_left_changed)
	Progress.back_in_house.connect(_on_back_home)
	animated_sprite_2d.play('worried')

func _on_back_home():
	if Progress.is_in_house:
		if Progress.is_game_won:
			animated_sprite_2d.play('default')
		else:
			animated_sprite_2d.play('worried')

func _on_time_left_changed(time_left):
	if Progress.is_in_house:
		if Progress.is_game_won:
			animated_sprite_2d.play('default')
		else:
			animated_sprite_2d.play('worried')
	elif time_left < worry_threshold:
		match int(4*time_left/worry_threshold):
			0:
				animated_sprite_2d.play('panic')
			1:
				animated_sprite_2d.play('stressed')
			2:
				animated_sprite_2d.play('worried')
			_:
				animated_sprite_2d.play('worried')
