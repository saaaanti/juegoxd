# player.gd
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Set by the authority, synchronized on spawn.


# Player synchronized input.

var nuestro = false

func _enter_tree():
	# hace que el dueño sea el del nombre, me parece redundante poruqe se llama muchas veces pero yafue
	set_multiplayer_authority(int(str(name)))

func _ready():
	
	# Set the camera as current if we are this player.
	if is_multiplayer_authority():
		
		nuestro = true
		
		$MeshInstance3D/MeshInstance3D/Camera3D.current = true
	# Only process on server.
	# EDIT: Let the client simulate player movement too to compesate network input latency.
	# set_physics_process(multiplayer.is_server())


func _physics_process(delta):
	
	
	if not nuestro: return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Reset jump state.

	var input =Vector2( Input.get_axis("izquierda", "derecha"), Input.get_axis("adelante", "atras"))

	# Handle movement.
	var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
