class_name PlayerIdle
extends State


func enter():
	parent.animations.play("Idle")

func physics_update(delta: float):
	
	if Input.get_axis("left", "right"):
		transitioned.emit(self, "PlayerRunning")
		
	if Input.is_action_pressed("jump") and parent.is_on_floor():
		transitioned.emit(self, "PlayerJumping")
