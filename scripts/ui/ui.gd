class_name UI
extends Control

@onready var alarm_text: RichTextLabel = %AlarmAnchor/AlarmText
@onready var alarm_anchor: Control = %AlarmAnchor
@onready var menu_container: VBoxContainer = %MenuContainer
@onready var panel_container: PanelContainer = $UpperRightAnchor/PanelContainer
@onready var exit_button: Button = %ExitButton
@onready var speed_label: Label = %SpeedLabel
@onready var ui_top_anchor: Control = $UITopAnchor
@onready var color_rect: ColorRect = $UITopAnchor/AlarmAnchor/ColorRect

var last_time : float = Progress.base_time

func _ready():
	Progress.time_left_changed.connect(_on_time_left_updated)
	Progress.speed_changed.connect(_on_speed_changed)
	ui_top_anchor.visible = not Progress.is_in_house

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('exit'):
		if menu_container.visible:
			get_tree().quit(0)
		else:
			_on_hamburger_button_pressed()
			exit_button.grab_focus()

func toggle_alarm(new_visible : bool):
	ui_top_anchor.visible = new_visible

func _on_time_left_updated(new_time : float):
	if new_time < 10:
		if color_rect.color != Color.RED:
			var tween : Tween = create_tween()
			tween.tween_property(alarm_anchor, "scale", Vector2(1.0,1.0), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		color_rect.color = Color.RED
	else:
		color_rect.color = Color.WEB_GREEN
	alarm_text.text = "%02dx%02d" % [int(floor(new_time)) / 60, int(floor(new_time)) % 60]
	
	if new_time > last_time:
		var tween : Tween = create_tween()
		tween.tween_property(alarm_anchor, "scale", Vector2(1.0,1.0), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(alarm_anchor, "scale", Vector2(0.5, 0.5), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN).set_delay(0.6)

	last_time = new_time

func _on_speed_changed(speed_value : float):
	speed_label.text = "Speed %d" % (speed_value*10)


func _on_hamburger_button_pressed() -> void:
	menu_container.visible = not menu_container.visible


func _on_volume_slider_value_changed(value: float) -> void:
	AudioPlayer.set_volume(value)


func _on_mute_button_toggled(toggled_on: bool) -> void:
	AudioPlayer.mute(toggled_on)


func _on_exit_button_pressed() -> void:
	get_tree().quit(0)
