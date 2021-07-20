extends RigidBody
class_name Drink

export var collectable_name : String 


func _ready():
	set_as_toplevel(true)
	GameEvents.connect("interacted", self, "_on_interacted")
	

func _on_interacted(object):
	object.queue_free()


func _on_Milk_body_entered(_body):
	sleeping = true