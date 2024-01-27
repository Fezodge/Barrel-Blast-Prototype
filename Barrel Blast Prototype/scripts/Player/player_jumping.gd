class_name PlayerJumping
extends State

func enter():
	parent.animations.play("Jumping")
	parent.velocity.y = parent.jump_velocity
	
func update(delta: float):
	print(parent.velocity)

	parent.movement()

	if parent.velocity.y > 0:
		transitioned.emit(self, "PlayerFalling")
