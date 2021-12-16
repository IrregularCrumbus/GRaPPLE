extends CollisionShape

var targetHealth = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if targetHealth <= 0:
		queue_free()