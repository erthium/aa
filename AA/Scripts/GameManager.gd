extends Node2D

var level_mainscene_path = "res://MainScenes/Level{LVL}.tscn"

@export var level = 0 # (int, 1, 10)
@export var left_arrows: int = 6
@export var log_angular_speed: float = 2
@export var log_speed_change: Curve = null

var waiting_to_tap_to_continue:bool = false
var current_after_fade_function = null
@onready var fade_transition_canvas = get_parent().find_child("FadeTransitionCanvas")
@onready var tap_to_continue_ui = get_parent().find_child("TapToContinue")


var arrow_counter:Label
@onready var bow = get_parent().find_child("Bow")
@onready var target = get_parent().find_child("Log")

func _ready():
	arrow_counter = get_parent().find_child("ArrowCounter") as Label
	tap_to_continue_ui.visible = false
	#at last
	print(self.level)
	current_after_fade_function = funcref(self, "initiate_level")
	fade_in()


func _process(delta):
	if waiting_to_tap_to_continue:
		if Input.is_action_just_pressed("tap_to_continue"):
			waiting_to_tap_to_continue = false
			current_after_fade_function = funcref(self, "move_to_next_level")
			fade_out()
			

func move_to_next_level():
	var path = level_mainscene_path.format({"LVL" : self.level+1})
	get_tree().change_scene_to_file(path)
	
	

func initiate_level() -> void:
	arrow_counter.text = str(left_arrows)
	target.set_level(log_angular_speed, log_speed_change)



func _after_arrow_collision(hit_the_target:bool):
	if hit_the_target:
		#hit the log
		left_arrows -= 1
		arrow_counter.text = str(left_arrows)
		if left_arrows == 0:
			game_won()
		else:
			bow.reload()
	else:
		#game over
		print("Game Over")
		game_over()
		
		
		
func game_over():
	#fade out and fade in to restart the game
	current_after_fade_function = funcref(self, "reload_scene")
	fade_out()
	

func reload_scene():
	get_tree().reload_current_scene()

func game_won():
	#tap to contuniue
	tap_to_continue_ui.visible = true
	tap_to_continue_ui.find_child("AnimationPlayer").play("fade_in")
	target.explode()
	bow.arrow_holder.find_child("AnimationPlayer").play("fade_out")
	waiting_to_tap_to_continue = true


func tap_to_continue_start_swinging():
	tap_to_continue_ui.find_child("AnimationPlayer").play("swing")


func fade_out(speed:float = 5):
	fade_transition_canvas.find_child("AnimationPlayer").play("fade_out")

func fade_in():
	fade_transition_canvas.find_child("AnimationPlayer").play("fade_in")
	
func after_fade_transition():
	if current_after_fade_function != null:
		current_after_fade_function.call_func()
		current_after_fade_function = null
	
