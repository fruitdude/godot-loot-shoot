extends TextureRect


var item


func _ready():
	GameEvents.connect("item_picked_up", self, "_on_item_picked_up")
	
	
func _on_item_picked_up(item_id):
	item = item_id
