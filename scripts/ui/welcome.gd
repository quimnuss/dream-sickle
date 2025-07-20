extends Control

@onready var front_color_rect: ColorRect = $FrontColorRect
@onready var color_rect: ColorRect = $ColorRect
@onready var text_label: RichTextLabel = $PanelContainer/RichTextLabel
@onready var panel_container: PanelContainer = $PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_label.visible_ratio = 0
	panel_container.size.x = 1
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(front_color_rect, 'modulate:a', 0, 3).from(1)
	tween.tween_callback(func() : panel_container.visible = true)
	tween.tween_property(panel_container, 'size:x', 600, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(text_label, 'visible_ratio', 1, 2).from(0)
	tween.tween_property(text_label, 'visible_ratio', 0, 2).set_delay(3)
	tween.tween_property(panel_container, 'size:x', 0, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func() : panel_container.visible = false)
