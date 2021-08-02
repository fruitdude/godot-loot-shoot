extends Particles


export(NodePath) onready var _despawn_timer = get_node(_despawn_timer) as Timer


func _ready():
	_despawn_timer.wait_time = lifetime
	GameEvents.connect("bullet_hit", self, "_on_bullet_hit")


func _on_DespawnTimer_timeout():
	print("killing")

	
	
func _on_bullet_hit():
	print("position")

