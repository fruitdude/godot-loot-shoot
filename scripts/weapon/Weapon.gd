extends Spatial


export(NodePath) onready var _muzzle = get_node(_muzzle) as Position3D
export(NodePath) onready var _shoot_timer = get_node(_shoot_timer) as Timer

var raycast_collision_pos : Vector3
var inventory_open : bool = false
var can_shoot : bool = true
var burst_counter : int = 0

var state = states.AUTO

enum states{
	SINGLE,
	BURST,
	AUTO
}


func _ready():
	GameEvents.connect("opened_inventory", self, "_on_opened_inventory")
	GameEvents.connect("raycast_collision_updated", self, "_on_raycast_collision_updated")


func _input(event):
	if event.is_action_pressed("change_firemode") and !inventory_open:	
		state += 1
		if state > (states.keys().size() - 1):
			state = 0
		
		GameEvents.emit_signal("changed_firemode", states.keys()[state])
		
#		print(states.keys()[state])	
		
	
func _physics_process(_delta):
	match state:
		states.SINGLE:
			if Input.is_action_just_pressed("shoot") and !inventory_open and can_shoot:
				can_shoot = false
				_shoot(_muzzle, raycast_collision_pos)
				_shoot_timer.start()
		states.BURST:
			if Input.is_action_just_pressed("shoot") and !inventory_open and can_shoot:
				_burst()
		states.AUTO:
			if Input.is_action_pressed("shoot") and !inventory_open and can_shoot: 
				can_shoot = false
				_shoot(_muzzle, raycast_collision_pos)
				_shoot_timer.start()
				
				
func _burst():
	can_shoot = false
	_shoot(_muzzle, raycast_collision_pos)
	yield(get_tree().create_timer(0.063), "timeout")
	_shoot(_muzzle, raycast_collision_pos)
	yield(get_tree().create_timer(0.063), "timeout")
	_shoot(_muzzle, raycast_collision_pos)
	_shoot_timer.start()
	

func _on_raycast_collision_updated(position):
	raycast_collision_pos = position
	
	
func _shoot(muzzle, raycast_coll_pos):
	var direct_state = get_world().direct_space_state
	var collision = direct_state.intersect_ray(muzzle.global_transform.origin, 
		raycast_coll_pos + ((raycast_coll_pos - muzzle.global_transform.origin).normalized() * 2))
	
	if collision:
		DrawLine3D.DrawLine(muzzle.global_transform.origin, raycast_coll_pos, Color(0, 1, 1), 1)
		
	else:
		print("no collision")


func _on_opened_inventory(is_inventory_open):
	inventory_open = is_inventory_open


func _on_ShootTimer_timeout():
	can_shoot = true
