extends Node3D

@export var bonus_time : float = 5
@onready var anchor: Node3D = $Anchor

var is_consumed : bool = false

func _ready():
	
	var tween : Tween = create_tween().set_loops()
	tween.tween_property(anchor, 'position:y', 0.4, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(anchor, 'position:y', 0, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	var tween_rot : Tween = create_tween().set_loops()
	tween_rot.tween_property(anchor, 'rotation:y', 2*PI, 5).from(0)


func _on_player_sensor_body_entered(body: Node3D) -> void:
	if body is Player and not is_consumed:
		Progress.time_left += bonus_time
		is_consumed = true
		var label := preload("res://scenes/atrezzo/pickup_text.tscn").instantiate()
		label.set_text("+%d" % bonus_time)
		get_parent().add_child(label)
		label.global_position = self.global_position
		self.call_deferred('queue_free')
