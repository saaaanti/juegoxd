# player.gd
extends CharacterBody3D

class_name Player

const SPEED = 5.0
const RUN_MULT = 1.8
const JUMP_VELOCITY = 7
const JUMP_MULT = 1.2
const JUMP_CONTROL = 0.2
const CROUCH_MULT = 0.4
const ACCELERATION = 0.4
const MAX_SPEED = 200


const MOUSE_SENS = 0.02

var vida = 100


var crouching = false
var running = false
var jumping = false


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


@onready var pivote = $MeshInstance3D/Pivote


var nuestro = false


func _enter_tree():
	# hace que el dueño sea el del nombre, me parece redundante poruqe se llama muchas veces pero yafue
	set_multiplayer_authority(int(str(get_parent().name)))

func _ready():
		
	
	if is_multiplayer_authority():
		nuestro = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$MeshInstance3D/Pivote/Camera3D.current = true
		$UI.visible = true
	
	#Crudazo jasja
	position = Vector3(0, 10, 0)
	
var last_direction = Vector3.ZERO

func _physics_process(delta):
	if not nuestro: return # ???
	
	var speed = 0
	
	var input = Vector2( Input.get_axis("izquierda", "derecha"), Input.get_axis("adelante", "atras"))
	var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	
	if direction:
		speed = SPEED

	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		speed *= JUMP_MULT
		
		
		jumping = true

	if Input.is_action_pressed("agacharse"):
		speed *= CROUCH_MULT
		crouching = true
		
	if Input.is_action_pressed("correr"):
		speed *= RUN_MULT
		running = true

	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, ACCELERATION)  
		velocity.z = move_toward(velocity.z, direction.z * speed, ACCELERATION)  

	elif not is_on_floor():
		
		var a = Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
		speed = clamp(speed, SPEED, MAX_SPEED)
		
		velocity.x = move_toward(velocity.x, a.x * SPEED, 0.04)  
		velocity.z = move_toward(velocity.z, a.z * SPEED, 0.04) 

	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION)

	if not is_on_floor():
		velocity.y -= gravity * delta

	last_direction = direction
	move_and_slide()

	if Input.is_action_just_pressed("disparar"):
		var t  = $MeshInstance3D/Pivote/GunCoso/Gun/RayCast3D.get_collider()
		if t is Player:
			t.take_damage()
			t.rpc_id(t.get_multiplayer_authority(), "take_damage")
#		GlobalStats.increase(get_parent().current_team)
#
	$UI/ProgressBar.value = vida

@rpc("any_peer", "call_local")
func take_damage():
	vida -= 25
	
func _input(event):
	if not nuestro: return
	
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad( -1 * event.relative.x * MOUSE_SENS))
		pivote.rotate_x( deg_to_rad(event.relative.y) * MOUSE_SENS * -1 )
		pivote.rotation.x = clamp(pivote.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
	
func _exit_tree():
	GlobalStats.remove_id(multiplayer.get_unique_id())

func jump_boost():
	velocity.y = JUMP_VELOCITY * 3
	print("Salta fuerte")
