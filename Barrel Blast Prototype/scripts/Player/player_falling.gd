class_name PlayerFalling
extends State

func enter():
	parent.animations.play("Falling")
	parent.velocity.y = parent.fall_speed

func physics_update(delta: float):
	parent.movement()
	
	if parent.is_on_floor():
		transitioned.emit(self, "PlayerIdle")
