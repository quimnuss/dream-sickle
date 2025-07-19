class_name Player extends CharacterBody3D

# — Movement parameters —
@export var max_speed       := 10.0
var current_max_speed		:= max_speed
@export var current_speed : float = 0
@export var roll_max_speed_delta := 10.0
@export var accel           := 4.0
@export var decel           := 8.0
# — Jump & gravity —
@export var gravity         := 20.0
@export var jump_velocity   := 10.0
@export var max_fall_speed  := 50.0
@export var fall_gravity_multiplier := 2.0  # Falls faster than jumping up
@export var ground_gravity_multiplier := 3.0  # Extra gravity when on ground
@export var jump_release_multiplier := 3.0   # Fall faster when jump released early
# — Quality of life features —
@export var coyote_time     := 0.15  # Seconds to jump after leaving ground
@export var jump_buffer     := 0.1   # Seconds to buffer jump input

# internal state
var input_dir: Vector3 = Vector3.ZERO
@onready var camera: Camera3D = get_viewport().get_camera_3d()
@onready var skin: Node3D = $Skin  # Assumes you have a Skin node as child
@export var rotation_speed := 10.0

@onready var animation_player: AnimationPlayer = $Skin/Player_model/AnimationPlayer
@onready var animation_tree: AnimationTree = $Skin/Player_model/AnimationTree
@onready var skeleton_3d: Skeleton3D = $Skin/Player_model/Armature_001/Skeleton3D
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@export var debug_state := false

# Quality of life timers
var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var was_on_floor := false
var elapsed : float = 0
var jump_count : int = 0

var respawn_position : Vector3

enum States {IDLE, RUNNING, JUMPING, FALLING, INTERACTING, ROLL}
var states_names = {
	States.IDLE : 'idle',
	States.RUNNING : 'running',
	States.JUMPING : 'jumping',
	States.FALLING : 'falling',
	States.INTERACTING : 'interacting',
	States.ROLL : 'roll',
}
@export var state: States = States.IDLE

func _ready():
	respawn_position = global_position + Vector3(0,1,0)
	Progress.time_up.connect(_on_time_up)

func _physics_process(delta):
	get_input_3d()
	update_timers(delta)
	update_state(delta)	
	apply_gravity(delta)
	
	rotate_skin(delta)
	
	move_and_slide()
	Progress.speed_changed.emit(current_speed)
	
	# Update floor state for next frame
	was_on_floor = is_on_floor()

func travel(new_state : States):
	prints('from', states_names[state],' --> ', states_names[new_state])
	if new_state == States.ROLL:
		current_max_speed = max_speed + roll_max_speed_delta
		# a bit hacky :P roll instantly puts the player to max_speed plus some
		current_speed = max_speed + 2
		var horizontal_velocity := Vector3(velocity.x, 0, velocity.z)
		var target_velocity := horizontal_velocity.normalized()*current_speed
		velocity.x = target_velocity.x
		velocity.z = target_velocity.z
		state_machine.travel("Roll")
		elapsed = 0

	state = new_state

func update_state(delta):
	if debug_state:
		print(state_machine.get_current_node())
	#prints('         us ', states_names[state])
	match state:
		States.IDLE:
			current_max_speed = max_speed
			handle_movement(delta)
			handle_jump(delta)
			if state != States.JUMPING:
				if Input.is_action_just_pressed("roll"):
					travel(States.ROLL)
				elif velocity.length() > 0 and is_on_floor():
					travel(States.RUNNING)
				elif Input.is_action_just_pressed("interact"):
					travel(States.INTERACTING)
				elif velocity.y < 0.0:
					travel(States.FALLING)
		States.RUNNING:
			handle_movement(delta)
			handle_jump(delta)
			if state != States.JUMPING:
				if velocity.is_zero_approx() and is_on_floor():
					travel(States.IDLE)
				elif Input.is_action_just_pressed("roll"):
					travel(States.ROLL)
				elif velocity.y < 0.0:
					travel(States.FALLING)
		States.JUMPING:
			handle_movement(delta)
			handle_jump(delta)
			if Input.is_action_just_pressed("roll"):
				travel(States.ROLL)
			elif velocity.y < 0.0:
				travel(States.FALLING)
		States.FALLING:
			handle_movement(delta)
			handle_jump(delta)
			if Input.is_action_just_pressed("roll"):
				travel(States.ROLL)
			elif is_on_floor():
				travel(States.IDLE)
		States.INTERACTING:
			travel(States.IDLE)
		States.ROLL:
			elapsed += delta
			handle_movement(delta)
			handle_jump(delta)
			if elapsed > 0.5:
				if is_on_floor():
					travel(States.IDLE)
				elif velocity.y < 0.0:
					travel(States.FALLING)

