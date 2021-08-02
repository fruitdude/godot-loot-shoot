extends Position3D




#var _look_at_pos : Vector3
#
#
#func _ready():
#	GameEvents.connect("muzzle_pos_updated", self, "_on_muzzle_pos_updated")
#
#
#func _on_muzzle_pos_updated(_position):
#	_look_at_pos = _position
#
#
func _physics_process(_delta):
	pass
#	self.look_at(_look_at_pos, Vector3(0, 1, 0))
	
	
	
#func _input(event):
#	if event is InputEventMouseMotion:
#		GameEvents.emit_signal("muzzle_pos_updated", self.translation)
