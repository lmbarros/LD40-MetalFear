extends Node

const width = 1080 # window width minus UI width
const height = 720

# ------------------------------------------------------------------------------
# Magnets
# ------------------------------------------------------------------------------
var magnets = []
const maxSqDist = 1280 * 1280

func addMagnet(position, strength):
	magnets.push_back({pos = position, strength = strength})


func magnetAttraction(pos):
	var attraction = Vector2(0.0, 0.0)
	
	for m in magnets:
		var distFactor = \
			(maxSqDist - m.pos.distance_squared_to(pos)) / maxSqDist
		
		attraction += m.strength * distFactor * (m.pos - pos).normalized()

	return attraction

# ------------------------------------------------------------------------------
# Metal detectors
# ------------------------------------------------------------------------------
var inMetalDetector = false

func enterMetalDetector():
	inMetalDetector = true

func exitMetalDetector():
	inMetalDetector = false


# ------------------------------------------------------------------------------
# Enemy count
# ------------------------------------------------------------------------------
var foeCount = 0

func foeCreated():
	foeCount += 1

func foeDied():
	foeCount -= 1
	if foeCount == 0 && isAnyAlarmRinging():
		alarmLevel = 0.5

func foeLeftScene():
	foeCount -= 1

# ------------------------------------------------------------------------------
# Alarm
# ------------------------------------------------------------------------------

signal globalAlarmRung # "rang"?

var alarmLevel = 0.0

func isAnyAlarmRinging():
	return alarmLevel > 0.75

func isLocalAlarmRinging():
	return alarmLevel > 0.75 && alarmLevel <= 0.9

func isGlobalAlarmRinging():
	return alarmLevel > 0.9

func playerWasSpotted():
	alarmLevel = 0.76

func playerWalked(dist):
	if isAnyAlarmRinging() && foeCount > 0:
		return
	var amount = dist * Player.metalCarried() * 0.0005
	changeAlarmLevelBy(amount)

func playerAttacked(weapon):
	changeAlarmLevelBy(weapon.noise)

func changeAlarmLevelBy(amount):
	var wasLocalAlarmRinging = isLocalAlarmRinging()
	alarmLevel += amount
	alarmLevel = clamp(alarmLevel, 0, 1)
	if wasLocalAlarmRinging && isGlobalAlarmRinging():
		emit_signal("globalAlarmRung")

# ------------------------------------------------------------------------------
# General
# ------------------------------------------------------------------------------
func reset():
	magnets = []

func ready():
	randomize()

func _process(delta):
	var alarmDelta = 0.0

	if isAnyAlarmRinging() && foeCount > 0:
		alarmDelta = delta * 0.025
	else:
		alarmDelta = -delta * 0.01

	changeAlarmLevelBy(alarmDelta)
