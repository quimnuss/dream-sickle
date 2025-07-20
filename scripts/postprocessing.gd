extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect

var threshold : float = 10.0


func _ready() -> void:
	Progress.time_left_changed.connect(_on_time_left_changed)

func _on_time_left_changed(new_time_left : float):
	if new_time_left < threshold:
		self.visible = true
		var ratio : float = 1 - new_time_left/threshold
		set_shader_value(ratio)
	else:
		self.visible = false
		color_rect.material.set_shader_parameter("resolution:x", 320);
		color_rect.material.set_shader_parameter("resolution:x", 180);

func set_shader_value(ratio : float):
	# in my case i'm tweening a shader on a texture rect, but you can use anything with a material on it
	color_rect.material.set_shader_parameter("resolution", (1 - ratio) * Vector2(1180, 720));
