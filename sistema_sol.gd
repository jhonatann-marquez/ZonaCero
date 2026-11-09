extends Node3D

@export var sol: DirectionalLight3D
@export var entorno: WorldEnvironment
@export var ciclo: CicloDia

@export var energia_sol := 1.0
@export var azimut := -30.0
@export var ambiente_dia := 1.0
@export var ambiente_noche := 0.2

func _ready() -> void:
	aplicar_hora()

func _process(delta: float) -> void:
	if ciclo:
		ciclo.avanzar(delta)
		aplicar_hora()

func aplicar_hora() -> void:
	if not ciclo:
		return
		
	var h := ciclo.hora
	var f := CicloDia.factor_sol(h)
	
	if sol:
		sol.rotation_degrees = Vector3(-CicloDia.elevacion(h), azimut, 0.0)
		sol.light_energy = f * energia_sol
		sol.light_color = CicloDia.color_sol(h)
	
	if entorno and entorno.environment:
		entorno.environment.ambient_light_energy = lerpf(ambiente_noche, ambiente_dia, f)
