extends Node2D

var time:float = 0
var angular_speed:float = 2
var current_angular_speed:float = 2
var speed_change_curve:Curve = null

@onready var animator:AnimationPlayer = find_child("AnimationPlayer")

func _ready():
	animator.play("normal")

func _process(delta):
	time += delta
	if speed_change_curve != null:
		current_angular_speed = angular_speed * (1 + speed_change_curve.interpolate_baked(time - floor(time)))
	rotation += current_angular_speed * delta


func explode():
	animator.play("explode")

func reset():
	animator.play("normal")


func set_level(angular_speed:float = 2, speed_change_curve:Curve=null):
	self.angular_speed = angular_speed
	self.current_angular_speed = angular_speed
	self.speed_change_curve = speed_change_curve





