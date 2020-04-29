extends Area2D

func _ready():
	self.connect("area_entered",self,"on_hit_wall")

func on_hit_wall(blast):
	blast.kill()
