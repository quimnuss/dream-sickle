class_name DoorLocker
extends Node

var is_clear : bool = false

var doors : Array[Door] = []

func _ready():
	for child in get_children():
		if child is Door:
			doors.append(child as Door)
	
	for enemy in get_tree().get_nodes_in_group('enemies'):
		enemy.death.connect(_on_enemy_death)

func _on_enemy_death():
	if get_tree().get_node_count_in_group('enemies') == 0:
		_on_room_cleared()

func _on_in_dungeon_sensor_body_entered(body: Node3D) -> void:
	if body is Player:
		if not is_clear:
			for door in doors:
				door.close_and_lock()

func _on_room_cleared():
	is_clear = true
	for door in doors:
		door.open()
