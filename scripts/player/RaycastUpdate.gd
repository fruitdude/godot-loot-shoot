extends RayCast


func _physics_process(_delta):
	if self.is_colliding():
		GameEvents.emit_signal("raycast_collision_updated", self.get_collision_point())
