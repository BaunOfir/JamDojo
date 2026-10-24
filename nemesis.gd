extends CharacterBody2D

@export var SPEED: float = 80.0

var move_direction: Vector2 = Vector2.ZERO
var player_area: Area2D = null
var player: CharacterBody2D = null

func _ready() -> void:
	_choose_random_direction()

func _physics_process(_delta: float) -> void:
	#Si el jugador esta encendido, lo persigue, sino sigue con su movimiento random
	if is_instance_valid(player) and player.encendido:
		var direction_to_player = global_position.direction_to(player.global_position)
		velocity = direction_to_player * SPEED
	else:
		if is_instance_valid(player_area):
			if not player_area.overlaps_body(self):
				_steer_back_into_area()
		velocity = move_direction * SPEED

	move_and_slide()
func _choose_random_direction() -> void:
	move_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))

func _steer_back_into_area() -> void:
	if not is_instance_valid(player_area): return
	var direction_to_center = global_position.direction_to(player_area.global_position)
	var random_angle = randf_range(-0.5, 0.5) 
	move_direction = direction_to_center.rotated(random_angle).normalized()




func set_player_area(area: Area2D) -> void:
	player_area = area
	if area.get_parent() is CharacterBody2D:
		player = area.get_parent()
