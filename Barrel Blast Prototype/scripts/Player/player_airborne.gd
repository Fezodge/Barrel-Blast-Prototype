class_name PlayerAirborne
extends State

func enter():
	parent.animations.play("Jumping")
	
func update(delta: float):
	if parent.velocity.y > 0:
		transitioned.emit(self, "PlayerFalling")
