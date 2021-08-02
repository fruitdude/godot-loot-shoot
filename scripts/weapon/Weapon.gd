extends Spatial


export(NodePath) onready var _muzzle = get_node(_muzzle) as Position3D
export(NodePath) onready var _shoot_timer = get_node(_shoot_timer) as Timer

onready var raycast_bullet = preload("res://test/RaycastBullet.tscn")
onready var bullet = preload("res://scenes/bullets/Bullet.tscn")

#var muzzle_direction
var bullet_pos : Vector3
var muzzle_pos : Vector3
var bullet_speed : float = 5
var inventory_open : bool = false
var can_shoot : bool = true
var burst_counter : int = 0

enum states{
	SINGLE,
	BURST,
	AUTO
}

var state = states.AUTO


func _ready():
	GameEvents.connect("opened_inventory", self, "_on_opened_inventory")
	
	
func _on_bullet_pos_updated(pos):
	bullet_pos = pos


func _input(event):
	if event.is_action_pressed("change_firemode") and !inventory_open:	
		state += 1
#		print(state)

		if state > (states.keys().size() - 1):
			state = 0
		
		GameEvents.emit_signal("changed_firemode", states.keys()[state])
		
#		print(states.keys()[state])	
		
	
		
		
func _physics_process(_delta):
	match state:
		states.SINGLE:
			if Input.is_action_just_pressed("shoot") and !inventory_open and can_shoot:
				can_shoot = false
				_instance_bullet()
				_shoot_timer.start()
		states.BURST:
			if Input.is_action_just_pressed("shoot") and !inventory_open and can_shoot:
				_burst()
		states.AUTO:
			if Input.is_action_pressed("shoot") and !inventory_open and can_shoot: 
				_instance_bullet()
				can_shoot = false
				_shoot_timer.start()
				
				
func _burst():
	can_shoot = false
	_instance_bullet()
	yield(get_tree().create_timer(0.063), "timeout")
	_instance_bullet()
	yield(get_tree().create_timer(0.063), "timeout")
	_instance_bullet()
	_shoot_timer.start()
	

func _instance_bullet():
	var bullet_instance = bullet.instance()
	add_child(bullet_instance)
	bullet_instance.set_as_toplevel(true)
	bullet_instance.global_transform.origin = _muzzle.global_transform.origin
	bullet_instance.linear_velocity = _muzzle.global_transform.basis.z * -bullet_speed
	GameEvents.emit_signal("muzzle_pos_updated", _muzzle.global_transform.origin)


func _on_opened_inventory(is_inventory_open):
	inventory_open = is_inventory_open


func _on_ShootTimer_timeout():
	can_shoot = true
