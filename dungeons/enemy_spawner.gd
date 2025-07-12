class_name Slime
extends Node3D

@export var spawnable_enemies : Array[PackedScene] = []
@export var num_spawns : int = 1

signal room_cleared

var is_clear = false

func spawn():
	if num_spawns == 0:
		room_cleared.emit()
		return

	for spawn_point in range(num_spawns):
		var enemy_scene : PackedScene = spawnable_enemies.pick_random()
		var enemy = enemy_scene.instantiate()
		self.add_child(enemy)
		enemy.global_position += Vector3(2*randf(),2*randf(),2*randf())
		enemy.death.connect(_on_enemy_death)
		await get_tree().create_timer(1).timeout

func check_cleared():
	var num_enemies := get_tree().get_node_count_in_group('enemies')
	if num_enemies == 0:
		is_clear = true
		room_cleared.emit()
	prints('num_enemies', num_enemies)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_action"):
		spawn()

func _on_enemy_death(_enemy : Node3D):
	check_cleared()

func _on_in_dungeon_sensor_body_entered(body: Node3D) -> void:
	if body is Player and not is_clear:
		spawn()
