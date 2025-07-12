extends Node3D

@onready var in_dungeon_sensor: Area3D = $InDungeonSensor
@onready var door_locker: DoorLocker = $DoorLocker
@onready var enemy_spawner: Slime = $EnemySpawner

var is_cleared : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group('rooms')
	in_dungeon_sensor.body_entered.connect(door_locker._on_in_dungeon_sensor_body_entered)
	in_dungeon_sensor.body_entered.connect(enemy_spawner._on_in_dungeon_sensor_body_entered)
	enemy_spawner.room_cleared.connect(_on_room_cleared)

func set_clear(new_is_clear : bool):
	enemy_spawner.is_clear = new_is_clear
	door_locker._on_room_cleared()

func _on_room_cleared():
	set_clear(true)
