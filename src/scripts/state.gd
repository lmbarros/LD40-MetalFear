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

	var wasLocalAlarmRinging = isLocalAlarmRinging()

	alarmLevel += dist * Player.metalCarried() * 0.0005
	alarmLevel = clamp(alarmLevel, 0, 1)

	if wasLocalAlarmRinging && isGlobalAlarmRinging():
		emit_signal("globalAlarmRung")


func playerShoot(dist):
	alarmLevel = clamp(alarmLevel, 0, 1)


# ------------------------------------------------------------------------------
# General
# ------------------------------------------------------------------------------
func reset():
	magnets = []

func _process(delta):
	var wasLocalAlarmRinging = isLocalAlarmRinging()
	
	if isAnyAlarmRinging() && foeCount > 0:
		alarmLevel += delta * 0.025
	else:
		alarmLevel -= delta * 0.01

	alarmLevel = clamp(alarmLevel, 0, 1)

	if wasLocalAlarmRinging && isGlobalAlarmRinging():
		emit_signal("globalAlarmRung")
