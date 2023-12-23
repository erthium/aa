extends Node2D

var current_arrow = null
var is_drawing: bool = false
const arrow_scene = preload("res://Scenes/Arrow.tscn")

@onready var arrow_position_node = get_node("arrow_position")

@onready var arrow_holder = get_parent().find_child("ArrowHolder")

@onready var timer:Timer = $Sprite2D/PowerTimer
@onready var bow_sprite:Sprite2D = $Sprite2D

@onready var animator:AnimationPlayer = $AnimationPlayer

var bow_sprites = []

var power:float = 0
var power_drawing_coefficent:float = 30
var power_shooting_coefficent:float = 60
var max_power:float = 20

var current_sprite_stage:int = 0

func _ready():
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	animator.play("RESET")
	reload()


func _process(delta):
	
	#follow the cursor
	#look_at(get_global_mouse_position())
	#rotation += PI/2
	
	if Input.is_action_just_pressed("shoot"):
		if current_arrow:
			draw_arrow()
			#animator.play("RESET")
			animator.play("drawing_animation")
	
	if Input.is_action_just_released("shoot"):
		if is_drawing:
			shoot_arrow()
			animator.play("shooting_animation")
	
	if is_drawing: 
		current_arrow.rotation = rotation
		current_arrow.position = arrow_position_node.position + Vector2(0, -94)
		if power > 4:
			animator.play("stay_drawed")
	

			

func draw_arrow() -> void:
	is_drawing = true
	timer.start(0.05)
	
	
func shoot_arrow() -> void:

	current_arrow.get_shot(power*3)
	is_drawing = false
	power = 0
	
	var current_arrow_global_position = current_arrow.global_position
	var current_arrow_global_rotation = current_arrow.global_rotation
	
	self.remove_child(current_arrow)
	arrow_holder.add_child(current_arrow)
	
	current_arrow.global_position = current_arrow_global_position
	current_arrow.global_rotation = current_arrow_global_rotation
	
	current_arrow = null
	
	
func reload() -> void:
	current_arrow = arrow_scene.instantiate()
	self.add_child(current_arrow)
	current_arrow.rotation = rotation
	current_arrow.position = arrow_position_node.position + Vector2(0, -94)


func _on_Timer_timeout() -> void:
	if is_drawing:
		power += timer.wait_time * power_drawing_coefficent
	else:
		power -= timer.wait_time * power_shooting_coefficent
		
	if power >= max_power:
		power = max_power
		
	if power <= 0:
		power = 0

