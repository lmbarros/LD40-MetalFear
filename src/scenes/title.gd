extends Node

var canGo = false

func _ready():
	State.stopGame()
	Sound.playTheme()

func _input(event):
	if canGo && event is InputEventKey or event is InputEventJoypadButton:
		get_tree().change_scene("res://scenes/sectors/a1.tscn")
		Sound.playTense()
		State.startGame()

func _on_timer_timeout():
	canGo = true
