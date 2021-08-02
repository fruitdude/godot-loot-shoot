extends Position3D


func _physics_process(delta):
	GameEvents.emit_signal("muzzle_pos_updated", self.global_transform.origin)
