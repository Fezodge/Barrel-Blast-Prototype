extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.blast(self)
	SignalBus.blast.emit()
	
func _on_body_exited(body: Node2D) -> void:
	queue_free()

func _process(delta: float) -> void:
	await get_tree().create_timer(0.1).timeout
	queue_free()
