extends CharacterBody2D

# Esta es la variable que ya tenías
@export var encendido: bool = false
@onready var zona_enemigo: Area2D = $ZonaEnemigo

func _ready() -> void:
	zona_enemigo.body_entered.connect(_on_zona_enemigo_body_entered)

# --- AÑADE ESTA FUNCIÓN PARA DETECTAR LA TECLA E ---
func _input(event: InputEvent) -> void:
	# KEY_E detecta directamente la tecla física 'E' en el teclado
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == KEY_E:
			# Invierte el valor: si era true pasa a false, y viceversa
			encendido = !encendido
			print("Jugador encendido: ", encendido) # Mensaje en consola para probar

func _on_zona_enemigo_body_entered(body: Node2D) -> void:
	if body.has_method("set_player_area"):
		body.set_player_area(zona_enemigo)
