extends Spatial


export(NodePath) onready var _muzzle = get_node(_muzzle) as Position3D
export(NodePath) onready var _anim_player = get_node(_anim_player) as AnimationPlayer

export var max_magazine_capacity : int = 30

var raycast_collision_pos : Vector3
var inventory_open : bool = false
var can_shoot : bool = true
var burst_counter : int = 0
var magazine_capacity : int = 20
var amount_to_refill : int 
var weapon_ammunition : int = 60
var not_exluding_anything_array : Array = []


func _ready():
	GameEvents.connect("opened_inventory", self, "_on_opened_inventory")
	GameEvents.connect("raycast_collision_updated", self, "_on_raycast_collision_updated")
	GameEvents.connect("ammunition_collected", self, "_on_ammunition_collected")
	

func _input(event):
	if event.is_action_pressed("reload"):
		_on_reloading()
		
	if event.is_action_pressed("shoot") and magazine_capacity > 0:
		_anim_player.play("SHOT")
		_shoot(_muzzle, raycast_collision_pos)
	else:
		return
	
#func _physics_process(_delta):
#	if Input.is_action_pressed("shoot") and can_shoot:
#		_anim_player.play("SHOT")
#		_shoot(_muzzle, raycast_collision_pos)
		

func _on_raycast_collision_updated(position):
	raycast_collision_pos = position
	
	
func _shoot(muzzle, raycast_coll_pos):
	var direct_state = get_world().direct_space_state
	var collision = direct_state.intersect_ray(muzzle.global_transform.origin, 
		raycast_coll_pos + ((raycast_coll_pos - muzzle.global_transform.origin).normalized() * 2),not_exluding_anything_array, 12, true, true)

	if collision:
		if magazine_capacity > 0:
			magazine_capacity -= 1
			DrawLine3D.DrawLine(muzzle.global_transform.origin, collision.position, Color(1, 0, 1), 1)
#		elif magazine_capacity <= 0:
#			yield(get_tree().create_timer(1), "timeout")
#			_on_reloading()
	else:
		print("no collision")
	
	
func _on_ammunition_collected(amount):
	weapon_ammunition += amount
	

func _on_reloading():
	if weapon_ammunition > 0:
		amount_to_refill = max_magazine_capacity - magazine_capacity
		weapon_ammunition -= amount_to_refill
		magazine_capacity += amount_to_refill
		
		
func _can_shoot(value):
	can_shoot = value
