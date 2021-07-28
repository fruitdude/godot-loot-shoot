extends RigidBody
class_name Drink

export var item_name : String


func _ready():
	set_as_toplevel(true)
# warning-ignore:return_value_discarded
	GameEvents.connect("interacted", self, "_on_interacted")
	

func _on_interacted(object):
	object.queue_free()


func _on_Milk_body_entered(_body):
	sleeping = true
