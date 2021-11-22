extends KinematicBody


# Declaring number variables:
const moveSpeed = 12
const jumpForce = 30
const gravity = 0.98
const maxFallSpeed = 30

const xLookSensitivity = 1.0
const yLookSensitivity = 1.0

var yVelocity = 0

#calling a camera variable that will allow the camera to move with the player's mouse movement
onready var cam = $camBase

# Called when the node enters the scene tree for the first time.
func _ready():
	
# if / when I get player animations, I'll give them a variable below.
#	var anim = ANIMATION FILE
	pass

func _input(event):
	# Allows the player to look around with the mouse
	if event is InputEventMouseMotion:
		cam.rotation_degrees.x -= event.relative.y * yLookSensitivity
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * xLookSensitivity

func _physics_process(delta):
	# Enabling the player to move with WASD
	var moveVec = Vector3()
	if Input.is_action_pressed("moveForwards"):
		moveVec.z -=1
	if Input.is_action_pressed("moveBackwards"):
		moveVec.z +=1
	if Input.is_action_pressed("moveRight"):
		moveVec.x +=1
	if Input.is_action_pressed("moveLeft"):
		moveVec.x -=1
	moveVec = moveVec.normalized()
	moveVec = moveVec.rotated(Vector3(0, 1, 0), rotation.y)
	moveVec *= moveSpeed
	moveVec = yVelocity
	move_and_slide(moveVec, Vector3(0, 1, 0))
	
	# Handles physics in the Y axis: causes gravity to exist, allows the player to jump, and sets a cap to how fast the player can fall
	var grounded = is_on_floor()
	yVelocity -= gravity
	var justJumped = false
	if grounded and Input.is_action_just_pressed("jump"):
		justJumped = true
		yVelocity = jumpForce
	if grounded and yVelocity <= 0:
		yVelocity = -0.1
	if yVelocity < -maxFallSpeed:
		yVelocity = -maxFallSpeed
		
func playAnimations(name):
	# Again, I may or may not even use this funcion if I get animations, since this is a first person platformer.
	pass

