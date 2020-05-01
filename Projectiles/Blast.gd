extends Area2D

var speed = 1
var velocity = Vector2.ZERO

func fire(direction):
	velocity = direction
	$Sprite.position.y = get_sprite_ground_offset(velocity)
	rotation_degrees = get_reflection_rotation(direction)
	#print(rotation_degrees)
	
func get_sprite_ground_offset(direction):
	#Dot Product to get angle between direction and X axis, result should be between 0 (perpendicular) and 1 (parallel)
	var angle = direction.dot(Vector2(1,0))
	
	#Scale angle to offset 0 is 0 and 1 is 8 - negative because it is y axis
	return -angle * 8

func get_reflection_rotation(direction):	
	var x = direction.x
	var y = direction.y
	
	#Rounding here locks the projectile to rotating in right angles, comment these out to get continuous rotation
	#BUT NOTE, that there is a bug with infinite/undefined numbers that make the projectiles disappear if you don't round
	x = round(x)
	y = round(y)
	
	#print("finding rotation angle for ", x,",",y)
	
	if x <= 0 and y <= 0: #Both are negative
		#print("both negative")
		return round(rad2deg(-acos(x)))
			
	elif y <= 0: #y is negative
		#print("negative y")
		return round(rad2deg(asin(y)))
		
	elif x >= 0 and y >= 0: #both are positive
		#print("both positive")
		return round(rad2deg(acos(x)))
		
	elif x <= 0: #x is negative
		#print("negative x")
		return round(rad2deg(acos(x)))
	else:
		#print("BAD BAD")
		return 0

func _process(delta):
	position += velocity.normalized() * speed

func kill():
	queue_free()

func _on_Blast_area_entered(area):
	pass # Replace with function body.
