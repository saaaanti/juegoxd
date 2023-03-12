extends Node
class_name Gun

@export var dmg := 10
@export var eff_range := 15
@export var rpm = 60.0
@export var mag_size = 10

@export var custom_shoot_func : Callable


signal shoot_signal
signal start_reload
signal end_reload
signal ready_to_shoot

var timer = Timer.new()
var raycast = RayCast3D.new() # Después vemos que onda las escopetas

var can_shoot = true

func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = (1.0 / rpm) * 60.0
	

	
	timer.timeout.connect(_timer_timeout)
	

	get_parent().add_child.call_deferred(raycast)
	
	raycast.target_position.z = eff_range * -1.25
	raycast.target_position.y = 0
	
func shoot():
	
	if timer.time_left > 0: return
	
	shoot_signal.emit()
	can_shoot = false
	timer.start()
	
	
	
	var t = raycast.get_collider()
	if t is Player:
		# t.take_damage(dmg) # * falloff # Creo que este de arriba no hace falta
		t.rpc_id(t.get_multiplayer_authority(), "take_damage", dmg)

	
	
	
	if custom_shoot_func:
		custom_shoot_func.call()
	
	return t

func _timer_timeout():
	can_shoot = true
	ready_to_shoot.emit()
	
	
	
	
	


