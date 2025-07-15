extends Control

@onready var alarm_text: RichTextLabel = $AlarmAnchor/AlarmText

func _ready():
	Progress.time_left_changed.connect(_on_time_left_updated)
	
func _on_time_left_updated(new_time : float):
	if new_time < 10:
		alarm_text.text = "[color=Crimson]%02d %02d[/color]" % [int(floor(new_time)) / 60, int(floor(new_time)) % 60]
	else:
		alarm_text.text = "[color=Yellowgreen]%02d %02d[/color]" % [int(floor(new_time)) / 60, int(floor(new_time)) % 60]
