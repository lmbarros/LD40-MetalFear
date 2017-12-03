extends ColorRect


func _on_goButton_pressed():
	Player.arsenal = [ Weapons.fist ]
	if $knifeToggle.pressed:
		Player.arsenal.push_back(Weapons.knife)
	if $pistolToggle.pressed:
		Player.arsenal.push_back(Weapons.pistol)
	if $rifleToggle.pressed:
		Player.arsenal.push_back(Weapons.rifle)

	get_tree().change_scene("res://scenes/sectors/a1.tscn")
	Sound.playTense()
	State.startGame()
