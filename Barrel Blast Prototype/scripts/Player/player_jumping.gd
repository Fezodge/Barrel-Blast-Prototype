class_name PlayerJumping
extends State

func enter():
	parent.animations.play("Jumping")
	parent.velocity.y = parent.jump_speed
	
func update(delta: float):
	# Variable jump height
	if Input.is_action_just_released("jump"):
		parent.velocity.y *= parent.jump_decay

	if parent.velocity.y > 0:
		transitioned.emit(self, "PlayerFalling")
