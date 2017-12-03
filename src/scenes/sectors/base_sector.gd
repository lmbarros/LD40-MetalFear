extends Node2D

const playerOffset = 40

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

