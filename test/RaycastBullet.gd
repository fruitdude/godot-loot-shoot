extends Spatial


export(NodePath) onready var timer = get_node(timer) as Timer

onready var cube = preload("res://test/Cube.tscn")

var last_position : Vector3
var distance_between_positions : Vector3 = Vector3(0, 0, -5)


func _ready():
	timer.start()


func _on_Timer_timeout():
	_spawn_new_position()


func _spawn_new_position():
	timer.start()
	_instance_cube(last_position)
	


func _instance_cube(position):
	var new_cube = cube.instance()
	add_child(new_cube)
	
	new_cube.global_transform.origin = last_position
	new_cube.set_as_toplevel(true)
	
	var new_position : Vector3 = last_position + (global_transform.basis.z)
	
#	var direct_state = get_world().direct_space_state
#	var collision = direct_state.intersect_ray(last_postion, new_position)
	
	DrawLine3D.DrawLine(last_position, new_position, Color(1, 0, 1), 0.01)
	
	last_position = new_position
	
	
func _on_DespawnTimer_timeout():
	pass # Replace with function body.
