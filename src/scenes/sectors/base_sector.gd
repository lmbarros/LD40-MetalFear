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
onready var Henchman = preload("res://scenes/foes/henchman.tscn")

func globalAlarmRung():
	# Spawn foes
	for i in range($spawnPoints.get_child_count()):
		var pos = $spawnPoints.get_child(i).position
		var foe = Henchman.instance()
		foe.position = pos
		get_tree().get_current_scene().add_child(foe)
