extends KinematicBody

var speed = 3
const ACCEL_DEFAULT = 9
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 2

var cam_accel = 400
var mouse_sense = 0.1
var snap
var object_name = null

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera
onready var inventory = $CanvasLayer/Inventory
onready var item_drop_pos = $ItemDropPosition


func _ready():
	#hides cursor and keeps it in the window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameEvents.connect("item_dropped", self, "_on_item_dropped")


func _input(event):
	#get mouse input for camera rotation
	if not inventory.visible:
		if event is InputEventMouseMotion:
			rotate_y(deg2rad(-event.relative.x * mouse_sense))
			head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))


func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
		
		
func _physics_process(delta):
	#get keyboard input
	if not inventory.visible:
		direction = Vector3.ZERO
		var h_rot = global_transform.basis.get_euler().y
		var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
		
		#jumping and gravity
		if is_on_floor():
			snap = -get_floor_normal()
			accel = ACCEL_DEFAULT
			gravity_vec = Vector3.ZERO
		else:
			snap = Vector3.DOWN
			accel = ACCEL_AIR
			gravity_vec += Vector3.DOWN * gravity * delta
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * jump
		
		#make it move
		velocity = velocity.linear_interpolate(direction * speed, accel * delta)
		movement = velocity + gravity_vec
			
		velocity = move_and_slide_with_snap(movement, snap, Vector3.UP)


func _on_item_dropped(item_id):
	if item_id == "milk":
		var item_instance = load(ItemDB.get_item(item_id)["scene"])
		item_drop_pos.add_child(item_instance.instance())
