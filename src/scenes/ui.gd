extends CanvasLayer

func _process(delta):
	$pane/alarmLevel.value = clamp(State.alarmLevel * 100.0, 0, 100)
	$pane/labelMetalAmount/metalAmount.text = str(Player.metalCarried()) + " kg"
