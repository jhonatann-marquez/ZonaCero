extends Camera3D

@export var objetivo: Node3D
@export var altura_ojos = 1.6
@export var sensibilidad = 0.003

@export var fov_normal = 75.0
@export var fov_apuntando = 50.0
@export var rapidez_zoom = 10.0

func _ready():
	top_level = true
	rotation = Vector3.ZERO  # Empieza mirando al frente (-Z)
	if objetivo and objetivo.has_node("Modelo"):
		objetivo.get_node("Modelo").visible = false  # Oculta el modelo del personaje
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED  # Atrapa el cursor del ratón

func _unhandled_input(evento):
	if evento.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE  # ESC libera el ratón
		
	var capturado = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if evento is InputEventMouseMotion and capturado:
		# Sensibilidad proporcional al FOV actual
		var s = sensibilidad * (fov / fov_normal)
		rotation.y -= evento.relative.x * s
		rotation.x -= evento.relative.y * s
		rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	if objetivo:
		global_position = objetivo.global_position + Vector3(0, altura_ojos, 0)
	
	# Transición suave del FOV al apuntar con clic derecho
	var apunta = Input.is_action_pressed("apuntar")
	var meta = fov_apuntando if apunta else fov_normal
	fov = lerp(fov, meta, rapidez_zoom * delta)
