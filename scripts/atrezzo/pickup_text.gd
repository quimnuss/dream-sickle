extends Label3D


func _ready() -> void:
	var tween : Tween = create_tween().set_parallel(true)
	tween.tween_property(self, 'position:y', 2, 1)
	tween.tween_property(self, 'scale', Vector3(2,2,2), 1)
	tween.chain().tween_callback(queue_free)
