class_name PlayerFalling
extends State

var jump_buffer_timer : float

func enter():
	parent.animations.play("Falling")
	
	jump_buffer_timer = 0
	

		
func physics_update(delta: float):
	parent.movement()
	
	parent.velocity.y *= parent.fall_speed
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = parent.jump_buffer
		
	jump_buffer_timer -= delta
	
	if parent.is_on_floor():
		if jump_buffer_timer > 0:
			transitioned.emit(self, "PlayerJumping")
		else:
			transitioned.emit(self, "PlayerIdle")
