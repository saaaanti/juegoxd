# player.gd
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.02

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Set by the authority, synchronized on spawn.

@onready var pivote = $MeshInstance3D/Pivote

# Player synchronized input.

var nuestro = false


func _enter_tree():
	# hace que el dueño sea el del nombre, me parece redundante poruqe se llama muchas veces pero yafue
	set_multiplayer_authority(int(str(get_parent().name)))

func _ready():
		
	
	if is_multiplayer_authority():
		nuestro = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$MeshInstance3D/Pivote/Camera3D.current = true
	

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if not nuestro: return
	
		# gravedad
		
		# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input = Vector2( Input.get_axis("izquierda", "derecha"), Input.get_axis("adelante", "atras"))

	
	var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	
	
		
	
	if direction:
		
		if Input.is_action_pressed("correr"):
			velocity.x = direction.x * SPEED * 1.5
			velocity.z = direction.z * SPEED * 1.5
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
	else:
		velocity.x = move_toward(velocity.x, 0, 0.4)
		velocity.z = move_toward(velocity.z, 0, 0.4)

	move_and_slide()


func _input(event):
	if not nuestro: return
	
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad( -1 * event.relative.x * MOUSE_SENS))
		pivote.rotate_x( deg_to_rad(event.relative.y) * MOUSE_SENS * -1 )
		pivote.rotation.x = clamp(pivote.rotation.x, deg_to_rad(-90), deg_to_rad(90))


