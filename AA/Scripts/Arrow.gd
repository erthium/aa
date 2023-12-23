extends CharacterBody2D

var is_shot: bool = false
var is_hit: bool = false
var speed:float

var hit:KinematicCollision2D = null

var log_hit_particle: GPUParticles2D

signal after_collision(hit_the_target)

#var shot_rotation:float

func _ready():
	var gameManager = get_parent().get_parent().find_child("GameManager")
	self.connect("after_collision", Callable(gameManager, "_after_arrow_collision"))
	log_hit_particle = find_child("LogHitParticle") as GPUParticles2D


func _physics_process(delta):
	if is_shot and not is_hit:
		var velocity = Vector2.UP.rotated(rotation) * speed
		var collision:KinematicCollision2D = move_and_collide(velocity)
		if collision:
			#get_parent().remove_child(self)
			#collision.collider.add_child(self)
			
			if collision.collider.is_in_group("Target"):
				is_hit = true
				hit = collision
				emit_signal("after_collision", true)
				log_hit_particle.emitting = true
			else:
				#gameover
				emit_signal("after_collision", false)


	elif is_hit:
		position = hit.collider.position + (position - hit.collider.position).rotated(hit.collider.current_angular_speed*delta)
		look_at(hit.collider.position)
		rotation += PI/2

		


		
		
		#rotation = shot_rotation
		

func get_shot(speed:float = 10.0):
	is_shot = true
	self.speed = speed
	#shot_rotation = rotation



