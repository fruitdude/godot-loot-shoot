extends RigidBody

export(NodePath) onready var timer = get_node(timer) as Timer
export var bullet_dropoff_distance : float = 100.0

onready var cube = preload("res://test/Cube.tscn")


var muzzle_pos : Vector3
var muzzl_to_bullet_distance : float

var counter = 0


func _ready():
	GameEvents.connect("muzzle_pos_updated", self, "_on_muzzle_pos_updated")


func _physics_process(_delta):
	muzzl_to_bullet_distance = muzzle_pos.distance_to(self.global_transform.origin)
	
	if muzzl_to_bullet_distance > bullet_dropoff_distance:
		gravity_scale = .8


func _on_muzzle_pos_updated(pos):
	muzzle_pos = pos


func _on_DespawnTimer_timeout():
	pass


func _on_Bullet_body_entered(_body):
	if cube:
		var new_cube = cube.instance()
		get_node("/root/World/Spawns").add_child(new_cube) 
		
		new_cube.global_transform.origin = self.global_transform.origin
		new_cube.set_as_toplevel(true)
		
		queue_free()

