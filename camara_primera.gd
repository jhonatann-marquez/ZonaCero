extends Camera3D

@export var objetivo: Node3D
@export var altura_ojos = 1.6

func _ready():
	top_level = true
	rotation = Vector3.ZERO  # Empieza mirando al frente (-Z)
	if objetivo and objetivo.has_node("Modelo"):
		objetivo.get_node("Modelo").visible = false  # Esconde el modelo para que no tape la vista

func _physics_process(delta):
	if objetivo:
		global_position = objetivo.global_position + Vector3(0, altura_ojos, 0)
