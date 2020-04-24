extends Area2D

var speed = 1
var velocity = Vector2.ZERO

func fire(direction):
	velocity = direction
	$Sprite.position.x = get_sprite_ground_offset(velocity)
	
func get_sprite_ground_offset(direction):
	#Dot Product to get angle between direction and X axis, result should be between 0 (perpendicular) and 1 (parallel)
	var angle = direction.dot(Vector2(1,0))
	
	#Scale angle to offset 0 is 0 and 1 is 8
	return angle * 8

func _process(delta):
	position += velocity.normalized() * speed

func kill():
	queue_free()
