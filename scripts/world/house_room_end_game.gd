extends Node3D
@onready var world_environment : WorldEnvironment = $Environment/WorldEnvironment
@onready var ui : UI = $UI
@onready var bed : Bed = $RoomAnchor/Bed

func _ready():
	Progress.in_house()
	game_is_won_setup()

func game_is_won_setup():
	world_environment.environment.sky.sky_material.set('shader_parameter/Top_Color', Color.PAPAYA_WHIP)
	world_environment.environment.sky.sky_material.set('shader_parameter/Horizon_Color', Color.PAPAYA_WHIP)
	world_environment.environment.sky.sky_material.set('shader_parameter/Bottom_Color', Color.PAPAYA_WHIP)
	ui.toggle_alarm(false)
	bed.disable_interaction()
	
