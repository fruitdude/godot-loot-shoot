extends CanvasLayer


onready var inventory = $Inventory


func _input(event):
	if event.is_action_pressed("open_inventory"):
		inventory.visible = !inventory.visible
		GameEvents.emit_signal("opened_inventory", inventory.visible)


#func _process(_delta):
#	if inventory.visible:
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	else:
#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

