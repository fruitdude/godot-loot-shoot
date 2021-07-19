extends RigidBody
class_name Food

export var collectable_name : String 


func _ready():
	GameEvents.connect("interacted", self, "_on_interacted")
	

func _on_interacted(object):
	object.queue_free()


func _on_Beans_body_entered(_body):
	print("hit floor")
