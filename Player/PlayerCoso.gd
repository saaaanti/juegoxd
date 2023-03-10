extends Node

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	set_multiplayer_authority(int(str(name)))

func _ready():
	$Control.visible = is_multiplayer_authority()

func _on_button_pressed():
	var character = preload("res://Player/Player.tscn").instantiate()
	add_child(character)
	$Control.hide()
