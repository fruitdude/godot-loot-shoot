extends RayCast


func _input(_event):
	var collided_area : RigidBody = get_collider()
	
	if collided_area:
		GameEvents.emit_signal("looked_over", collided_area)
		if Input.is_action_just_pressed("interact"):
			GameEvents.emit_signal("interacted", collided_area)
	else:
		GameEvents.emit_signal("looked_out")
