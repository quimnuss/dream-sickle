class_name Slime
extends Node3D

@export var spawnable_enemies : Array[PackedScene] = []
@export var num_spawns : int = 1

func _ready():
	call_deferred('spawn')

func spawn():
	for spawn_point in range(num_spawns):
		var enemy_scene : PackedScene = spawnable_enemies.pick_random()
		var enemy = enemy_scene.instantiate()
		self.add_child(enemy)
		enemy.global_position += Vector3(2*randf(),2*randf(),2*randf())
		await get_tree().create_timer(1).timeout

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_action"):
		spawn()
