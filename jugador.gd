extends CharacterBody2D

var move_speed_walk = 200
var move_speed_run = 300
var is_facing_right = true 
var is_running = false
var is_slicing = false 
var inventario = []

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if is_slicing:
		return  # No mover mientras corta

	var direction = Vector2.ZERO
	
	# Movimiento caminando
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	# Movimiento corriendo
	var run_direction = Vector2(
		Input.get_axis("run_left", "run_right"),
		Input.get_axis("run_up", "run_down")
	)

	# Acción de cortar
	if Input.is_action_just_pressed("slice") and not is_slicing:
		is_slicing = true
		velocity = Vector2.ZERO
		play_slice_animation(direction)
		await get_tree().create_timer(0.4).timeout  # Duración de la animación
		is_slicing = false
		return

	# Elegir velocidad
	if run_direction != Vector2.ZERO:
		is_running = true
		direction = run_direction
		velocity = direction.normalized() * move_speed_run
	else:
		is_running = false
		velocity = direction.normalized() * move_speed_walk

	move_and_slide()
	update_animations(direction)

func update_animations(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		animated_sprite.play("idle_down")
		return

	if abs(direction.x) > abs(direction.y):
		animated_sprite.flip_h = direction.x < 0
		animated_sprite.play("run_side" if is_running else "walk_side")
	elif direction.y < 0:
		animated_sprite.play("run_up" if is_running else "walk_up")
	else:
		animated_sprite.play("run_down" if is_running else "walk_down")

func play_slice_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		animated_sprite.play("slice_side")
		return

	if abs(direction.x) > abs(direction.y):
		animated_sprite.flip_h = direction.x < 0
		animated_sprite.play("slice_side")
	elif direction.y < 0:
		animated_sprite.play("slice_up")
	#else:
		#animated_sprite.play("slice_down")
