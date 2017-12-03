extends CanvasLayer

func _process(delta):
	$pane/alarmLevel.value = clamp(State.alarmLevel * 100.0, 0, 100)
	$pane/labelMetalAmount/metalAmount.text = str(Player.metalCarried()) + " kg"
	
	var health = clamp(Player.health, 0, Player.maxHealth)
	health /= Player.maxHealth
	health *= 100
	$pane/healthLevel.value = health
