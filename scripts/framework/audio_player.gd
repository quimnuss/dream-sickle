extends Node
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var min_volume : float = -80.0

var last_value : float = 1.0

func set_volume(ratio : float):
	last_value = ratio
	print(ratio)
	audio_stream_player.set_volume_linear(ratio)

func mute(toggled_on : float = true):
	if not toggled_on:
		self.set_volume(last_value)
	else:
		audio_stream_player.set_volume_linear(0.0)
