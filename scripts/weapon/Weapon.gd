extends Spatial


export(NodePath) onready var _muzzle = get_node(_muzzle) as Position3D

var inventory_open : bool = false


func _ready():
	GameEvents.connect("opened_inventory", self, "_on_opened_inventory")


func _input(event):
	if event.is_action_pressed("shoot") and !inventory_open:
		print("shooting")


func _on_opened_inventory(is_inventory_open):
	inventory_open = is_inventory_open
