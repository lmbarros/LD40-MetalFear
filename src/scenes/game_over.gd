extends ColorRect

var canGo = false

func _input(event):
	if canGo && event is InputEventKey or event is InputEventJoypadButton:
		get_tree().change_scene("res://scenes/title.tscn")


func _on_timer_timeout():
	canGo = true