# ———————— INPUT ————————
func get_input_3d():
	var in2d = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	
	# Handle jump buffering
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer
	
	if camera:
		# Get camera's forward and right directions (ignore Y component for ground movement)
		var cam_forward = -camera.global_basis.z
		var cam_right = camera.global_basis.x
		
		# Flatten to ground plane
		cam_forward.y = 0
		cam_right.y = 0
		cam_forward = cam_forward.normalized()
		cam_right = cam_right.normalized()
		
		# Calculate movement direction relative to camera
		input_dir = (cam_right * in2d.x + cam_forward * in2d.y)
	else:
		# Fallback to world space if no camera
		input_dir = Vector3(in2d.x, 0, in2d.y)

# ———————— TIMERS ————————
func update_timers(delta):
	# Coyote time - can jump for short time after leaving ground
	if is_on_floor():
		coyote_timer = coyote_time
	elif was_on_floor and not is_on_floor():
		# Just left ground, start coyote timer
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	
	# Jump buffer timer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

# ———————— GRAVITY ————————
func apply_gravity(delta):
	var gravity_multiplier = 1.0
	
	if is_on_floor():
		# Extra gravity when on ground for snappier movement
		if velocity.y <= 0:
			gravity_multiplier = ground_gravity_multiplier
	else:
		# Variable jump height - fall faster when jump released early
		if velocity.y > 0 and not Input.is_action_pressed("jump"):
			gravity_multiplier = jump_release_multiplier
		# Fall faster than jumping up
		elif velocity.y < 0:
			gravity_multiplier = fall_gravity_multiplier
	
	velocity.y -= gravity * gravity_multiplier * delta
	
	# Clamp fall speed
	if velocity.y < -max_fall_speed:
		velocity.y = -max_fall_speed


# ———————— MOVEMENT ————————
func handle_movement(delta):
	current_speed = (velocity*Vector3(1,0,1)).length()
	if input_dir != Vector3.ZERO:
		current_speed = move_toward(current_speed, current_max_speed, accel * delta)
		# Accelerate towards input direction
		var target_velocity := input_dir * current_speed
		velocity.x = target_velocity.x #move_toward(velocity.x, target_velocity.x, accel * delta)
		velocity.z = target_velocity.z #move_toward(velocity.z, target_velocity.z, accel * delta)
	else:
		# with deceleration # doesnt work because there's no directional momentum 
		# velocity.x = move_toward(velocity.x, 0, accel * delta)
		#velocity.z = move_toward(velocity.z, 0, accel * delta)
		# without deceleration
		velocity.x = 0
		velocity.z = 0
		
		current_speed = (velocity*Vector3(1,0,1)).length()


# ———————— JUMP ————————
func handle_jump(_delta):
	# Can jump if: on floor, in coyote time, or have buffered jump
	var can_jump = is_on_floor() or coyote_timer > 0 or jump_count == 1
	var wants_to_jump = jump_buffer_timer > 0
	
	if can_jump and wants_to_jump:
		velocity.y = jump_velocity
		jump_buffer_timer = 0  # Consume the buffered jump
		coyote_timer = 0       # Consume coyote time
		jump_count = 1 if jump_count == 0 else 0
		travel(States.JUMPING)

# ———————— ROTATION ————————
func rotate_skin(delta):
	if skin and input_dir.length() > 0.1:
		# Calculate target rotation based on movement direction
		var target_angle = atan2(input_dir.x, input_dir.z)
		
		# Smoothly rotate using lerp_angle
		skin.rotation.y = lerp_angle(skin.rotation.y, target_angle, rotation_speed * delta)

func reset():
	self.scale.y = 1
	self.global_position = respawn_position

func die():
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'scale:y', 0.2, 1)
	tween.tween_callback(reset)

func die_and_wake_up():
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'scale:y', 0.2, 1)
	tween.tween_callback(reset)
	tween.tween_callback(to_house)

func _on_time_up():
	die_and_wake_up()

func to_house():
	get_tree().change_scene_to_file("res://levels/house_room_for_real.tscn")

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		'Test Animation':
			travel(States.IDLE)
