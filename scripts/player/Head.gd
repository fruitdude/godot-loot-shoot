extends Spatial


export(NodePath) onready var hand = get_node(hand) as Spatial
export(NodePath) onready var hand_location = get_node(hand_location) as Spatial

const SWAY : int = 70


func _ready():
	hand.set_as_toplevel(true)


func _process(delta):
	hand.global_transform.origin = hand_location.global_transform.origin
	hand.rotation.y = lerp_angle(hand.rotation.y, get_parent().rotation.y, SWAY * delta)
	hand.rotation.x = lerp_angle(hand.rotation.x, rotation.x, SWAY * delta)
