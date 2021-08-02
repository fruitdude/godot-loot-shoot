extends KinematicBody


var mouse_sensitivity : float = .35
var speed : int = 4
var speed_multiplier : float
var acceleration : int = 10
var gravity : float = 9.8
var jump_height : int = 4
var stick_amount : int = 10

var direction = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var velocity = Vector3()
var jump_direction = Vector3()

var on_ground : bool = false
var can_jump : bool = false
var inventory_open : bool = false

export(NodePath) onready var head = get_node(head) as Spatial
export(NodePath) onready var camera = get_node(camera) as Camera
export(NodePath) onready var jump_timer = get_node(jump_timer) as Timer
export(NodePath) onready var raycast = get_node(raycast) as RayCast
export(NodePath) onready var anim_player = get_node(anim_player) as AnimationPlayer

var cube = preload("res://test/Cube.tscn")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameEvents.connect("opened_inventory", self, "_on_opened_inventory")


func _input(event):
	if event is InputEventMouseMotion and !inventory_open:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10
		head.rotation_degrees.x = clamp(head.rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -70, 80)
	
	direction = Vector3()
	_walk()
	
	
func _walk():
	direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if Input.is_action_pressed("sprint"):
		speed_multiplier = 2
	elif Input.is_action_just_pressed("crouch"):
		anim_player.play("CROUCH")
	elif Input.is_action_pressed("crouch"):
		speed_multiplier = 0.5
	elif Input.is_action_just_released("crouch"):
		anim_player.play_backwards("CROUCH")
	else:
		speed_multiplier = 1

	
	direction = direction.normalized()
	if direction.x != 0 or direction.z != 0:
		direction = direction * speed_multiplier
		
	direction = direction.rotated(Vector3.UP, rotation.y)


func _physics_process(delta):
	if is_on_floor():
		if not on_ground:
			jump_timer.start()
		gravity_vec = -get_floor_normal() * stick_amount
		on_ground = true
		jump_direction = Vector3() #resets the jump direction when the player is on the floor
	else:
		can_jump = false
		if on_ground:
			gravity_vec = Vector3()
			on_ground = false
		else:
			gravity_vec += Vector3.DOWN * gravity * delta
			
	if Input.is_action_just_pressed("jump") and !inventory_open:
		if is_on_floor() and can_jump:
			jump_direction = direction
			jump()
	
	
	#prevents the player from changing direction mid air
	if is_on_floor() and can_jump:
		velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	else:
		velocity = velocity.linear_interpolate(jump_direction * speed, acceleration * delta)
		
	movement.z = velocity.z + gravity_vec.z
	movement.x = velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	movement = move_and_slide(movement, Vector3.UP)
	
func jump():
	on_ground = false
	gravity_vec = Vector3.UP * jump_height


#func _on_item_dropped(item_id):
#	print(item_id)
#	if item_id == "milk":
#		var item_instance = load(ItemDB.get_item(item_id)["scene"])
#		item_drop_pos.add_child(item_instance.instance())


func _on_JumpTimer_timeout():
	can_jump = true
	

func _on_opened_inventory(is_inventory_open):
	inventory_open = is_inventory_open


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "CROUCH":
		anim_player.stop()
