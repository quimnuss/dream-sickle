extends Control
@onready var text_label: RichTextLabel = $RichTextLabel
@onready var front_color_rect: ColorRect = $FrontColorRect
@onready var color_rect: ColorRect = $ColorRect
@onready var skip_button: Button = $SkipButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skip_button.grab_focus()
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(text_label, 'visible_ratio', 1, 2).from(0)
	tween.tween_callback(next_text).set_delay(3)
	tween.tween_property(text_label, 'visible_ratio', 1, 2).from(0)
	tween.tween_property(front_color_rect, 'modulate:a', 1, 3).from(0).set_delay(2)
	tween.tween_callback(hide_everything)
	tween.tween_property(color_rect, 'modulate:a', 0, 3).from(1).set_delay(1)
	tween.tween_callback(queue_free).set_delay(3)

func next_text():
	text_label.visible_ratio = 0
	text_label.set_text("I wish the day would [fade start=3][i]just start[/i][/fade][pulse].[/pulse]")

func hide_everything():
	text_label.queue_free()
	front_color_rect.queue_free()
	
func _on_skip_button_pressed() -> void:
	self.queue_free()
