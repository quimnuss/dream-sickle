extends Node

@export var health_amount : int = 100 :
	set(new_health_amount):
		health_amount = max(new_health_amount, 0)
		health_changed.emit(health_amount)
		if health_amount == 0:
			death.emit()

var base_health : int = health_amount

signal death
signal is_hit(amount : int)
signal health_changed(new_health : int)

func _ready():
	base_health = health_amount

func reset():
	health_amount = base_health

func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area is HitBox:
		var damage: int = area.get_damage()
		health_amount -= damage
		is_hit.emit(damage)
