extends AudioStreamPlayer

func _ready():
	self.get_stream_playback().switch_to_clip(0)

func fade_to(new_track : String):
	var stream_playback : AudioStreamPlaybackInteractive = get_stream_playback()
	stream_playback.switch_to_clip_by_name(new_track)

func fade_to_next():
	var stream_playback : AudioStreamPlaybackInteractive = get_stream_playback()
	var next_clip_index : int = (stream_playback.get_current_clip_index() + 1) % stream_playback.clip_count
	stream_playback.switch_to_clip(next_clip_index)

func _on_finished():
	fade_to_next()
