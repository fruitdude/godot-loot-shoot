extends Control


onready var label = $Label


func _ready():
	GameEvents.connect("looked_over", self, "_on_looked_over")
	GameEvents.connect("looked_out", self, "_on_looked_out")
	GameEvents.connect("interacted", self, "_on_interacted")


func _on_looked_over(object):
	label.show()
	label.text = object.collectable_name + "\n" + "F"


func _on_looked_out():
	label.hide()
	label.text = ""
	
	
func _on_interacted(collided_area):
	if collided_area:
		label.hide()
		label.text = ""
