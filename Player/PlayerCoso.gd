extends Node

var current_team = null

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	set_multiplayer_authority(int(str(name)))

func _ready():
	$Control.visible = is_multiplayer_authority()
	$UI.visible = is_multiplayer_authority()

func _process(delta):
	$UI/Label.set_text("FPS " + str(Engine.get_frames_per_second()))
	
	$UI/Team.text = "team 0: " + str(GlobalStats.teams[0].score) + "\n" + "team 1: " + str(GlobalStats.teams[1].score) \
	+ "\n" + "vos sos team: "+ str(current_team)


func _on_button_pressed():
	var character = preload("res://Player/Player.tscn").instantiate()
	
	
	current_team = $Control/SpinBox.value
	
	GlobalStats.add_id(current_team, multiplayer.get_unique_id())
	
	add_child(character)
	$Control.hide()
	
	
