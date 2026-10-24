extends CharacterBody2D

const VELOCIDAD = 700
const ACELERACION = 2000

var cantidad_aceite = 0
var prendido = false
var puede_encender = true

var UI = false
var carta1 = false
var carta2 = false
var carta3 = false

@onready var UI_cartas = %notas
@onready var Carta_1 = %carta1
@onready var Carta_2 = %carta2
@onready var Carta_3 = %carta3

@onready var zona_enemigo: Area2D = $ZonaEnemigo
@onready var Barra_cordura = $Barra_cordura
@onready var barraluz = $barraluz
@onready var aduken = $aduken
@onready var luz_timer: Timer = $Timer_luz


func _ready() -> void:
	Barra_cordura.max_value = 100
	Barra_cordura.value = 100

	barraluz.max_value = 100
	barraluz.value = 100

	aduken.energy = 0

	luz_timer.wait_time = 1
	luz_timer.one_shot = true

	zona_enemigo.body_entered.connect(
		_on_zona_enemigo_body_entered
	)

	Carta_1.hide()
	Carta_2.hide()
	Carta_3.hide()
	UI_cartas.hide()


func _physics_process(delta: float) -> void:

	# Mostrar las cartas recogidas
	if carta1:
		Carta_1.show()
	if carta2:
		Carta_2.show()
	if carta3:
		Carta_3.show()

	# Abrir y cerrar inventario
	if Input.is_action_just_pressed("objetos"):
		if UI:
			UI = false
			UI_cartas.hide()
		else:
			UI = true
			UI_cartas.show()

	# Recargar aceite
	if barraluz.value < 100 and cantidad_aceite > 0 and Input.is_action_just_pressed("recarga"):
		barraluz.value = minf(barraluz.value + 10.0, 100.0)
		cantidad_aceite -= 1
		print("Te queda: ", cantidad_aceite)

	# Encender o apagar la luz
	if Input.is_action_just_pressed("accion"):
		if prendido:
			prendido = false
			puede_encender = false
			luz_timer.start()
		elif puede_encender and barraluz.value > 0:
			prendido = true

	# Consumo de luz y recuperación de cordura
	if prendido:
		barraluz.value = maxf(barraluz.value - delta * 5.0, 0.0)
		aduken.energy = barraluz.value / 100.0
		Barra_cordura.value = minf(Barra_cordura.value + delta, 100.0)

		if barraluz.value <= 0:
			prendido = false
	else:
		aduken.energy = 0.0
		Barra_cordura.value = maxf(Barra_cordura.value - delta * 2.0, 0.0)

	# Movimiento
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


func _on_timer_luz_timeout() -> void:
	puede_encender = true
