extends Node2D

const playerOffset = 40

func _ready():
	State.connect("globalAlarmRung", self, "globalAlarmRung")

# ------------------------------------------------------------------------------
# Movement between sectors
# ------------------------------------------------------------------------------
func rightToSector(sector):
	if State.isAnyAlarmRinging():
		return
	get_tree().change_scene(sectorPath(sector))
	Player.position.x = playerOffset
	
func leftToSector(sector):
	if State.isAnyAlarmRinging():
		return
	get_tree().change_scene(sectorPath(sector))
	Player.position.x = State.width - playerOffset
	
func sectorPath(sector):
	return "res://scenes/sectors/" + sector + ".tscn"

# ------------------------------------------------------------------------------
# Alarm-related stuff
# ------------------------------------------------------------------------------
func globalAlarmRung():
	print("uuuuuuuuuuuuuuuummm!!!!")
