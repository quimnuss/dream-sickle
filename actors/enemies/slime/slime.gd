extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var elapsed = 0

var target : Node3D

signal death

func _ready():
	add_to_group('enemies')

func _physics_process(delta: float) -> void:
	elapsed += delta
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if elapsed > 5 and is_on_floor():
		velocity.y = JUMP_VELOCITY
		elapsed = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Vector3.FORWARD
	if target:
		direction = self.global_position.direction_to(target.global_position)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	var look_target := self.global_position + velocity

	if velocity and not look_target.cross(Vector3.UP).is_zero_approx() and not look_target.is_equal_approx(self.global_position):
		look_at(look_target, Vector3.UP, true)

func hit():
	death.emit()
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'scale:y', 0.1, 0.3)
	tween.tween_callback(queue_free)

func _on_sensor_body_entered(body: Node3D) -> void:
	if body is Player:
		target = body
