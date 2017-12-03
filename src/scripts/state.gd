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
# Alarm
# ------------------------------------------------------------------------------

var alarmLevel = 0.0

func isAnyAlarmRinging():
	return alarmLevel > 0.75

func isLocalAlarmRinging():
	return alarmLevel > 0.75 && alarmLevel <= 0.9

func isGlobalAlarmRinging():
	return alarmLevel > 0.9

func playerWasSpotted():
	alarmLevel = 0.76

# ------------------------------------------------------------------------------
# General
# ------------------------------------------------------------------------------
func reset():
	magnets = []
