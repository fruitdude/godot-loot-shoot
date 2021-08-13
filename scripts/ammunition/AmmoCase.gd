extends Area


export(Resource) onready var pickup_sound_file = pickup_sound_file as AudioStreamOGGVorbis
export var amount_of_ammunition : int = 10

var pickup_sound = preload("res://scenes/audio/PickupAudio.tscn")


func _on_AmmoCase_body_entered(body):
	var new_pickup_sound = pickup_sound.instance()
	new_pickup_sound.stream = pickup_sound_file
	get_parent().add_child(new_pickup_sound)
	new_pickup_sound.set_as_toplevel(true)
	new_pickup_sound.global_transform.origin = self.global_transform.origin
	
	GameEvents.emit_signal("ammunition_collected", amount_of_ammunition)
	queue_free()
