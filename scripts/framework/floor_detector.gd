extends RayCast3D

var collision_point : Vector3
@onready var marker: MeshInstance3D = $Marker


func _physics_process(delta: float) -> void:
	if self.is_colliding():
		marker.visible = true
		collision_point = self.get_collision_point()
		marker.global_position = collision_point
		var distance : float = self.global_position.distance_to(marker.global_position)
		marker.scale = clamp(2/distance, 1, 3)*Vector3(1,0,1) + Vector3(0,0.5,0)
	else:
		marker.visible = false
