extends CharacterBody2D

const VELOCIDAD = 700
const ACELERACION = 2000
var cantidad_aceite=0
var prendido = false
@onready var zona_enemigo: Area2D = $ZonaEnemigo

@onready var barraluz = $barraluz
@onready var aduken = $aduken

func _ready() -> void:
	barraluz.max_value = 100
	barraluz.value = 100
	aduken.energy = 0
	zona_enemigo.body_entered.connect(_on_zona_enemigo_body_entered)

func _physics_process(delta: float) -> void:
	
	if barraluz.value<100 and cantidad_aceite>0 and Input.is_action_just_pressed("recarga"):
		barraluz.value = minf(barraluz.value + 10.0, 100.0)
		cantidad_aceite-=1
		print("te queda",cantidad_aceite)
	if Input.is_action_just_pressed("accion"):
		prendido = not prendido
	
	
	if prendido:
		barraluz.value = maxf(barraluz.value - delta * 10.0, 0.0)
		aduken.energy = barraluz.value / 100.0

		if barraluz.value <= 0:
			prendido = false
	else:
		aduken.energy = 0.0

	
	var direccion = Input.get_vector(
		"izquierda", "derecha", "arriba", "abajo"
	)

	if direccion != Vector2.ZERO:
		velocity = velocity.move_toward(
			direccion * VELOCIDAD,
			ACELERACION * delta
		)
	else:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			ACELERACION * delta
		)

	move_and_slide()


func _on_zona_enemigo_body_entered(body: Node2D) -> void:
	if body.has_method("set_player_area"):
		body.set_player_area(zona_enemigo)
