extends Area2D

var speed = .5
var velocity = Vector2.ZERO

func fire(direction):
	velocity = direction

func _process(delta):
	position += velocity.normalized() * speed

func kill():
	queue_free()
