extends Control

@onready var alarm_text: RichTextLabel = $AlarmAnchor/AlarmText
@onready var alarm_anchor: Control = $AlarmAnchor
@onready var menu_container: VBoxContainer = %MenuContainer
@onready var panel_container: PanelContainer = $UpperRightAnchor/PanelContainer

var last_time : float = Progress.base_time

func _ready():
	Progress.time_left_changed.connect(_on_time_left_updated)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('exit'):
		if menu_container.visible:
			get_tree().quit(0)
		else:
			_on_hamburger_button_pressed()

func _on_time_left_updated(new_time : float):
	if new_time < 10:
		alarm_text.text = "[color=Crimson]%02d %02d[/color]" % [int(floor(new_time)) / 60, int(floor(new_time)) % 60]
	else:
		alarm_text.text = "[color=Yellowgreen]%02d %02d[/color]" % [int(floor(new_time)) / 60, int(floor(new_time)) % 60]
	
	if new_time > last_time:
		var tween : Tween = create_tween()
		tween.tween_property(alarm_anchor, "scale", Vector2(1.5,1.5), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(alarm_anchor, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN).set_delay(0.6)
	
	last_time = new_time
		


func _on_hamburger_button_pressed() -> void:
	menu_container.visible = not menu_container.visible


func _on_volume_slider_value_changed(value: float) -> void:
	AudioPlayer.set_volume(value)


func _on_mute_button_toggled(toggled_on: bool) -> void:
	AudioPlayer.mute(toggled_on)


func _on_exit_button_pressed() -> void:
	get_tree().quit(0)
