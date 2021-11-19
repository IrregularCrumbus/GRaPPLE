extends KinematicBody


# Declaring number variables:
const moveSpeed = 12
const jumpForce = 30
const gravity = 0.98
const maxFallSpeed = 30

const xLookSensitivity = 1.0
const yLookSensitivity = 1.0\

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
	var moveVector = Vector3()
	if Input.is_action_pressed("moveForwards"):
		moveVector.z -=1
	if Input.is_action_pressed("moveBackwards"):
		moveVector.z +=1
	if Input.is_action_pressed("moveRight"):
		moveVector.x +=1
	if Input.is_action_pressed("moveLeft"):
		moveVector.x -=1
