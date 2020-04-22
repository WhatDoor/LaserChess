extends Area2D

var speed = 1
var velocity = Vector2.ZERO

func fire(direction):
	velocity = direction

func _process(delta):
	position += velocity.normalized() * speed

func kill():
	queue_free()
