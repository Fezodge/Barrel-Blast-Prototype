extends RigidBody2D

var speed := 30
var direction : Vector2
var player_velocity : Vector2
var velocity: Vector2
var player_velocity_length: float
@export var Explosion : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_velocity = get_tree().get_first_node_in_group("player").velocity
	player_velocity_length = player_velocity.length()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	player_velocity_length = clamp(player_velocity_length, speed, INF)
	velocity = direction * player_velocity_length * speed * delta
	print(player_velocity_length)
	var collision = move_and_collide(velocity)

	if !$VisibleOnScreenNotifier2D.is_on_screen:
		queue_free()
		
	if collision:
		explode()
		
func explode():
	var e = Explosion.instantiate()
	get_parent().add_child(e)
	e.global_position = self.global_position #Sets initial position of bullet = to player

	self.queue_free()
