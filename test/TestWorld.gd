extends Spatial


onready var raycast = $RayCast


func _ready():
	print(raycast.translation)
	print(raycast.translation + raycast.cast_to)
