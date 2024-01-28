class_name PlayerJumping
extends State

func enter():
	parent.animations.play("Jumping")
	parent.velocity.y = parent.jump_velocity
	
func update(delta: float):
	parent.movement()
	
	# Variable jump height
	if !Input.is_action_pressed("jump"):
		parent.velocity.y *= parent.jump_decay

	if parent.velocity.y > 0:
		transitioned.emit(self, "PlayerFalling")
