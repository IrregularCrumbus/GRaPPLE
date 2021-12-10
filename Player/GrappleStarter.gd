extends KinematicBody

var speed = 35
var acceleration = 50
var gravity = 20
var jump = 10

var grappling = false
var grapplePoint = Vector3()
var grapplePointGet = false

var firing = false

var FOV = 80.0
var cam_path = "Head/Camera"
var mouse_sensitivity = 0.25

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

onready var head = $Head
onready var bonk = $HahaBonk
onready var grappleCast = $Head/Camera/GrappleRayCast
onready var bulletCast = $Head/Camera/BulletCast
onready var cam: Camera = get_node(cam_path)
onready var weaponReady = $Head/Camera/Weapon
onready var weaponFire = $Head/Camera/WeaponFire
onready var weaponEmpty = $Head/Camera/WeaponEmpty
onready var animationTimer = $WeaponAnimationTimer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.fov = FOV

	
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func fire_weapon():
	
	weaponEmpty.hide()
	
	if Input.is_action_just_pressed("use_weapon"):
		firing = true
		animationTimer.start()
	if animationTimer.is_stopped():
		firing = false
	
	if firing:
		weaponReady.hide()
		weaponFire.show()
		
	else:
		weaponFire.hide()
		weaponReady.show()

func grapple():
	if Input.is_action_just_pressed("use_hook"):
		if grappleCast.is_colliding():
			if not grappling:
				grappling = true
	if grappling:
		fall.y = 0
		if not grapplePointGet:
			grapplePoint = grappleCast.get_collision_point() + Vector3(0, 0.25, 0)
			grapplePointGet = true
		if grapplePoint.distance_to(transform.origin) > 1:
			if grapplePointGet:
				transform.origin = lerp(transform.origin, grapplePoint, 0.10)
		if Input.is_action_just_released("use_hook"):
			grappling = false
			grapplePointGet = false
	if bonk.is_colliding():
		grappling = false
		grapplePoint = null
		grapplePointGet = false
		global_translate(Vector3(0, -1, 0))

func _physics_process(delta):
	
	fire_weapon()
	
	grapple()
	
	direction = Vector3()
	
	move_and_slide(fall, Vector3.UP, true)
	
	if not is_on_floor():
		fall.y -= gravity * delta
		
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		fall.y = jump
		
	if Input.is_action_pressed("move_forward"):
	
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		
		direction += transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		
		direction -= transform.basis.x			
		
	elif Input.is_action_pressed("move_right"):
		
		direction += transform.basis.x
			
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP, true) 
