extends Node3D

@onready var flash: GPUParticles3D = $VFXImpact/Flash


func _on_health_is_hit(_amount: Variant) -> void:
	flash.emitting = true
