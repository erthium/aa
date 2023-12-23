extends CanvasLayer

@onready var game_manager = get_parent().find_child("GameManager")

func after_fade_in():
	game_manager.after_fade_transition()
	
func after_fade_out():
	game_manager.after_fade_transition()
