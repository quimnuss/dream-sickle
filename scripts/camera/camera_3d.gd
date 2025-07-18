extends Camera3D

@export var player_path: NodePath
@export var smoothing := 5.0  # set to 0 for no smoothing

var player: Node3D
@export var offset: Vector3 = Vector3(4.5, 6.0, 4.5)

func _ready():
	if not player_path:
		push_warning("Camera3D: player_path not set!")
		return

	player = get_node(player_path)
	if not player:
		push_warning("Camera3D: could not find player at %s" % player_path)
		return

	# Calculate the initial offset from player → camera
	#offset = global_transform.origin - player.global_transform.origin

func _physics_process(delta: float) -> void:
	if not player:
		return

	# Desired target position = player position + stored offset
	var target_pos = player.global_transform.origin + offset

	if smoothing > 0:
		# Smoothly interpolate towards it
		global_transform.origin = global_transform.origin.lerp(target_pos, clamp(smoothing * delta, 0, 1))
	else:
		# Snap immediately
		global_transform.origin = target_pos
