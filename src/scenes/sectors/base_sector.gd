extends Node2D

const playerOffset = 40

func _ready():
	State.connect("globalAlarmRung", self, "globalAlarmRung")
	State.reset()

	if Player.justStarting:
		State.startGame()
		Player.justStarting = false
		Player.position = $startingPoint.position
		Player.rotation = PI/2

	for c in get_children():
		if c.has_method("imMagnet") :
			State.addMagnet(c.position, c.strength)


# ------------------------------------------------------------------------------
# Movement between sectors
# ------------------------------------------------------------------------------
func rightToSector(sector):
	if cannotLeaveSector():
		return
	get_tree().change_scene(sectorPath(sector))
	Player.position.x = playerOffset

func leftToSector(sector):
	if cannotLeaveSector():
		return
	get_tree().change_scene(sectorPath(sector))
	Player.position.x = State.width - playerOffset

func upToSector(sector):
	if cannotLeaveSector():
		return
	get_tree().change_scene(sectorPath(sector))
	Player.position.y = State.height - playerOffset

func downToSector(sector):
	if cannotLeaveSector():
		return
	get_tree().change_scene(sectorPath(sector))
	Player.position.y = playerOffset


func sectorPath(sector):
	return "res://scenes/sectors/" + sector + ".tscn"

func cannotLeaveSector():
	return State.isGlobalAlarmRinging() \
		|| (State.isLocalAlarmRinging() && State.foeCount > 0)

func enablePortals():
	for c in get_children():
		if c is Area2D:
			c.monitoring = true

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
